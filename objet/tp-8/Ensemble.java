/** Définition d'un ensemble d'entier. */
public interface Ensemble<T> {
    // @ public invariant estVide() <==> cardinal() == 0;
    // @ public invariant 0 <= cardinal();

    /**
     * Obtenir le nombre d'éléments dans l'ensemble.
     * 
     * @return nombre d'éléments dans l'ensemble.
     */
    /* @ pure helper @ */ int cardinal();

    /**
     * Savoir si l'ensemble est vide.
     * 
     * @return Est-ce que l'ensemble est vide ?
     */
    /* @ pure helper @ */ boolean estVide();

    /**
     * Savoir si un élément est présent dans l'ensemble.
     * 
     * @param x l'élément cherché
     * @return x est dans l'ensemble
     */
    /* @ pure helper @ */ boolean contient(T x);

    /**
     * Ajouter un élément dans l'ensemble.
     * 
     * @param x l'élément à ajouter
     */
    // @ ensures contient(x); // élément ajouté
    void ajouter(T x);

    /**
     * Enlever un élément de l'ensemble.
     * 
     * @param x l'élément à supprimer
     */
    // @ ensures ! contient(x); // élément supprimé
    void supprimer(T x);
}

class EnsembleChaine<T> implements Ensemble<T> {
    private Cellule tete;

    public Cellule getTete() {
        return this.tete;
    }

    public EnsembleChaine() {
        this.tete = null;
    }

    public int cardinal() {
        Cellule curseur = this.tete;
        int cardinal = 0;
        while (curseur != null) {
            cardinal++;
        }
        return cardinal;
    }

    public boolean estVide() {
        return this.cardinal() == 0;
    }

    public boolean contient(T x) {
        for (Cellule c = this.tete; c != null; c = c.getSuivant()) {
            if (c.getValeur() == x) {
                return true;
            }
        }
        return false;
    }

    public void ajouter(T x) {
        if (!this.contient(x)) {
            this.tete = new Cellule(x, this.tete);
        }
    }

    public void supprimer(T x) {
        if (this.tete == null) {
            return;
        }
        if (this.tete.getValeur() == x) {
            this.tete = this.tete.getSuivant();
        } else {
            for (Cellule c = this.tete; c.getSuivant() != null; c = c.getSuivant()) {
                if (c.getSuivant().getValeur() == x) {
                    c.setSuivant(c.getSuivant().getSuivant());
                    return;
                }
            }
        }
    }
}

class Cellule<T> {
    private T valeur;
    private Cellule suivant;

    public Cellule(T valeur, Cellule suivant) {
        this.valeur = valeur;
        this.suivant = suivant;
    }

    public T getValeur() {
        return this.valeur;
    }

    public Cellule getSuivant() {
        return this.suivant;
    }

    public void setValeur(T valeur) {
        this.valeur = valeur;
    }

    public void setSuivant(Cellule<T> suivant) {
        this.suivant = suivant;
    }
}

interface EnsembleOrdonne<T extends Comparable> extends Ensemble {
    T min();
}

class EnsembleOrdonneChaine implements EnsembleOrdonne {
    public T min() {
        if (this.getTete() == null) {
            throw new IllegalStateException("L'ensemble est vide");
        }

        T min = this.getTete().getValeur();
        for (Cellule c = this.getTete().getSuivant(); c != null; c = c.getSuivant()) {
            if (c.getValeur() < min) {
                min = c.getValeur();
            }
        }
        return min;
    }

    public T justePlusGrandQue(T x) {
        T ret = this.getTete();

        for (Cellule c = this.getTete(); c != null; c = c.getSuivant()) {
            if (c.getValeur() > x && (ret == null || c.getValeur() < ret)) {
                ret = c.getValeur();
            }
        }

        return ret;
    }
}

/**
 * 
 * 2.4: Un ensemble chaîné ordonné est souvent plus efficace, car il permet de
 * vérifier et/ou supprimer un élément sans avoir à parcourir toute la chaîne
 * (dès qu'on arrive à un élément plus grand, c'est que l'élément n'est pas dans
 * la chaîne)
 * Mon implémentation ne fait qu'étendre la classe EnsembleChaine, et donc n'est
 * pas plus rapide.
 */

/**
 * 4.1: Non, dans la vraie vie, c'est implémenté avec des tables de hachage.
 */

/**
 * 4.2: Avec un tableau, l'accès à la position d'un élément est en temps
 * constant. Mais globalement on transforme la complexité temporelle en
 * complexité spatiale, donc c'est pas forcément plus efficace.
 */

/**
 * 4.3: cf 4.1
 */

/**
 * 4.4: Il y a l'inteface java.util.Set, implémenté par AbstractSet,
 * ConcurrentSkipListSet, CopyOnWriteArraySet, EnumSet, HashSet,
 * JobStateReasons, LinkedHashSet, TreeSet.
 */

/**
 * 5.2: Possible en combinant tailSet et first. Elle sont définies dans java.util.SortedSet
 */
