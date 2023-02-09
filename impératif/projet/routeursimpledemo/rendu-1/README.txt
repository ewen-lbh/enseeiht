# PIM-PRO3-22

_Réalisé par:_

- HERBIN Clement
- LE BIHAN Ewen
- DEORA Axel

## Installation

Pour compiler le programme:

```bash
make main
```

Pour le lancer:
```bash
./main
```

_Les fichiers d'exemple ont les noms par défaut_

## Tests

Pour lancer les tests:

```bash
chmod +x test_all.sh
./test_all.sh
```
## Répartition du travail

![](quifaitquoi.png)

## Démarrage normal

### `./main [options]`

### Options

### `-c <taille>`
Définir la taille du cache. <taille> est la taille du cache. La valeur 0 indique qu’il n y a pas de cache. La valeur par défaut est 10.

### `-p FIFO|LRU|LFU`
Définir la politique utilisée pour le cache (par défaut FIFO);

### `-s`
Afficher les statistiques (nombre de défauts de cache, nombre de demandes de route, taux de défaut de cache). C’est l’option activée par défaut.

### `-S`
Ne pas afficher les statistiques.

### `-t <fichier>`
Définir le nom du fichier contenant les routes de la table de routage. Par défaut, on utilise le fichier table.txt.

### `-p <fichier>`
Définir le nom du fichier contenant les paquets à router. Par défaut, on utilise le fichier paquets.txt.

### `-r <fichier>`
Définir le nom du fichier contenant les résultats (adresse IP destination du paquet et interface utilisée). Par défaut, on utilise le fichier resultats.txt
