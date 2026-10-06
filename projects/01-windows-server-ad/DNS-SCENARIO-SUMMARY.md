# Scénario DNS — découverte Active Directory indisponible

## Résumé

Ce scénario reproduit une panne Active Directory provoquée par une mauvaise configuration DNS sur le poste client. Le réseau reste disponible, mais le client ne peut plus résoudre le contrôleur de domaine, localiser le domaine ni mettre à jour correctement les stratégies ordinateur.

## Baseline saine

Avant la panne, le poste `MININT-J8ODACM` utilisait le DNS AD `192.168.30.50` sur ses deux interfaces réseau.

```powershell
Get-DnsClientServerAddress -AddressFamily IPv4 |
Where-Object {$_.ServerAddresses.Count -gt 0} |
Select-Object InterfaceAlias, ServerAddresses
```

La découverte du contrôleur de domaine fonctionnait :

```powershell
nltest /dsgetdc:lab.local
```

Résultat attendu et confirmé :

```text
DC: \\Win19.lab.local
Address: \\192.168.30.50
```

La résolution DNS du DC fonctionnait également :

```powershell
Resolve-DnsName Win19.lab.local
```

## Configuration DNS côté serveur

La zone de recherche directe `lab.local` est hébergée sur `Win19` et contient l'enregistrement du contrôleur de domaine.

![Zone DNS lab.local](assets/12-dns-zone-lab-local.jpg)

Cette capture fournit une preuve de la configuration DNS côté serveur et complète les tests réalisés depuis le client.

## Panne volontaire

Le DNS du client a été remplacé temporairement par `192.0.2.53` sur les deux interfaces, puis le cache DNS a été vidé.

```powershell
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses "192.0.2.53"
Set-DnsClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses "192.0.2.53"
Clear-DnsClientCache
```

## Symptômes observés

La résolution du contrôleur de domaine expire :

```powershell
Resolve-DnsName Win19.lab.local
```

Résultat :

```text
This operation returned because the timeout period expired
```

La découverte du domaine échoue :

```powershell
nltest /dsgetdc:lab.local /force
```

Résultat :

```text
ERROR_NO_SUCH_DOMAIN
Status = 1355
```

La mise à jour des stratégies ordinateur échoue également :

```powershell
gpupdate /force
```

Résultat observé :

```text
Computer policy could not be updated successfully.
Windows could not resolve the computer name.
```

![Panne DNS et impact AD](assets/10-dns-broken-ad-failure.jpg)

Cette capture regroupe les symptômes principaux : résolution DNS en timeout, contrôleur de domaine introuvable et échec de la stratégie ordinateur.

## Diagnostic

Le contrôleur de domaine reste joignable par IP :

```powershell
ping 192.168.30.50
```

Le vrai serveur DNS AD répond correctement lorsqu'il est interrogé explicitement :

```powershell
Resolve-DnsName Win19.lab.local -Server 192.168.30.50
```

Cela permet d'isoler la panne :

```text
Réseau vers Win19       OK
Service DNS sur Win19   OK
DNS configuré client    Incorrect
        ↓
Résolution AD impossible
        ↓
DC introuvable
        ↓
Computer GPO en échec
```

## Cause racine

Le poste client n'utilisait plus le serveur DNS Active Directory `192.168.30.50`. Il envoyait ses requêtes à une adresse DNS volontairement incorrecte, ce qui empêchait la résolution des noms AD et la découverte du contrôleur de domaine.

## Correction

Le DNS AD correct a été restauré sur les deux interfaces, puis le cache DNS a été vidé.

```powershell
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses "192.168.30.50"
Set-DnsClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses "192.168.30.50"
Clear-DnsClientCache
```

## Validation finale

Les trois fonctions principales ont été retestées :

```powershell
Resolve-DnsName Win19.lab.local
```

```powershell
nltest /dsgetdc:lab.local /force
```

```powershell
gpupdate /force
```

Après correction, la résolution DNS, la découverte du contrôleur de domaine et l'actualisation des stratégies ont de nouveau fonctionné.

![DNS restauré et AD fonctionnel](assets/11-dns-restored-ad-success.jpg)

La capture finale confirme le retour à un état sain après restauration de `192.168.30.50` comme DNS du client.

## Compétences démontrées

- compréhension de la dépendance d'Active Directory au DNS ;
- distinction entre connectivité IP et résolution de noms ;
- lecture et validation d'une zone DNS Active Directory dans DNS Manager ;
- utilisation de `Resolve-DnsName`, `nltest` et `gpupdate` pour isoler une panne ;
- validation directe du service DNS en ciblant un serveur précis ;
- modification et restauration contrôlée du DNS client ;
- diagnostic basé sur des tests successifs plutôt que sur des modifications au hasard.
