package allumettes;

public interface Strategie {
    /**
     * Retourne la prise choisie par la stratégie.
     * @param jeu
     * @return la prise choisie (le nombre d'allumettes à prendre)
     * @throws OperationInterditeException
     * @throws CoupInvalideException
     */
    public int getPrise(Jeu jeu)
        throws OperationInterditeException, CoupInvalideException;
}
