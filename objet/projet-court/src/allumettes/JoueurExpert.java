package allumettes;

import java.util.Random;

public class JoueurExpert extends Joueur {

    JoueurExpert(String nom) {
        super(nom);
    }

    @Override
    public int getPrise(Jeu jeu) {
        int prise = (jeu.getNombreAllumettes() - 1) % (Jeu.PRISE_MAX + 1);
        if (prise <= 0) {
            return new Random().nextInt(Math.min(jeu.getNombreAllumettes(), Jeu.PRISE_MAX)) + 1;
        }
        return prise;
    }
}
