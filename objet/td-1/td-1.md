## Point Géométrique

### moyens de définir un point:

```plantuml
class Point {
    double abscisse
    double ordonee
    double module
    double argument
}
```

## représentables par attributs

Tous!

## Formalisme utilisé

UML

## Spécifier en programmation objet : exemple du point géométrique


```plantuml
class Point {
    abscisse: double
    ordonee: double
    module: double
    argument: double
    ---
    // Requêtes
    distance(Point autre): double
    ---
    // Commandes
    afficher()
    translater(double abscisse, ordonee)
    setAbscisse(double abscisse)
    setOrdonee(double ordonee)
    setModule(double module)
    setArgument(double argument)
}
```

## Définir les constructeurs

### C'est quoi?

Un constructeur initalise l'état d'un objet.

Un seul constructeur par classe!!! À part avec de la surcharge.

Intérêt: instancier la classe


Point a = new Point(...)

### Constructeur cartésien

```
Point(double abscisse, double ordonee)
```

### Constructeur polaire

```
Point(double module, double argument)
```

```java
class Point {
    ...

    Point(double module, double argument) {
        this.module = module;
        this.argument = argument;
        this.abscisse = ;
        this.ordonee = ordonee;
    }

    ...
}
```

### 


```java
class PointMixte { ...
void setAbscisse(double abscisse) {
    this.abscisse = abscisse;
    this.module = ...
    this.argument = ...
}
}
```


```java
class PointPolaire { ...
void setAbscisse(double abscisse) {
    this.module = Math.sqrt(Math.pow(abscisse, 2) + Math.pow(this.getOrdonee()));
    this.argument = Math.atan2(this.getOrdonee() / abscisse);
}
}
```

## Utiliser la classe Point

```java
public static void main(String[] args) {
    Point p1 = new Point(1, 0);
    System.out.println(p1.getModule());
    System.out.println(p1.getAbscisse());
    p1.translate(-1, 1);
    p1.afficher();
}
```
