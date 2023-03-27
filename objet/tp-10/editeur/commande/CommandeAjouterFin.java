package editeur.commande;

import editeur.EditeurLigne;
import editeur.Ligne;
import menu.Menu;
import util.Console;

/**
 * Ajouter un caractère à la fin de la ligne.
 * 
 * @author Xavier Crégut
 * @version 1.4
 */
public class CommandeAjouterFin
        extends CommandeLigne {

    private Menu menuAFermer;
    private Menu parent;
    private EditeurLigne editeur;

    /**
     * Initialiser la ligne sur laquelle travaille
     * cette commande.
     * 
     * @param l la ligne
     */
    // @ requires l != null; // la ligne doit être définie
    public CommandeAjouterFin(Ligne l) {
        super(l);
    }

    public CommandeAjouterFin(Ligne l, EditeurLigne editeur, Menu menuAFermer, Menu parent) {
        super(l);
        this.menuAFermer = menuAFermer;
        this.parent = parent;
        this.editeur = editeur;
    }

    public void executer() {
        String texte = Console.readLine("Texte à insérer : ");
        for (int i = 0; i < texte.length(); i++) {
            ligne.ajouterFin(texte.charAt(i));
        }
        if (this.menuAFermer != null) {
            // On ferme le sous-menu après éxécution de la commande
            new CommandeOuvrirSousMenu(editeur, parent, menuAFermer, true).executer();
        }
    }

    public boolean estExecutable() {
        return true;
    }

}
