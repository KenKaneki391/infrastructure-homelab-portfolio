# PowerShell — Scripts de laboratoire

Ce dossier regroupe les scripts PowerShell utilisés dans le lab.

## `Get-ADInactiveUsers.ps1`

Script non destructif qui identifie les comptes Active Directory actifs dont la dernière ouverture de session connue est antérieure à un nombre de jours donné.

Exemple :

```powershell
.\Get-ADInactiveUsers.ps1 -InactiveDays 90
```

Le nombre de jours est fourni par paramètre et le script ne modifie aucun objet Active Directory.
