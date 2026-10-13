# Projet 02 — Microsoft Configuration Manager (MECM)

**État : terminé**

## Objectif

Construire un site Microsoft Configuration Manager fonctionnel dans le laboratoire, intégrer Active Directory, gérer un poste Windows 10 et valider un déploiement applicatif complet via Software Center.

Le projet couvre l'installation du site, l'intégration AD, l'onboarding du client, la distribution de contenu, le déploiement d'une application EXE et plusieurs incidents réellement diagnostiqués à partir des logs MECM.

## Résultat final

Le laboratoire est validé de bout en bout :

- site primaire standalone **MTP** opérationnel ;
- SQL Server 2022 et base **CM_MTP** fonctionnels ;
- Management Point et Distribution Point opérationnels ;
- découverte Active Directory fonctionnelle ;
- boundary et boundary group associés au VLAN30 ;
- poste **MININT-J8ODACM** géré avec **Client = Yes** et **Site Code = MTP** ;
- collection pilote **LAB - Pilot Workstations** ;
- application **7-Zip x64 - EXE** distribuée et installée via Software Center ;
- installation validée par `AppEnforce.log` avec **exit code 0** et détection post-installation positive.

![7-Zip installé dans Software Center](assets/10-software-center-7zip-installed.jpg)

## Documentation

| Document | Contenu |
| --- | --- |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Architecture du lab, rôles MECM, réseau et boundary group |
| [INSTALLATION-AND-RECOVERY.md](INSTALLATION-AND-RECOVERY.md) | Installation du site et récupération après l'incident SQL ACCESS |
| [CLIENT-ONBOARDING.md](CLIENT-ONBOARDING.md) | AD Discovery, Client Push, firewall, ADMIN$ et authentification |
| [APPLICATION-DEPLOYMENT.md](APPLICATION-DEPLOYMENT.md) | Collection pilote, application EXE, DP, Software Center et logs |
| [TROUBLESHOOTING.md](TROUBLESHOOTING.md) | Synthèse des incidents, causes racines, corrections et validations |

## Environnement

- `MECM.lab.local` — Windows Server 2022 Datacenter Evaluation ;
- Microsoft Configuration Manager 2509 Evaluation ;
- site code `MTP` ;
- SQL Server 2022, instance par défaut ;
- base de site `CM_MTP` ;
- `Win19.lab.local` — contrôleur de domaine / DNS du domaine `lab.local` ;
- `MININT-J8ODACM` — poste Windows 10 géré par MECM ;
- VLAN30 : `192.168.30.0/24`.

Architecture détaillée : [ARCHITECTURE.md](ARCHITECTURE.md)

## Installation et remise en état du site

Le site a été installé en architecture **standalone Primary Site**, avec SQL Server, SMS Provider, Management Point et Distribution Point sur `MECM.lab.local`.

La préparation comprenait notamment SQL Server 2022, Windows ADK, WinPE, IIS, BITS, .NET et le conteneur Active Directory `System Management` avec délégation au compte ordinateur `LAB\MECM$`.

Pendant le setup, un premier blocage sur le composant OLE DB a été résolu en installant Microsoft OLE DB Driver 19. La version validée sur le serveur est `19.3.5.0`.

Après le Core Setup, le site restait incomplet : `SMS_SITE_COMPONENT_MANAGER` fonctionnait, mais `SMS_EXECUTIVE` n'était pas créé et `sitecomp.log` répétait :

```text
Unknown SQL Error!
Failed to connect to the SQL Server, connection type: SMS ACCESS.
Failed to read site information from database, retry in 5 seconds ...
```

Le réseau SQL, la base `CM_MTP`, TCP 1433 et la connexion OLE DB ont été validés indépendamment. Le problème a été isolé sur **Microsoft ODBC Driver 18.7.1.1**.

Après rollback vers **ODBC Driver 18.6.2.1** et redémarrage :

- `SMS_EXECUTIVE` est apparu et a démarré ;
- `SMS_SITE_COMPONENT_MANAGER` est resté opérationnel ;
- les composants du site ont repris leur installation ;
- les erreurs `SMS ACCESS` ont disparu.

Documentation détaillée : [INSTALLATION-AND-RECOVERY.md](INSTALLATION-AND-RECOVERY.md)

## Découverte Active Directory et affectation réseau

**Active Directory System Discovery** a été activé afin d'importer les ordinateurs du domaine dans MECM.

Le poste `MININT-J8ODACM` est apparu dans **Assets and Compliance > Devices**.

Le réseau du lab a été déclaré avec :

