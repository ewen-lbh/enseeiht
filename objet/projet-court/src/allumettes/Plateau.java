package allumettes;

public class Plateau implements Jeu {

    /**
     * Gagnant de la partie. Vaut NULL tant que la partie n'est pas terminée.
     */
    protected Joueur gagnant;

    /**
     * Nombre d'allumettes en jeu au début d'une partie.
     */
    int NB_ALLUMETTES_INITIAL = 13;

    private int allumettesRestantes;

    @Override
    public int getNombreAllumettes() {
        return this.allumettesRestantes;
    }

    @Override
    public void retirer(int nbPrises) throws CoupInvalideException {
        if (nbPrises < 1) {
            throw new CoupInvalideException(nbPrises, String.format("Nombre invalide : %d (< 1)", nbPrises));
        }
        if (nbPrises > this.allumettesRestantes) {
            throw new CoupInvalideException(nbPrises,
                    String.format("Nombre invalide : %d (> %d)", nbPrises, this.allumettesRestantes));
        }
        this.allumettesRestantes -= nbPrises;
    }

    Plateau() {
        this.allumettesRestantes = NB_ALLUMETTES_INITIAL;
    }
}
