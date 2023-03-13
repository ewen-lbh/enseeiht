package allumettes;

public abstract class Strategie {

    public abstract int getPrise(Jeu jeu)
        throws OperationInterditeException, CoupInvalideException;
}
