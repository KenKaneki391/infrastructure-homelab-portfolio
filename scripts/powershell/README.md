# PowerShell — Scripts de laboratoire

Ce dossier contient uniquement des scripts que je peux expliquer et défendre en entretien.

## `Get-ADInactiveUsers.ps1`

Script non destructif qui identifie les comptes Active Directory actifs dont la dernière ouverture de session connue est antérieure à un nombre de jours donné.

Exemple :

```powershell
.\Get-ADInactiveUsers.ps1 -InactiveDays 90
```

Le script accepte un paramètre plutôt qu'une valeur codée en dur et ne modifie aucun objet Active Directory.
