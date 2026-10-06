# Troubleshooting — Windows Server / Active Directory

Cette page résume les incidents reproduits ou rencontrés dans le laboratoire et la méthode utilisée pour les diagnostiquer.

## Scénarios validés

### GPO non appliquée — Security Filtering

La GPO `LAB-Workstations-Test` ne s'appliquait plus au poste après modification du filtrage de sécurité. Le lien d'OU et les permissions étaient corrects, mais le groupe `GG-GPO-Pilot` ne contenait pas le compte ordinateur.

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

### Audit VLAN30 / DHCP — relay obsolète et scope mal délimité

L'audit de la configuration FortiGate a révélé :

- un ancien DHCP Relay vers `192.168.30.245`, alors qu'aucun serveur n'existe à cette adresse ;
- un serveur DHCP local FortiGate actif sur `vlan30` ;
- une plage dynamique `192.168.30.50-192.168.30.200` qui incluait l'adresse statique du DC/DNS `192.168.30.50`.

**Cause racine :** ancienne configuration de relay jamais retirée et scope DHCP trop large.

**Correction :**

- suppression du DHCP Relay obsolète ;
- conservation du DHCP local FortiGate ;
- déplacement de la plage DHCP vers `192.168.30.100-192.168.30.200`.

**Validation finale côté client :**

- IPv4 `192.168.30.100` ;
- passerelle `192.168.30.1` ;
- serveur DHCP `192.168.30.1` ;
- DNS `192.168.30.50`.

Détails : [ARCHITECTURE.md](ARCHITECTURE.md)

## Méthode de diagnostic

Pour chaque incident :

1. définir précisément le symptôme ;
2. vérifier la connectivité et la configuration réelle ;
3. comparer la configuration serveur avec le comportement observé côté client ;
4. isoler la couche concernée ;
5. identifier la cause racine ;
6. effectuer une correction contrôlée ;
7. valider le résultat ;
8. conserver les preuves avant/après.
