package allumettes;

public class Joueur {

    private String nom;
    private Strategie strategie;

    /**
     * Retourne le nom du joueur.
     * @return le nom du joueur
     */
    public String getNom() {
        return this.nom;
    }

    /**
     * Retour la prise choisie par le joueur.
     * @param jeu le jeu sur lequel le joueur base sa décision
     */
    public int getPrise(Jeu jeu)
        throws OperationInterditeException, CoupInvalideException {
        return this.strategie.getPrise(jeu);
    }

    /**
     * Créer un joueur avec une stratégie donnée.
     * @return
     */
    public Joueur(String nom, Strategie strategie) {
        this.nom = nom;
        this.strategie = strategie;
    }

    /**
     * Changer la stratégie du joueur.
     */
    public void setStrategie(Strategie strategie) {
        this.strategie = strategie;
    }
}
