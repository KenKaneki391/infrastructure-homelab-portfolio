# Troubleshooting — Windows Server / Active Directory

Ce projet documente trois incidents reproduits volontairement dans le laboratoire afin de démontrer une méthode de diagnostic structurée.

## Scénarios validés

### GPO non appliquée — Security Filtering

La GPO `LAB-Workstations-Test` ne s'appliquait plus au poste après modification du filtrage de sécurité. Le diagnostic a permis de confirmer que le lien d'OU et les permissions étaient corrects, puis d'identifier que le groupe `GG-GPO-Pilot` ne contenait pas le compte ordinateur.

**Cause racine :** poste absent du groupe utilisé pour le Security Filtering.

**Correction :** ajout du compte ordinateur au groupe, renouvellement du contexte de sécurité machine, puis validation du retour de la GPO.

Détails : [GPO-SCENARIO-SUMMARY.md](GPO-SCENARIO-SUMMARY.md)

### Accès refusé au partage Finance

Un utilisateur pouvait s'authentifier sur le serveur SMB mais recevait `Access is denied` lors de l'accès au contenu du partage.

**Cause racine :** l'utilisateur n'appartenait pas au groupe métier qui héritait des droits via le modèle AGDLP. Une session SMB ouverte avant la correction conservait également l'ancien contexte d'autorisation.

**Correction :** ajout au groupe métier, validation de la chaîne AGDLP et recréation de la session SMB.

Détails : [SMB-NTFS-SCENARIO-SUMMARY.md](SMB-NTFS-SCENARIO-SUMMARY.md)

### DNS incorrect — découverte Active Directory indisponible

Le DNS du client a été volontairement remplacé par un serveur incorrect. La connectivité IP vers le contrôleur de domaine restait disponible, mais la résolution du nom du DC, sa découverte par le client et l'actualisation de la stratégie ordinateur échouaient.

**Cause racine :** configuration DNS incorrecte sur le client.

**Correction :** restauration du DNS Active Directory `192.168.30.50`, puis validation de la résolution, de la découverte du DC et des GPO.

Détails : [DNS-SCENARIO-SUMMARY.md](DNS-SCENARIO-SUMMARY.md)

## Méthode utilisée

Pour chaque incident :

1. définir précisément le symptôme ;
2. vérifier la connectivité ;
3. vérifier DNS et la découverte des services ;
4. vérifier l'identité, les groupes et le scope ;
5. effectuer une seule correction contrôlée ;
6. valider le résultat ;
7. documenter la cause racine.

L'objectif est de montrer le raisonnement de dépannage, pas seulement une liste de commandes.
