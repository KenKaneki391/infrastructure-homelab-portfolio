# Infrastructure & Cloud Homelab Portfolio

Portfolio technique orienté **administration systèmes, infrastructure Microsoft, réseau, endpoint management et automatisation**.

L'objectif est de documenter ce que j'ai réellement **configuré, testé, diagnostiqué et corrigé** dans un environnement de laboratoire personnel.

## Windows Server & Active Directory

[Voir le projet](projects/01-windows-server-ad/README.md)

Environnement documenté autour de Windows Server 2019, Active Directory, DNS, Group Policy, SMB/NTFS, PowerShell et FortiGate.

Compétences couvertes :

- Active Directory Domain Services ;
- DNS Active Directory ;
- OU, utilisateurs et groupes ;
- Group Policy et Security Filtering ;
- jointure et validation d'un poste de domaine ;
- permissions SMB et NTFS ;
- modèle AGDLP ;
- VLAN, DHCP et intégration FortiGate ;
- PowerShell ;
- dépannage méthodique Windows / AD / réseau.

Quatre scénarios sont documentés de bout en bout :

1. **GPO non appliquée** à cause du Security Filtering ;
2. **Access is denied** sur un partage SMB à cause d'une mauvaise appartenance de groupe et d'un ancien contexte de session ;
3. **Découverte Active Directory en panne** à cause d'un DNS client incorrect ;
4. **Audit VLAN30 / DHCP** avec suppression d'un relay obsolète, correction du scope et validation client après renouvellement du bail.

Chaque scénario suit la même logique : **symptôme → tests → cause racine → correction → validation**.

## Microsoft Configuration Manager (MECM)

[Voir le projet](projects/02-mecm/README.md)

Déploiement d'un site Microsoft Configuration Manager 2509 dans le lab, intégration Active Directory, onboarding d'un poste Windows 10 et déploiement applicatif EXE via Software Center.

Compétences couvertes :

- installation et validation d'un Primary Site MECM ;
- SQL Server 2022 et base de site CM_MTP ;
- SMS Provider, Management Point et Distribution Point ;
- Active Directory System Discovery ;
- boundaries et boundary groups ;
- Client Push Installation ;
- diagnostic SMB / RPC / ADMIN$ ;
- dépannage des comptes Client Push ;
- création d'une application EXE ;
- distribution de contenu ;
- collection pilote ;
- Software Center ;
- lecture de ccm.log, AppDiscovery.log, AppEnforce.log et sitecomp.log.

Trois incidents réels sont documentés :

1. **Post-setup MECM bloqué sur SQL ACCESS** après installation ;
2. **Client Push bloqué par Windows Firewall** sur TCP 445 ;
3. **Client Push refusé avec erreur 1326** à cause des credentials enregistrés.

Le déploiement final de 7-Zip en EXE est validé par un code retour 0, une détection post-installation positive et l'état **Installed** dans Software Center.

## PowerShell

Les scripts utilisés dans le lab sont regroupés dans [scripts/powershell](scripts/powershell/README.md).

- Get-ADInactiveUsers.ps1 — audit non destructif de comptes Active Directory inactifs.

## Technologies documentées

- Windows Server
- Active Directory Domain Services
- DNS / DHCP / Group Policy
- SMB / NTFS
- Microsoft Configuration Manager (MECM)
- SQL Server
- Software Center
- PowerShell
- FortiGate

## Certifications

- Microsoft Certified: **Azure Administrator Associate (AZ-104)**
- Microsoft Certified: **Endpoint Administrator Associate (MD-102)**

## Sécurité

Ce dépôt contient uniquement du matériel provenant d'un laboratoire personnel.

Aucun secret, credential, token, donnée d'employeur ou information client n'est publié. Voir [SECURITY.md](SECURITY.md).
