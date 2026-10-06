# Infrastructure & Cloud Homelab Portfolio

Portfolio technique orienté **administration systèmes, Microsoft 365, endpoint management, réseau et automatisation**.

L'objectif de ce dépôt est de documenter des compétences pratiques à travers des environnements de laboratoire, des scénarios de troubleshooting et des scripts réutilisables.

> Le principe du portfolio : **ne pas seulement dire ce que je connais, mais montrer ce que j'ai configuré, testé, cassé, diagnostiqué et corrigé.**

## Technologies

- Windows Server
- Active Directory Domain Services
- DNS / DHCP / Group Policy
- Microsoft Endpoint Configuration Manager (MECM / SCCM)
- Microsoft Intune / Microsoft Entra ID
- FortiGate
- PowerShell
- Microsoft Azure

## Projets

| Projet | Compétences démontrées | État | Documentation |
|---|---|---|---|
| Windows Server & Active Directory | AD DS, DNS, DHCP, GPO, domain join, permissions, troubleshooting | En documentation | [Voir le projet](projects/01-windows-server-ad/README.md) |
| MECM / SCCM | Collections, clients, applications, OSD, logs | En documentation | [Voir le projet](projects/02-mecm/README.md) |
| FortiGate | VLAN, routing, firewall policies, NAT, troubleshooting | En documentation | [Voir le projet](projects/03-fortigate/README.md) |
| Intune / Entra ID | Enrollment, compliance, configuration, apps, Autopilot | Lab historique à documenter | [Voir le projet](projects/04-intune/README.md) |

## PowerShell

Les scripts de laboratoire sont disponibles dans [`scripts/powershell`](scripts/powershell/README.md).

Exemples actuels :

- audit de comptes AD inactifs ;
- tests de connectivité vers des services Windows / Active Directory.

## Approche de documentation

Chaque projet vise à contenir :

1. une architecture claire ;
2. les configurations réellement réalisées ;
3. des preuves sanitisées ;
4. au moins un scénario de panne ;
5. la méthode d'investigation ;
6. la cause racine ;
7. la correction ;
8. la validation finale ;
9. des commandes ou scripts lorsque pertinent.

## Certifications

- Microsoft Certified: Azure Administrator Associate (AZ-104)
- Microsoft Certified: Endpoint Administrator Associate (MD-102)

## Roadmap

### Administration systèmes

- finaliser la documentation Windows Server / AD ;
- approfondir PowerShell ;
- documenter davantage de scénarios DNS, GPO et permissions ;
- compléter MECM et FortiGate avec des preuves concrètes.

### Cloud / DevOps

À plus long terme :

- Terraform / Bicep ;
- Git et workflows de collaboration ;
- CI/CD ;
- Docker ;
- GitHub Actions / Azure DevOps.

## Sécurité

Ce dépôt contient uniquement du matériel de laboratoire personnel.

Aucun secret, credential, token, donnée d'employeur ou information client ne doit être publié. Voir [`SECURITY.md`](SECURITY.md).
