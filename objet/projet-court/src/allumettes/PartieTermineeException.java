package allumettes;

public class PartieTermineeException extends Exception {
    PartieTermineeException(Joueur gagnant, Joueur perdant) {
        super(String.format("\n%s perd !\n%s gagne !", perdant.getNom(), gagnant.getNom()));
    }
}
