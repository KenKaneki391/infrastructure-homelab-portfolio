# Troubleshooting — MECM Lab

## Méthode

Les incidents du projet ont été traités en isolant chaque couche avant de modifier la configuration.

    Symptôme
      ↓
    Log correspondant
      ↓
    Test ciblé
      ↓
    Isolation de la couche en panne
      ↓
    Correction
      ↓
    Validation finale

---

## Incident 1 — sitecomp.exe ne peut pas accéder à SQL

### Symptôme

Après le Core Setup :

- CM_MTP existe ;
- SMS_SITE_COMPONENT_MANAGER fonctionne ;
- SMS_EXECUTIVE est absent ;
- les rôles ne terminent pas leur installation.

sitecomp.log :

    Unknown SQL Error!
    Failed to connect to the SQL Server, connection type: SMS ACCESS.
    Failed to read site information from database, retry in 5 seconds ...

### Tests

- SQL Server service actif ;
- base CM_MTP accessible ;
- TCP 1433 ouvert ;
- SQL écoute sur IPv4 et IPv6 ;
- connexion OLE DB directe réussie ;
- droits du compte ordinateur MECM vérifiés ;
- absence de Login failed dans SQL ERRORLOG.

### Cause racine

Le serveur utilisait Microsoft ODBC Driver 18 version 18.7.1.1.

### Correction

Rollback vers :

    18.6.2.1

puis redémarrage du serveur.

### Validation

    SMS_EXECUTIVE              Running
    SMS_SITE_COMPONENT_MANAGER Running

Les composants MECM recommencent à s'installer avec Installation successful.

---

## Incident 2 — Client Push bloqué par Windows Firewall

### Symptôme

Le poste est découvert dans MECM mais le Client Push ne peut pas accéder à ADMIN$.

Tests :

    TCP 135 : True
    TCP 445 : False
    ADMIN$  : False

### Analyse

RPC répond, mais SMB est bloqué. Le problème se situe donc sur la couche firewall / partage administratif, pas sur Active Directory Discovery ou le boundary.

### Correction

Activation des règles Windows Firewall nécessaires à :

- File and Printer Sharing ;
- Windows Management Instrumentation (WMI).

### Validation

- TCP 445 accessible ;
- ADMIN$ accessible depuis MECM.

---

## Incident 3 — Client Push retourne 1326

### Symptôme

Après correction du firewall :

    NetUseAdd failed: 1326

pour :

    LAB\Administrator

Le fallback vers le compte machine échoue également avec :

    NetUseAdd failed: 5

### Cause racine

Les credentials enregistrés dans les paramètres Client Push ne correspondaient plus au mot de passe actuel.

### Correction

Réenregistrement du compte Client Push avec le mot de passe correct.

### Validation

    NetUseAdd succeeded for LAB\Administrator!
    Connected to administrative share
    NetUseAdd succeeded for IPC$!
    Copying client files...
    Submitted request successfully

Le client termine ensuite son installation et apparaît :

    Client = Yes
    Site Code = MTP

---

## Résultat global

Le projet valide plusieurs niveaux de diagnostic :

- SQL et drivers de connectivité ;
- services MECM ;
- lecture de sitecomp.log ;
- RPC vs SMB ;
- Windows Firewall ;
- accès ADMIN$ ;
- authentification Client Push ;
- lecture de ccm.log ;
- validation finale côté console et Software Center.
