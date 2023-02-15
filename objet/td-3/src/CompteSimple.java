
public class Personne  {
    private String nom;
    private String prenom;
    private boolean masculin;
    private boolean feminin;

    public Personne(String nom, String prenom, boolean masculin, boolean feminin) {
        this.nom = nom;
        this.prenom = prenom;
        this.masculin = masculin;
        this.feminin = feminin;
    }

    public String getNom() {
        return nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public boolean estHomme() {
        return masculin;
    }

    public boolean estFemme() {
        return feminin;
    }

    public void afficher() {
        System.out.println("Nom: " + nom + " Prenom: " + prenom + " Masculin: " + masculin + " Feminin: " + feminin);
    }
}

public class Argent {
    public double valeur;
    public String monnaie;
}

public class CompteSimple {
    private Personne titulaire;
    private Argent solde;
    private String monnaie;

    public CompteSimple(Personne titulaire, Argent solde, String monnaie) {
        this.titulaire = titulaire;
        this.solde = solde;
        this.monnaie = monnaie;
    }

    public Personne getTitulaire() {
        return titulaire;
    }

    public Argent getSolde() {
        return solde;
    }

    public String getMonnaie() {
        return monnaie;
    }

    public void crediter(Argent solde) {
        this.solde += solde;
    }

    public void debiter(Argent solde) {
        this.solde -= solde;
    }

    public void setTitulaire(Personne titulaire) {
        this.titulaire = titulaire;
    }

    public void setMonnaie(String nouvelleMonnaie) {
        this.monnaie = nouvelleMonnaie;
    }

    public boolean decouvert() {
        return solde < 0;
    }
}

