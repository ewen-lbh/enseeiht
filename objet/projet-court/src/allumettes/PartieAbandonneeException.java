package allumettes;

public class PartieAbandonneeException extends Exception {

    PartieAbandonneeException(Joueur tricheur) {
        super("Abandon de la partie car " + tricheur.getNom() + " triche !");
    }
}
