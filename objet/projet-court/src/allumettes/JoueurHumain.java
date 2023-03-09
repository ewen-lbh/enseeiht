package allumettes;

import java.util.Scanner;

public class JoueurHumain extends Joueur {

    private Scanner scanneur;

    JoueurHumain(String nom, Scanner scanneur) {
        super(nom);
        this.scanneur = scanneur;
    }

    @Override
    public int getPrise(Jeu jeu) {
        int prise = this.poserQuestionPrise(jeu);
        return prise;
    }

    private int poserQuestionPrise(Jeu jeu) {
        System.out.print(this.getNom() + ", combien d'allumettes ? ");
        String brut = scanneur.nextLine();
        try {
            return Integer.parseInt(brut);
        } catch (NumberFormatException e) {
            if (brut.equals("triche")) {
                try {
                    jeu.retirer(1);
                    System.out.printf("[Une allumette en moins, plus que %d. Chut !]\n", jeu.getNombreAllumettes());
                } catch (OperationInterditeException | CoupInvalideException tricheException) {
                }
            } else {
                System.out.println("Vous devez donner un entier.");
            }
            return this.poserQuestionPrise(jeu);
        }
    }
}
