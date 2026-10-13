# Installation et récupération du site MECM

## Installation initiale

Le serveur MECM.lab.local a été préparé pour héberger un Primary Site Configuration Manager.

Composants principaux :

- Windows Server 2022 Datacenter Evaluation ;
- SQL Server 2022 ;
- Windows ADK ;
- WinPE Add-on ;
- IIS, BITS, .NET et autres prérequis MECM ;
- Microsoft Configuration Manager 2509 Evaluation.

Paramètres du site :

    Site code     : MTP
    Site server   : MECM.lab.local
    SQL server    : MECM.lab.local
    Database      : CM_MTP
    SQL port      : 1433
    SSB port      : 4022

Le prerequisite checker ne présentait plus d'erreur bloquante avant le lancement de l'installation.

## Incident 1 — installation OLE DB

Au premier lancement, ConfigMgrSetup.log montrait l'installation réussie de SQL Native Client, puis un échec sur :

    Installing ...\msoledbsql.msi
    installation process returned 1603
    Failed to install msoledbsql.msi

Le Microsoft OLE DB Driver 19 a été installé et validé dans le registre :

    InstalledVersion
    19.3.5.0

Après cette correction, le Core Setup a pu aller jusqu'à :

    Core setup has completed

## Incident 2 — post-setup bloqué sur SQL ACCESS

Après le Core Setup :

- la base CM_MTP existait ;
- SMS_SITE_COMPONENT_MANAGER était démarré ;
- SMS_EXECUTIVE était absent ;
- les rôles n'achevaient pas leur initialisation.

sitecomp.log répétait :

    Unknown SQL Error!
    Failed to connect to the SQL Server, connection type: SMS ACCESS.
    CSiteControlEx::GetCurrentSiteInfo: Failed to get SQL connection
    CSiteControlEx::GetSCF:Failed to read site information from database

## Tests effectués

### Base SQL

La base existait :

    CM_MTP

### Réseau SQL

    Test-NetConnection MECM.lab.local -Port 1433
    TcpTestSucceeded : True

SQL écoutait sur IPv4 et IPv6 :

    0.0.0.0:1433
    [::]:1433

### Connexion OLE DB

Une connexion directe vers CM_MTP avec MSOLEDBSQL19 fonctionnait.

### SQL ERRORLOG

Aucun Login failed n'expliquait le comportement de sitecomp.exe.

## Cause isolée

Le serveur utilisait :

    Microsoft ODBC Driver 18 for SQL Server
    18.7.1.1

Le driver a été remplacé par :

    Microsoft ODBC Driver 18 for SQL Server
    18.6.2.1

Puis le serveur a été redémarré.

## Validation après correction

Après rollback :

    SMS_EXECUTIVE              Running
    SMS_SITE_COMPONENT_MANAGER Running

Le log a ensuite montré l'installation normale des composants :

    Installed as a thread of SMS_EXECUTIVE, startup type = "Automatic".
    Started.
    Installation successful.

Le Management Point et les autres composants ont repris leur installation.

## Résultat

Le diagnostic a évité une nouvelle reconstruction du serveur. SQL, le réseau et les permissions ont été testés séparément avant d'isoler la couche réellement en cause.
