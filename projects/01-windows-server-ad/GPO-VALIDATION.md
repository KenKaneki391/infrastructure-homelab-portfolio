# Validation GPO — Workstations

Cette page documente un test réel d'application d'une stratégie de groupe sur le poste `MININT-J8ODACM`.

## Objectif

Valider qu'une GPO personnalisée liée à une OU de postes est bien reçue par un client du domaine et qu'elle produit effectivement la modification attendue sur Windows.

## Ciblage

Le poste a été déplacé dans l'OU :

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
gpresult /r
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

La stratégie a été appliquée depuis :

```text
Win19.lab.local
```

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

Le test démontre la chaîne complète suivante :

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

Cette validation confirme la capacité à créer une OU, cibler une GPO sur un ensemble de postes, forcer l'actualisation des stratégies et vérifier à la fois l'état RSoP et l'effet réel de la configuration.

## Prochain scénario

Créer volontairement une situation où la GPO ne s'applique plus, puis diagnostiquer la cause à l'aide de `gpresult`, du scope de la GPO, du lien d'OU et éventuellement du filtrage de sécurité.
