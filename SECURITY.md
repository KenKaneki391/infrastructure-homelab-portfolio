# Security & Confidentiality

Ce dépôt est un portfolio de laboratoire personnel.

## Règle principale

**Aucune donnée provenant d'un employeur, d'un client ou d'un environnement de production ne doit être publiée ici.**

## Ne jamais committer

- mots de passe ;
- clés API ;
- tokens d'accès ;
- certificats contenant des clés privées ;
- fichiers `.pfx`, `.pem` ou clés privées ;
- exports de configuration contenant des secrets ;
- captures avec informations confidentielles ;
- vrais noms d'utilisateurs d'entreprise ;
- domaines internes d'un employeur ;
- adresses IP publiques sensibles ;
- informations clients ;
- cookies ou sessions de navigateur.

## Avant d'ajouter une capture

Vérifier :

1. le nom de domaine affiché ;
2. les noms d'utilisateurs ;
3. les noms de machines ;
4. les adresses IP ;
5. les chemins UNC ;
6. les fenêtres ou onglets visibles en arrière-plan ;
7. les notifications ;
8. les clés, mots de passe ou tokens visibles.

## Données recommandées

Utiliser des identités fictives et cohérentes, par exemple :

- `LAB\\mdupont`
- `LAB\\jsmith`
- `DC01`
- `FILE01`
- `WIN11-01`

Les plages privées RFC1918 sont adaptées à la documentation de lab lorsque nécessaire.

## Scripts

Les scripts publiés doivent être :

- non destructifs par défaut ;
- commentés ;
- testés dans le lab ;
- exempts de credentials codés en dur.

Si une commande est potentiellement destructive, elle doit être clairement signalée et ne pas être exécutée automatiquement.
