package allumettes;

public interface Strategie {
    public int getPrise(Jeu jeu)
        throws OperationInterditeException, CoupInvalideException;
}
