package allumettes;

public abstract class Joueur {

    private String nom;
    private String strategie;

    public String getNom() {
        return this.nom;
    }

    public abstract int getPrise(Jeu jeu)
        throws OperationInterditeException, CoupInvalideException;

    Joueur(String nom, String strategie) {
        this.nom = nom;
        this.strategie = strategie;
    }
}
