package allumettes;

/**
 * Jeu interdisant l'appel à retirer. Sert à l'implémentation du patron de conception "procuration" (proxy).
 */
public class PlateauProcuration implements Jeu {

    private Jeu jeu;

    /**
     * Créer une procuration d'un jeu.
     * @param jeu le jeu à procurer
     */
    PlateauProcuration(Jeu jeu) {
        this.jeu = jeu;
    }

    @Override
    public int getNombreAllumettes() {
        return this.jeu.getNombreAllumettes();
    }

    @Override
    public void retirer(int nbPrises) throws OperationInterditeException {
        throw new OperationInterditeException();
    }
}
