package allumettes;

public class Joueur {

    private String nom;
    private Strategie strategie;

    public String getNom() {
        return this.nom;
    }

    public int getPrise(Jeu jeu)
        throws OperationInterditeException, CoupInvalideException {
        return this.strategie.getPrise(jeu);
    }

    public Joueur(String nom, Strategie strategie) {
        this.nom = nom;
        this.strategie = strategie;
    }
}
