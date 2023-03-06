package editeur.commande;

import editeur.Ligne;
import util.Console;

/**
 * Ajouter un caractère à la fin de la ligne.
 * 
 * @author Xavier Crégut
 * @version 1.4
 */
public class CommandeSupprimerAuCurseur
        extends CommandeLigne {

    /**
     * Initialiser la ligne sur laquelle travaille
     * cette commande.
     * 
     * @param l la ligne
     */
    // @ requires l != null; // la ligne doit être définie
    public CommandeSupprimerAuCurseur(Ligne l) {
        super(l);
    }

    public void executer() {
        ligne.supprimer();
    }

    public boolean estExecutable() {
        return ligne.getLongueur() > 0;
    }

}
