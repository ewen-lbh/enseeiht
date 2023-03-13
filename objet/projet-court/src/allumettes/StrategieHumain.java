package allumettes;

import java.util.Scanner;

public class StrategieHumain implements Strategie {

    private Scanner scanneur;
    private String nomJoueur;

    StrategieHumain(Scanner scanneur, String nomJoueur) {
        this.scanneur = scanneur;
    }

    public int getPrise(Jeu jeu) {
        int prise = this.poserQuestionPrise(jeu);
        return prise;
    }

    private int poserQuestionPrise(Jeu jeu) {
        System.out.print(this.nomJoueur + ", combien d'allumettes ? ");
        String brut = scanneur.nextLine();
        try {
            return Integer.parseInt(brut);
        } catch (NumberFormatException e) {
            if (brut.equals("triche")) {
                try {
                    jeu.retirer(1);
                    System.out.printf(
                        "[Une allumette en moins, plus que %d. Chut !]\n",
                        jeu.getNombreAllumettes()
                    );
                } catch (
                    OperationInterditeException | CoupInvalideException tricheException
                ) {}
            } else {
                System.out.println("Vous devez donner un entier.");
            }
            return this.poserQuestionPrise(jeu);
        }
    }
}
