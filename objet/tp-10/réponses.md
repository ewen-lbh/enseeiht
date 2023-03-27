## 2.1

- On crée une classe `SousMenu` qui hérite de `Menu`.
- On ajoute une propriété publique `menu` à `EditeurLigne` qui pointe vers le menu actuellement affiché. C'est celui-ci qu'on affiche dans la boucle principale.
- On crée une commande qui ouvre le sous-menu:
    - On lui passe dans son constructeur l'éditeur, le menu parent et le sous-menu à ouvrir (qui est aussi une poignée sur un `Menu`).
    - Lors de l'éxécution de la commande:
        - Il modifie le menu actuel pour qu'il contienne les éléments du sous-menu si celui-ci n'est pas ouvert
        - Il restore le menu principal dans l'autre cas
