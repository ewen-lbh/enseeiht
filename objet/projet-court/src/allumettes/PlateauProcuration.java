package allumettes;

public class PlateauProcuration implements Jeu {
    private Jeu jeu;

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
