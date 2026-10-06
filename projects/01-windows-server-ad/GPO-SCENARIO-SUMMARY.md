# Scénario GPO — Security Filtering

## Résumé

Ce scénario démontre le cycle complet de configuration, panne volontaire, diagnostic, correction et validation d'une GPO ciblée par filtrage de sécurité.

### État initial

- poste `MININT-J8ODACM` dans `OU=Workstations,DC=lab,DC=local` ;
- GPO `LAB-Workstations-Test` liée à l'OU ;
- la GPO crée `HKLM\SOFTWARE\LabPortfolio` avec `GPOApplied=yes` ;
- la GPO s'applique correctement au poste.

### Panne volontaire

Le `Security Filtering` a été modifié pour ne laisser que le groupe `GG-GPO-Pilot`, alors que le compte ordinateur n'était pas encore membre de ce groupe.

Résultat observé :

```text
LAB-Workstations-Test
    Filtering: Not Applied (Unknown Reason)
```

### Diagnostic

Les vérifications ont montré que :

- la GPO était toujours liée à `OU=Workstations` ;
- `GG-GPO-Pilot` possédait bien `GpoApply` ;
- le groupe `GG-GPO-Pilot` était vide ;
- le poste n'était donc pas dans le scope effectif de la GPO.

### Correction

Le compte ordinateur `MININT-J8ODACM$` a été ajouté à `GG-GPO-Pilot`, puis le poste a été redémarré afin de renouveler son contexte de sécurité machine.

### Validation finale

Après redémarrage et `gpupdate /force`, `gpresult /scope computer /r` confirme :

```text
Applied Group Policy Objects
-----------------------------
LAB-Workstations-Test
Default Domain Policy
Local Group Policy
```

La liste des groupes de sécurité du compte ordinateur contient également `GG-GPO-Pilot`, ce qui confirme que le nouveau contexte de sécurité a bien été pris en compte.

## Compétences démontrées

- ciblage de GPO par OU ;
- Security Filtering ;
- permissions `GpoApply` ;
- diagnostic avec `gpresult` ;
- vérification des groupes AD ;
- compréhension du renouvellement du token/contexte de sécurité ordinateur ;
- validation avant/après plutôt que simple observation d'un état résiduel dans le registre.
