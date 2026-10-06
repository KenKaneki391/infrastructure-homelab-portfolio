# Scénario SMB / NTFS — Access Denied

## Résumé

Ce scénario démontre la mise en place d'un partage réseau avec un modèle de groupes **AGDLP**, la validation d'un utilisateur autorisé, la reproduction d'un `Access is denied`, puis le diagnostic et la correction de l'accès.

## Architecture des permissions

```text
Utilisateur
  ↓
GRP-Finance-Users          (Global Security)
  ↓
DL-Finance-RW              (Domain Local Security)
  ↓
\\Win19\Finance
```

Le dossier partagé est hébergé sur :

```text
F:\Shares\Finance
```

### Permissions NTFS

```text
NT AUTHORITY\SYSTEM      FullControl
BUILTIN\Administrators   FullControl
LAB\DL-Finance-RW        Modify
```

### Permissions SMB

```text
LAB\Domain Admins        Full
LAB\DL-Finance-RW        Change
```

## Preuve du modèle AGDLP

![Chaîne AGDLP Finance](assets/09-agdlp-finance-groups.jpg)

La chaîne d'autorisation sépare les comptes utilisateurs des groupes métier et des groupes réellement utilisés pour appliquer les permissions sur la ressource.

## Validation d'un utilisateur autorisé

`OliverR`, déjà membre de `GRP-Finance-Users`, a été utilisé comme contrôle positif.

La connexion au partage a réussi :

```powershell
# Monte le partage Finance sur Z: avec le compte de domaine OliverR
net use Z: \\Win19\Finance /user:LAB\OliverR *
```

Puis la création d'un fichier a confirmé les droits d'écriture :

```powershell
# Valide l'écriture dans le partage
echo Test Finance > Z:\OliverR-test.txt
```

Le fichier `OliverR-test.txt` a été créé avec succès.

## Reproduction de l'accès refusé

`AliceJ` n'était initialement pas membre de `GRP-Finance-Users`.

La connexion SMB elle-même a réussi :

```powershell
# Authentifie AliceJ et crée la connexion SMB
net use Z: \\Win19\Finance /user:LAB\AliceJ *
```

Mais l'accès au contenu a échoué :

```powershell
# Tente de lire le contenu du partage
dir Z:
```

Résultat :

```text
Access is denied
```

![Accès refusé AliceJ](assets/07-smb-access-denied-alice.jpg)

Cette preuve montre que l'authentification peut réussir alors que l'autorisation sur la ressource échoue.

## Diagnostic

La vérification du groupe Finance ne retournait initialement aucune entrée pour `AliceJ` :

```powershell
# Vérifie si AliceJ appartient au groupe métier Finance
Get-ADGroupMember "GRP-Finance-Users" |
Where-Object SamAccountName -eq "AliceJ"
```

Cause identifiée : `AliceJ` n'était pas membre du groupe métier qui donne indirectement accès à `DL-Finance-RW`.

## Correction

`AliceJ` a été ajoutée au groupe métier :

```powershell
# Ajoute AliceJ au groupe métier Finance
Add-ADGroupMember `
  -Identity "GRP-Finance-Users" `
  -Members "AliceJ"
```

La chaîne AGDLP a ensuite été validée :

```powershell
# Vérifie l'appartenance directe
Get-ADGroupMember "GRP-Finance-Users" |
Where-Object SamAccountName -eq "AliceJ"

# Vérifie l'accès indirect via le groupe Domain Local
Get-ADGroupMember "DL-Finance-RW" -Recursive |
Where-Object SamAccountName -eq "AliceJ"
```

`AliceJ` apparaissait bien dans les deux vérifications.

## Session SMB encore refusée après correction

Malgré la correction dans Active Directory, la session SMB déjà ouverte continuait à retourner :

```text
Access is denied
```

La connexion avait été créée avant le changement d'appartenance au groupe. Elle utilisait donc encore l'ancien contexte d'autorisation de cette session SMB.

## Rafraîchissement de la session

L'ancienne connexion a été supprimée :

```powershell
# Ferme l'ancienne connexion SMB
net use Z: /delete /y

# Vérifie qu'aucune connexion SMB ne reste ouverte
net use
```

Puis une nouvelle connexion a été créée :

```powershell
# Recrée une nouvelle session SMB avec AliceJ
net use Z: \\Win19\Finance /user:LAB\AliceJ *
```

## Validation finale

La lecture du partage fonctionne désormais :

```powershell
# Vérifie l'accès au contenu
dir Z:
```

Puis l'écriture a été validée :

```powershell
# Crée un fichier de test avec AliceJ
"Test Alice Finance" | Out-File "Z:\AliceJ-test.txt"

# Confirme la présence des fichiers
dir Z:
```

Résultat final confirmé :

```text
AliceJ-test.txt
OliverR-test.txt
```

![Accès restauré AliceJ](assets/08-smb-access-restored-alice.jpg)

La capture finale confirme que la lecture et l'écriture sont restaurées après correction de l'appartenance au groupe et recréation de la session SMB.

## Cause racine

`AliceJ` n'était pas membre du groupe métier `GRP-Finance-Users`. Après correction dans Active Directory, la session SMB existante utilisait encore l'ancien contexte d'autorisation. La reconnexion a permis de prendre en compte le nouveau groupe et de restaurer l'accès.

## Compétences démontrées

- création d'un partage SMB ;
- permissions de partage vs permissions NTFS ;
- modèle AGDLP ;
- groupes Global et Domain Local ;
- distinction authentification / autorisation ;
- diagnostic d'un `Access is denied` ;
- compréhension du contexte d'autorisation d'une session SMB ;
- validation avec utilisateur autorisé et utilisateur initialement non autorisé ;
- vérification de la correction par lecture et écriture réelles.
