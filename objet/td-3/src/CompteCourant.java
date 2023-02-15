import java.util.ArrayList;
import java.util.Date;

public class Historique {
    private final ArrayList<Operation> operations;
}

public class Operation {
    public Argent solde;
    public Date date;
}

public class CompteCourant extends CompteSimple {
    private final Historique releve;

    public CompteCourant(Personne titulaire, Argent solde, String monnaie) {
        super(titulaire, solde, monnaie);
        this.releve = new Historique();
        if (solde != 0) {
            this.releve.enregistrer(solde);
        }
    }

    @Override public void crediter(Argent solde) {
        super.crediter(solde);
        this.releve.enregistrer(solde);
    }

    @Override public void debiter(Argent solde) {
        super.debiter(solde);
        this.releve.enregistrer(-solde);
    }

    public Historique getReleve() {
        return releve;
    }
}
