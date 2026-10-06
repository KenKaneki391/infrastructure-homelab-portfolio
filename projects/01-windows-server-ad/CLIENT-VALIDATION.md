# Validation d'un poste membre du domaine

Cette page documente une validation réelle effectuée sur le poste Windows `MININT-J8ODACM`.

## État du poste

- **Nom :** `MININT-J8ODACM`
- **OS :** Windows 10 build 19045
- **Domaine :** `lab.local`
- **Membre du domaine :** Oui
- **DNS reçu :** `192.168.30.50`
- **DHCP :** FortiGate

Le poste possède deux cartes réseau actives :

| Interface | IPv4 | Gateway | DNS |
|---|---|---|---|
| Ethernet | `192.168.10.124/24` | `192.168.10.1` | `192.168.30.50` |
| Ethernet 2 | `192.168.30.52/24` | `192.168.30.1` | `192.168.30.50` |

## Vérifications réalisées

### 1. Appartenance au domaine

```powershell
(Get-CimInstance Win32_ComputerSystem) | Select Name,Domain,PartOfDomain
```

Résultat confirmé :

```text
Domain       : lab.local
PartOfDomain : True
```

### 2. Secure channel

```powershell
Test-ComputerSecureChannel -Verbose
```

Résultat : `True`.

Cela confirme que la relation de confiance entre le poste et le domaine est valide.

### 3. Découverte du contrôleur de domaine

```powershell
nltest /dsgetdc:lab.local
```

Résultat principal :

```text
DC      : Win19.lab.local
Address : 192.168.30.50
Site    : site-lab
```

Le client détecte correctement les rôles AD/DNS/Kerberos/LDAP exposés par le contrôleur de domaine.

### 4. Application des stratégies de groupe

```cmd
gpresult /r
```

Résultats observés côté ordinateur :

- configuration : Member Workstation ;
- site : `site-lab` ;
- GPO appliquée depuis `Win19.lab.local` ;
- `Default Domain Policy` appliquée ;
- objet ordinateur actuellement dans `CN=Computers,DC=lab,DC=local`.

## Observation importante : session utilisateur locale

La commande `gpresult /r` a été exécutée dans une session `MININT-J8ODACM\Administrator`, donc avec un **compte local**.

Il est donc normal de ne voir aucune stratégie utilisateur de domaine dans cette session. Une validation séparée doit être faite après ouverture de session avec un utilisateur `LAB\...`.

## Observation importante : objet ordinateur dans CN=Computers

Le poste est actuellement dans le conteneur Active Directory par défaut :

```text
CN=Computers,DC=lab,DC=local
```

Ce conteneur n'est pas une OU. Pour tester proprement des GPO personnalisées liées à une OU, le poste devra être déplacé dans une OU de postes dédiée ou une OU métier appropriée.

## Analyse réseau : deux interfaces et deux routes par défaut

Les commandes suivantes ont été utilisées pour inspecter le routage :

```powershell
route print
Get-NetIPInterface | Sort-Object InterfaceMetric
Get-NetRoute -AddressFamily IPv4
```

Constats :

- les deux interfaces IPv4 sont connectées ;
- les deux interfaces ont une métrique d'interface de `25` ;
- deux routes par défaut `0.0.0.0/0` existent ;
- les deux routes ont la même métrique de route ;
- `Ethernet` utilise `192.168.10.1` comme gateway ;
- `Ethernet 2` utilise `192.168.30.1` comme gateway.

Cela crée deux chemins par défaut de coût équivalent. Ce n'est généralement pas souhaitable sur un poste classique, car le chemin de sortie peut devenir moins prévisible.

En revanche, l'accès au contrôleur de domaine `192.168.30.50` ne dépend pas d'une route par défaut : le réseau `192.168.30.0/24` est directement connecté à `Ethernet 2`. Windows utilise donc la route plus spécifique vers ce sous-réseau pour joindre le DC.

Avant toute correction, le rôle de chaque carte réseau doit être confirmé. Si une seule interface doit fournir l'accès par défaut, la bonne pratique sera de conserver une seule gateway par défaut ou de différencier explicitement les métriques selon le besoin du lab.

## Prochain test recommandé

1. Confirmer le rôle attendu de chaque interface réseau.
2. Déplacer le compte ordinateur dans une OU dédiée de test.
3. Créer une GPO simple et facilement vérifiable.
4. Exécuter `gpupdate /force` puis `gpresult /r`.
5. Ouvrir une session avec un utilisateur de domaine pour valider séparément les GPO utilisateur.
