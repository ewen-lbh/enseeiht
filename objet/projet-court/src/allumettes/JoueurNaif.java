package allumettes;

import java.util.Random;

public class JoueurNaif extends Joueur {

    JoueurNaif(String nom) {
        super(nom, "naif");
    }

    @Override
    public int getPrise(Jeu jeu) {
        return new Random().nextInt(Jeu.PRISE_MAX - 1) + 1;
    }
}
