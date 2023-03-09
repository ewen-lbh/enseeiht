package allumettes;

public class PartieAbandonneeException extends Exception {
    Joueur tricheur;

    PartieAbandonneeException(Joueur tricheur) {
        super("Abandon de la partie car " + tricheur.getNom() + " triche !");
        this.tricheur = tricheur;
    }
}
