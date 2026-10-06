<#
.SYNOPSIS
    Exemple de script de laboratoire pour identifier des comptes AD inactifs.

.DESCRIPTION
    À utiliser uniquement dans un environnement de test.
    Le script ne modifie aucun compte : il produit simplement une liste.
#>

param(
    [int]$InactiveDays = 90
)

$CutoffDate = (Get-Date).AddDays(-$InactiveDays)

Get-ADUser -Filter * -Properties LastLogonDate, Enabled |
    Where-Object {
        $_.Enabled -eq $true -and
        $_.LastLogonDate -and
        $_.LastLogonDate -lt $CutoffDate
    } |
    Select-Object Name, SamAccountName, LastLogonDate |
    Sort-Object LastLogonDate