```text
Boundary       : LAB-VLAN30
Plage          : 192.168.30.1 - 192.168.30.254
Boundary Group : BG-LAB-VLAN30
Site assignment: MTP
Site system    : MECM.lab.local
```

![Boundary Group VLAN30](assets/03-boundary-group-vlan30.jpg)

## Installation du client MECM

Le client a été installé sur `MININT-J8ODACM` avec **Client Push Installation**.

Deux problèmes distincts ont été diagnostiqués :

1. TCP 135 répondait mais TCP 445 était bloqué par Windows Firewall, empêchant l'accès à `ADMIN$` ;
2. après correction du firewall, `ccm.log` retournait `NetUseAdd failed: 1326` pour le compte Client Push.

Après correction des règles firewall et réenregistrement du compte Client Push avec le bon mot de passe, `ccm.log` a confirmé :

```text
NetUseAdd succeeded for LAB\Administrator!
Connected to administrative share on machine MININT-J8ODACM.lab.local
NetUseAdd succeeded for IPC$!
Copying client files to \\MININT-J8ODACM.lab.local\admin$\ccmsetup.
Submitted request successfully
```

Validation finale :

```text
MININT-J8ODACM
Client    : Yes
Site Code : MTP
```

![Client Windows 10 géré par le site MTP](assets/04-client-managed-mtp.jpg)

Documentation détaillée : [CLIENT-ONBOARDING.md](CLIENT-ONBOARDING.md)

## Collection pilote et déploiement applicatif

Une collection dédiée a été créée :

```text
LAB - Pilot Workstations
```

avec `MININT-J8ODACM` comme membre de test.

Une application **7-Zip x64 - EXE** a ensuite été créée avec un Deployment Type de type **Script Installer**.

Commande d'installation :

```text
7z2604-x64.exe /S
```

Le contenu a été distribué sur le Distribution Point puis déployé vers la collection pilote.

`AppEnforce.log` confirme l'exécution en contexte machine depuis le cache MECM :

```text
ContentPath - C:\WINDOWS\ccmcache\1
Execution Context - System
Prepared command line: "C:\WINDOWS\ccmcache\1\7z2604-x64.exe" /S
Process 7880 terminated with exitcode: 0
Matched exit code 0 to a Success entry in exit codes table.
+++ Discovered application
++++++ App enforcement completed (1 seconds)
```

Documentation détaillée : [APPLICATION-DEPLOYMENT.md](APPLICATION-DEPLOYMENT.md)

## Preuves visuelles

### Site et rôles

![Vue du site MTP](assets/01-mecm-site-mtp-overview.jpg)

![Rôles du serveur MECM](assets/02-mecm-site-system-roles.jpg)

### Déploiement applicatif

![Collection pilote](assets/05-pilot-device-collection.jpg)

![Deployment Type EXE](assets/06-7zip-exe-deployment-type.jpg)

![Méthode de détection](assets/07-7zip-detection-method.jpg)

![Distribution du contenu réussie](assets/08-7zip-content-distribution-success.jpg)

![7-Zip disponible dans Software Center](assets/09-software-center-7zip-available.jpg)

![7-Zip installé dans Software Center](assets/10-software-center-7zip-installed.jpg)

## Troubleshooting

Trois incidents sont documentés de bout en bout :

1. **Post-setup MECM bloqué sur SQL ACCESS** ;
2. **Client Push bloqué par Windows Firewall sur TCP 445** ;
3. **Client Push refusé avec erreur 1326** à cause des credentials enregistrés.

La méthode utilisée est constante :

```text
Symptôme
  ↓
Log correspondant
  ↓
Test ciblé
  ↓
Isolation de la couche en panne
  ↓
Cause racine
  ↓
Correction
  ↓
Validation finale
```

Synthèse : [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

## Compétences mises en pratique

- installation et configuration de MECM ;
- SQL Server pour Configuration Manager ;
- SMS Provider, Management Point et Distribution Point ;
- Active Directory System Discovery ;
- boundaries et boundary groups ;
- Client Push Installation ;
- SMB, RPC et partages administratifs ;
- Windows Firewall ;
- collections pilotes ;
- distribution de contenu ;
- déploiement d'applications EXE ;
- méthodes de détection ;
- Software Center ;
- analyse de `sitecomp.log`, `ccm.log`, `AppDiscovery.log` et `AppEnforce.log` ;
- dépannage structuré du serveur jusqu'au client.

## Sécurité

Toutes les données présentées proviennent du laboratoire personnel. Aucun secret, credential, token, environnement d'employeur ou donnée client n'est publié.
