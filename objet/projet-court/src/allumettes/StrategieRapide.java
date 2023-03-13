package allumettes;

public class StrategieRapide extends Strategie {

    @Override
    public int getPrise(Jeu jeu) {
        return clamp(jeu.getNombreAllumettes(), 1, Jeu.PRISE_MAX);
    }

    private int clamp(int value, int min, int max) {
        return Math.max(min, Math.min(value, max));
    }
}
