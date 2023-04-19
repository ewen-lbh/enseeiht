package allumettes;

/**
 * Un plateau est un jeu d'allumettes.
 */
public class Plateau implements Jeu {

    /**
     * Gagnant de la partie. Vaut NULL tant que la partie n'est pas terminée.
     */
    private Joueur gagnant;

    /**
     * Retourner le gagnant de la partie.
     * @return le gagnant de la partie. Vaut NULL tant que la partie n'est pas terminée.
     */
    public Joueur getGagnant() {
        return gagnant;
    }

    /**
     * Nombre d'allumettes en jeu au début d'une partie.
     */
    public static final int NB_ALLUMETTES_INITIAL = 13;

    private int allumettesRestantes;

    @Override
    public int getNombreAllumettes() {
        return this.allumettesRestantes;
    }

    @Override
    public void retirer(int nbPrises) throws CoupInvalideException {
        if (nbPrises < 1) {
            throw new CoupInvalideException(
                nbPrises,
                String.format("Nombre invalide : %d (< 1)", nbPrises)
            );
        }
        if (nbPrises > this.allumettesRestantes) {
            throw new CoupInvalideException(
                nbPrises,
                String.format(
                    "Nombre invalide : %d (> %d)",
                    nbPrises,
                    this.allumettesRestantes
                )
            );
        }
        this.allumettesRestantes -= nbPrises;
    }

    /**
     * Créer un plateau avec le nombre d'allumettes initial prédéfini (13).
     */
    Plateau() {
        this.allumettesRestantes = NB_ALLUMETTES_INITIAL;
    }

    /**
     * Créer un plateau avec un nombre initial d'allumettes donné.
     * @param nbAllumettes le nombre initial d'allumettes
     */
    Plateau(int nbAllumettes) {
        if (nbAllumettes <= 0) {
            throw new IllegalArgumentException(
                String.format(
                    "Nombre initial d'allumettes invalide : %d (<= 0)",
                    nbAllumettes
                )
            );
        }
        this.allumettesRestantes = nbAllumettes;
    }
}
