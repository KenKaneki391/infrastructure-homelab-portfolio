# Infrastructure & Cloud Homelab Portfolio

Portfolio technique orienté **administration systèmes, infrastructure Microsoft, endpoint management, réseau et automatisation**.

L'objectif est simple : ne pas seulement lister des technologies, mais montrer ce que j'ai **configuré, testé, cassé, diagnostiqué et corrigé** dans un environnement de laboratoire personnel.

## Projet principal

### Windows Server & Active Directory

[Voir le projet](projects/01-windows-server-ad/README.md)

Environnement documenté autour de Windows Server 2019, Active Directory, DNS, Group Policy, SMB/NTFS et PowerShell, avec intégration réseau FortiGate pour la passerelle et le DHCP.

Compétences démontrées :

- Active Directory Domain Services ;
- DNS Active Directory ;
- OU, utilisateurs et groupes ;
- Group Policy et Security Filtering ;
- jointure et validation d'un poste de domaine ;
- permissions SMB et NTFS ;
- modèle AGDLP ;
- PowerShell ;
- dépannage méthodique Windows / AD.

Trois incidents ont été reproduits et documentés de bout en bout :

1. **GPO non appliquée** à cause du Security Filtering ;
2. **Access is denied** sur un partage SMB à cause d'une mauvaise appartenance de groupe et d'un ancien contexte de session ;
3. **Découverte Active Directory en panne** à cause d'un DNS client incorrect.

Chaque scénario suit la même logique : **symptôme → tests → cause racine → correction → validation**.

## PowerShell

Les scripts publiés se trouvent dans [`scripts/powershell`](scripts/powershell/README.md).

Actuellement :

- `Get-ADInactiveUsers.ps1` — audit non destructif de comptes Active Directory inactifs.

## Technologies

- Windows Server
- Active Directory Domain Services
- DNS / DHCP / Group Policy
- SMB / NTFS
- PowerShell
- FortiGate
- Microsoft Azure
- Microsoft Intune / Entra ID
- MECM / SCCM

## Certifications

- Microsoft Certified: **Azure Administrator Associate (AZ-104)**
- Microsoft Certified: **Endpoint Administrator Associate (MD-102)**

## Roadmap

Les prochains projets publics seront ajoutés uniquement après validation pratique et documentation :

- MECM / SCCM ;
- FortiGate ;
- Intune / Entra ID ;
- Azure ;
- automatisation avec PowerShell, Terraform ou Bicep.

## Sécurité

Ce dépôt contient uniquement du matériel provenant d'un laboratoire personnel.

Aucun secret, credential, token, donnée d'employeur ou information client ne doit être publié. Voir [`SECURITY.md`](SECURITY.md).
