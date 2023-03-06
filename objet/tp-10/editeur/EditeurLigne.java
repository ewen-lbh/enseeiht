package editeur;

import editeur.commande.*;
import menu.Commande;
import menu.Menu;

/**
 * Un éditeur pour une ligne de texte. Les commandes de
 * l'éditeur sont accessibles par un menu.
 *
 * @author Xavier Crégut
 * @version 1.6
 */
public class EditeurLigne {

    /** La ligne de notre éditeur */
    private Ligne ligne;

    /** Le menu principal de l'éditeur */
    private Menu menuPrincipal;
    /** Un menu secondaire */
    private Menu sousMenu;
    /** Le menu affiché */
    public Menu menu;
    // Remarque : Tous les éditeurs ont le même menu mais on
    // ne peut pas en faire un attribut de classe car chaque
    // commande doit manipuler la ligne propre à un éditeur !

    /** Initialiser l'éditeur à partir de la lign à éditer. */
    public EditeurLigne(Ligne l) {
        ligne = l;

        // Créer le menu principal
        menuPrincipal = new Menu("Menu principal");
        menuPrincipal.ajouter('A', "Ajouter un texte en fin de ligne",
                new CommandeAjouterFin(ligne));
        menuPrincipal.ajouter('l', "Avancer le curseur d'un caractère",
                new CommandeCurseurAvancer(ligne));
        menuPrincipal.ajouter('h', "Reculer le curseur d'un caractère",
                new CommandeCurseurReculer(ligne));
        menuPrincipal.ajouter('^' /* on ne peut pas utiliser 0 même si ce serait plus correct */,
                "Ramener le curseur sur le premier caractère", new CommandeCurseurDebut(ligne));
        menuPrincipal.ajouter('x', "Supprimer le caractère sous le curseur", new CommandeSupprimerAuCurseur(ligne));
        sousMenu = new Menu("sous-menu");
        sousMenu.ajouter("Ajouter un texte en fin de ligne",
                new CommandeAjouterFin(ligne, this, sousMenu, menuPrincipal));
        menuPrincipal.ajouter('@', "Sous-menu", new CommandeOuvrirSousMenu(this, menuPrincipal, sousMenu));
        menu = menuPrincipal;
    }

    public void editer() {
        do {
            // Afficher la ligne
            System.out.println();
            ligne.afficher();
            System.out.println();

            // Afficher le menu
            menu.afficher();

            // Sélectionner une entrée dans le menu
            menu.selectionner();

            // Valider l'entrée sélectionnée
            menu.valider();

        } while (!menu.estQuitte());
    }

}
