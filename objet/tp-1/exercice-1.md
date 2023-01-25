## Comprendre la classe Point

```plantuml
class Point {
    - x: double
    - y: double
    - couleur: Color
    ---
    + getX: double
    + getY: double
    + getCouleur: Color
    + setX(x: double)
    + setY(y: double)
    + setCouleur(c: Color)
    + translate(dx: double, dy: double)
    + afficher()
    ---
    + Point(x: double, y: double)
}
```

### 1.1

| UML                               | Java                               |
| --------------------------------- | ---------------------------------- |
| `+`                               | `public`                           |
| `-`                               | `private`                          |
| `#`                               | `protected`                        |
| méthode(arg1: type1, ...): retour | retour méthode(type1 arg1, ...) {} |
| méthode(arg1: type1, ...)         | void méthode(type1 arg1, ...) {}   |
| attribut: type                    | type attribut;                     |

### 1.2

Le fait de pas mettre de parenthèses pour les requêtes.

## Comprendre et compléter la classe `Segment`

### 4.1

```plantuml
class Segment {
    - p1: Point
    - p2: Point
    - couleur: Color
    ---
    + afficher()
    + longueur: double
    + translater(x, y: double)
    + setCouleur(c: Color)
}
```

