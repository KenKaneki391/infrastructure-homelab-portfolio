# Troubleshooting — Windows Server / Active Directory

Ce projet documente plusieurs incidents et anomalies de configuration afin de démontrer une méthode de diagnostic structurée.

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

### Audit VLAN30 / DHCP — relay obsolète découvert

Un audit de la configuration FortiGate a révélé qu'un DHCP Relay vers `192.168.30.245` était encore activé sur `vlan30`, alors qu'aucun serveur n'existe à cette adresse dans le laboratoire.

Le client `MININT-J8ODACM` reçoit actuellement :

- IPv4 `192.168.30.52` ;
- passerelle `192.168.30.1` ;
- serveur DHCP `192.168.30.1` ;
- DNS `192.168.30.50`.

La configuration FortiGate confirme également :

- un serveur DHCP local actif sur `vlan30` ;
- une plage dynamique `192.168.30.50-192.168.30.200` ;
- DNS distribué `192.168.30.50` ;
- PXE next-server `192.168.30.51` ;
- un ancien relay vers `192.168.30.245`.

**Cause racine :** ancienne configuration de DHCP Relay ajoutée par erreur et jamais retirée.

**Correction prévue :** supprimer le relay obsolète et conserver le DHCP local FortiGate.

**Risque supplémentaire :** la plage DHCP dynamique inclut `192.168.30.50`, utilisé statiquement par le DC/DNS, ainsi que `192.168.30.51`, utilisé comme next-server PXE. Ces adresses d'infrastructure doivent être retirées de la plage dynamique.

Détails : [ARCHITECTURE.md](ARCHITECTURE.md)

## Méthode utilisée

Pour chaque incident :

1. définir précisément le symptôme ou l'anomalie ;
2. vérifier la connectivité et la configuration réelle ;
3. comparer la configuration serveur avec le comportement observé côté client ;
4. isoler la couche concernée ;
5. identifier la cause racine ;
6. effectuer une correction contrôlée ;
7. valider le résultat ;
8. documenter les preuves avant/après.

L'objectif est de montrer le raisonnement de dépannage, pas seulement une liste de commandes.
