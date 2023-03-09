package allumettes;

abstract public class Joueur {
    private String nom;

    public String getNom() {
        return this.nom;
    }

    abstract public int getPrise(Jeu jeu) throws OperationInterditeException, CoupInvalideException;

    Joueur(String nom) {
        this.nom = nom;
    }
}
