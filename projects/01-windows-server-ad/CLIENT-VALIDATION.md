# Validation d'un poste membre du domaine

Cette page documente les vérifications effectuées sur le poste Windows `MININT-J8ODACM`.

## État du poste

- **Nom :** `MININT-J8ODACM`
- **OS :** Windows 10 build 19045
- **Domaine :** `lab.local`
- **Membre du domaine :** Oui
- **DNS reçu :** `192.168.30.50`
- **DHCP :** FortiGate
- **OU :** `OU=Workstations,DC=lab,DC=local`

Le poste utilise deux cartes réseau dans le cadre du laboratoire :

| Interface | IPv4 | Gateway | DNS |
|---|---|---|---|
| Ethernet | `192.168.10.124/24` | `192.168.10.1` | `192.168.30.50` |
| Ethernet 2 | `192.168.30.100/24` | `192.168.30.1` | `192.168.30.50` |

## Vérifications réalisées

### 1. Appartenance au domaine

```powershell
(Get-CimInstance Win32_ComputerSystem) | Select Name,Domain,PartOfDomain
```

Résultat confirmé :

```text
Domain       : lab.local
PartOfDomain : True
```

### 2. Secure channel

```powershell
Test-ComputerSecureChannel -Verbose
```

Résultat : `True`.

La relation de confiance entre le poste et le domaine est donc valide.

### 3. Découverte du contrôleur de domaine

```powershell
nltest /dsgetdc:lab.local
```

Résultat principal :

```text
DC      : Win19.lab.local
Address : 192.168.30.50
Site    : site-lab
```

Le client localise correctement le contrôleur de domaine et le site Active Directory.

### 4. Application des stratégies de groupe

```cmd
gpupdate /force
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

La stratégie est appliquée depuis `Win19.lab.local`.

### 5. DHCP et DNS après correction du scope

Après renouvellement du bail sur `Ethernet 2`, `ipconfig /all` confirme :

```text
IPv4 Address    : 192.168.30.100
Default Gateway : 192.168.30.1
DHCP Server     : 192.168.30.1
DNS Servers     : 192.168.30.50
```

Cela valide la distribution du scope DHCP final ainsi que l'utilisation du DNS Active Directory.

## Note sur les deux interfaces réseau

Les deux interfaces sont utilisées volontairement dans le laboratoire pour tester les segments `192.168.10.0/24` et `192.168.30.0/24`. L'accès au contrôleur de domaine `192.168.30.50` passe par le réseau directement connecté `192.168.30.0/24`.

Cette configuration est spécifique au lab et n'est pas utilisée comme modèle de poste utilisateur en production.
