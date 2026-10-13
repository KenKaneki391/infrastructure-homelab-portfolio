# Architecture — MECM Lab

## Vue générale

    lab.local
       |
       +----------------------+----------------------+
       |                                             |
    Win19.lab.local                               MECM.lab.local
    192.168.30.50                                 192.168.30.60
    Windows Server 2019                           Windows Server 2022
    AD DS / DNS                                   ConfigMgr 2509
                                                  SQL Server 2022
                                                  Primary Site MTP
                                                  SMS Provider
                                                  Management Point
                                                  Distribution Point
                                                         |
                                                         |
                                                 VLAN30 / Boundary
                                                 192.168.30.0/24
                                                         |
                                                         |
                                                MININT-J8ODACM
                                                Windows 10
                                                ConfigMgr Client

## Site Configuration Manager

- serveur : MECM.lab.local ;
- site code : MTP ;
- type : standalone Primary Site ;
- base SQL : CM_MTP ;
- SQL Server : instance par défaut ;
- port SQL : 1433 ;
- Service Broker : 4022.

## Rôles installés

Le serveur de lab héberge les rôles nécessaires au scénario :

- Site Server ;
- Site Database Server ;
- SMS Provider ;
- Management Point ;
- Distribution Point ;
- Component Server.

L'architecture all-in-one est volontaire : elle permet de pratiquer le fonctionnement de MECM sans ajouter de complexité de production inutile au laboratoire.

## Active Directory

Domaine :

    lab.local

Le conteneur System Management a été préparé dans Active Directory et le compte ordinateur LAB\MECM$ a reçu les permissions nécessaires sur ce conteneur.

**Active Directory System Discovery** est utilisé pour découvrir les postes du domaine.

## Réseau et boundaries

Réseau client :

    192.168.30.0/24

Boundary :

    LAB-VLAN30
    192.168.30.1 - 192.168.30.254

Boundary Group :

    BG-LAB-VLAN30

Références :

- site assignment : MTP ;
- site system : MECM.lab.local.

Le boundary permet au client de déterminer qu'il appartient à un réseau géré par le site. Le boundary group associe ensuite ce réseau au site et au site system utilisé pour les services et le contenu.

## Client géré

Client principal du scénario :

    MININT-J8ODACM
    Windows 10
    Site Code: MTP
    Client: Yes

Le client est découvert via Active Directory, affecté au site par le boundary group, puis installé avec Client Push.

## Flux applicatif validé

    Application MECM
          |
    Deployment Type EXE
          |
    Content distribué au DP
          |
    LAB - Pilot Workstations
          |
    MININT-J8ODACM
          |
    ccmcache
          |
    Installation en contexte SYSTEM
          |
    Detection Method
          |
    Software Center = Installed
