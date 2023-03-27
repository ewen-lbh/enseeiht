package editeur.commande;

import editeur.EditeurLigne;
import menu.Menu;

public class CommandeOuvrirSousMenu implements menu.Commande {
    private boolean ouvert;
    private EditeurLigne editeur;
    private Menu parent;
    private Menu enfant;

    public CommandeOuvrirSousMenu(EditeurLigne editeur, Menu parent, Menu enfant) {
        this(editeur, parent, enfant, false);
    }

    public CommandeOuvrirSousMenu(EditeurLigne editeur, Menu parent, Menu enfant, boolean ouvert) {
        this.editeur = editeur;
        this.ouvert = ouvert;
        this.parent = parent;
        this.enfant = enfant;
    }

    public void executer() {
        this.ouvert = !this.ouvert;
        if (this.ouvert) {
            System.out.printf("%s -> %s\n", this.editeur.menu, this.enfant);
            this.editeur.menu = this.enfant;
        } else {
            System.out.printf("%s -> %s\n", this.editeur.menu, this.parent);
            this.editeur.menu = this.parent;
        }
        System.out.printf("editeur.menu = %s\n", this.editeur.menu);
    }

    @Override
    public boolean estExecutable() {
        return true;
    }
}
