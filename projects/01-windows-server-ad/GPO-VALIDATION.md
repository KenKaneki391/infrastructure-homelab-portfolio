# Validation GPO — Workstations

Cette page documente l'application d'une stratégie de groupe sur le poste `MININT-J8ODACM`.

## Objectif

Valider qu'une GPO personnalisée liée à une OU de postes est bien reçue par un client du domaine et qu'elle produit la modification attendue sur Windows.

## Ciblage

Le poste se trouve dans :

```text
OU=Workstations,DC=lab,DC=local
```

La GPO créée et liée à cette OU est :

```text
LAB-Workstations-Test
```

## Configuration testée

Une préférence de registre a été configurée dans :

```text
Computer Configuration
  > Preferences
    > Windows Settings
      > Registry
```

Paramètres :

```text
Hive       : HKEY_LOCAL_MACHINE
Key Path   : SOFTWARE\LabPortfolio
Value name : GPOApplied
Value type : REG_SZ
Value data : yes
```

## Validation côté client

Après actualisation des stratégies :

```cmd
gpupdate /force
```

La commande suivante a permis de vérifier les stratégies effectivement appliquées :

```cmd
gpresult /scope computer /r
```

Résultats observés côté ordinateur :

```text
CN=MININT-J8ODACM,OU=Workstations,DC=lab,DC=local

Applied Group Policy Objects
-----------------------------
LAB-Workstations-Test
Default Domain Policy
Local Group Policy
```

La stratégie a été appliquée depuis `Win19.lab.local`.

## Validation fonctionnelle

La présence de la valeur registre a été contrôlée avec :

```powershell
Get-ItemProperty -Path "HKLM:\SOFTWARE\LabPortfolio"
```

Résultat confirmé :

```text
GPOApplied : yes
```

## Conclusion

Le test valide la chaîne suivante :

```text
Objet ordinateur
    ↓
OU Workstations
    ↓
GPO liée à l'OU
    ↓
Actualisation de stratégie
    ↓
gpresult confirme l'application
    ↓
Modification présente dans le registre
```

Le scénario de dépannage associé au `Security Filtering` est documenté dans [GPO-SCENARIO-SUMMARY.md](GPO-SCENARIO-SUMMARY.md).
