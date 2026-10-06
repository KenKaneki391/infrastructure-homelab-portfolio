# Infrastructure & Cloud Homelab Portfolio

Portfolio technique orienté **administration systèmes, infrastructure Microsoft, réseau et automatisation**.

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

## PowerShell

Les scripts utilisés dans le lab sont regroupés dans [`scripts/powershell`](scripts/powershell/README.md).

- `Get-ADInactiveUsers.ps1` — audit non destructif de comptes Active Directory inactifs.

## Technologies documentées

- Windows Server
- Active Directory Domain Services
- DNS / DHCP / Group Policy
- SMB / NTFS
- PowerShell
- FortiGate

## Certifications

- Microsoft Certified: **Azure Administrator Associate (AZ-104)**
- Microsoft Certified: **Endpoint Administrator Associate (MD-102)**

## Sécurité

Ce dépôt contient uniquement du matériel provenant d'un laboratoire personnel.

Aucun secret, credential, token, donnée d'employeur ou information client n'est publié. Voir [`SECURITY.md`](SECURITY.md).
