package allumettes;

import java.util.Random;

public class StrategieNaif implements Strategie {
    
    public int getPrise(Jeu jeu) {
        return new Random().nextInt(Jeu.PRISE_MAX - 1) + 1;
    }
}
