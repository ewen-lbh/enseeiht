package menu;

import java.util.*;
import util.Console;
import menu.commande.*;

/**
 * Définition de menus textuels avec les entrées non
 * sélectionnables désactivées.
 * 
 * @author Xavier Crégut (cregut@enseeiht.fr)
 * @version 1.9
 */
public class Menu {

    // @ public invariant 0 <= getNbEntrees();

    // @ private invariant titre != null;
    // @ private invariant selection != CMD_QUITTER && selection != null ==>
    // @ (\exists int i; i >= 0 && i <= getNbEntrees();
    // @ selection == getEntree(i).getCommande());
    // @ private invariant estQuitte() ==> selection == CMD_QUITTER;
    // @ private invariant getNbEntrees() == entrees.size();
    // @ private invariant entreeQuitter != null;

    private String titre; // Le titre
    private List<Entree> entrees; // Les entrées du menu
    static final private Commande CMD_QUITTER = new CommandeNOP();
    static final private Entree entreeQuitter = new Entree("Quitter", CMD_QUITTER, 'q');
    private Commande selection; // Commande sélectionnée
    private boolean estQuitte; // le menu a-t-il été quitté ?

    /**
     * Construire un menu vide (sans entrées).
     * 
     * @param sonTitre le titre du menu
     */
    // @ requires sonTitre != null; // le titre existe
    // @ ensures getNbEntrees() == 0; // le menu est vide
    // @ ensures estQuitte() == false; // pas encore quitter !
    public Menu(String sonTitre) {
        this.entrees = new ArrayList<Entree>();
        this.titre = sonTitre;
        this.selection = null;
        this.estQuitte = false;
    }

    /** le nombre d'entrées du menu. */
    public /* @ pure @ */ int getNbEntrees() {
        return this.entrees.size();
    }

    /**
     * Obtenir une entrée du menu.
     * 
     * @param choix le numéro de l'entrée ou son raccourci
     * @return l'entrée correspondante
     */
    // @ requires 0 <= i && i <= getNbEntrees();
    private /* @ pure @ */ Entree getEntree(String choix) {
        for (int i = 0; i < getNbEntrees(); i++) {
            Entree entree = entrees.get(i);
            try {
                if (Integer.parseInt(choix) == i + 1) {
                    return entree;
                }
            } catch (Exception e) {
                if (entree.getRaccourci() != '\0' && entree.getRaccourci() == choix.charAt(0)) {
                    return entree;
                }
            }
        }
        return entreeQuitter;
    }

    /**
     * Vérifier si le raccourci correspond à une entrée existante.
     * 
     * @param raccourci le raccourci à vérifier
     * @return
     */
    private boolean raccourciValide(char raccourci) {
        for (int i = 0; i < getNbEntrees(); i++) {
            Entree entree = entrees.get(i);
            if (entree.getRaccourci() != '\0' && entree.getRaccourci() == raccourci) {
                return true;
            }
        }
        return false;
    }

    public /* @ pure @ */ boolean estQuitte() {
        return this.estQuitte;
    }

    /**
     * Ajouter une entrée dans le menu.
     * 
     * @param texte l'intitulé dans le menu
     * @param cmd   la commande associée
     */
    // @ requires texte != null && texte.length() > 0; // texte défini
    // @ requires cmd != null; // commande définie
    public void ajouter(String texte, Commande cmd) {
        this.entrees.add(new Entree(texte, cmd));
    }

    /**
     * Ajouter une entrée dans le menu.
     * 
     * @param raccourci le raccourci de l'entrée
     * @param texte     l'intitulé dans le menu
     * @param cmd       la commande associée
     */
    // @ requires texte != null && texte.length() > 0; // texte défini
    // @ requires cmd != null; // commande définie
    // @ requries raccourci != '\0'
    public void ajouter(char raccourci, String texte, Commande cmd) {
        this.entrees.add(new Entree(texte, cmd, raccourci));
    }

    /** Tracer une séparation du menu. */
    private static void tracerSeparation() {
        String separation = "----------------------------------------------------";
        System.out.println(separation);
    }

    /**
     * Afficher le menu. Les numéros des commandes non
     * exécutables ne sont pas affichés.
     */
    public /* @ pure @ */ void afficher() {
        // Afficher le titre du menu
        tracerSeparation();
        System.out.println(titre);
        tracerSeparation();

        // Afficher les entrées de l'utilisateur
        for (int i = 1; i <= this.getNbEntrees(); i++) {
            this.getEntree(String.format("%d", i)).afficher(i);
        }

        // Afficher la possibilité de quitter
        this.getEntree("0").afficher(0);

        // Dessiner la fin du menu
        tracerSeparation();
    }

    /**
     * Saisir le choix de l'utilisateur. Le choix correspond à
     * une entrée du menu (y compris 0 pour quitter).
     * L'utilisateur peut sélectionner une entrée dont la
     * commande associée n'est pas exécutable.
     */
    // @ ensures ! estQuitte();
    public void selectionner() {
        // Choisir une entrée
        this.estQuitte = false;
        String choix;
        boolean choix_valide = false;
        do {
            choix = Console.readLine("Votre choix : ");
            try {
                choix_valide = 0 <= Integer.parseInt(choix)
                        && Integer.parseInt(choix) <= this.getNbEntrees();
                if (!choix_valide) {
                    System.out.println("Le numéro est invalide, il doit être compris entre 0 et "
                            + this.getNbEntrees() + ".");
                }
            } catch (NumberFormatException e) {
                choix_valide = choix.length() > 0 && this.raccourciValide(choix.charAt(0));
                if (!this.getEntree(choix).getCommande().estExecutable()) {
                    System.out.println("Cette commande n'est pas exécutable pour le moment.");
                }
                if (!choix_valide) {
                    System.out.println("Le raccourci est invalide.");
                }
            }
        } while (!choix_valide);
        this.selection = this.getEntree(choix).getCommande();
    }

    /**
     * Valider la sélection. Ceci consiste à exécuter la
     * commande associée à l'entrée sélectionnée. Si l'entrée
     * sélectionnée est non exécutable, un message d'erreur est
     * signalé.
     */
    public void valider() {
        if (this.selection == CMD_QUITTER) {
            this.estQuitte = true;
        } else {
            if (this.selection.estExecutable()) {
                this.selection.executer();
            } else {
                System.out.println("Opération non réalisable !");
            }
        }
    }

    public String toString() {
        return "Menu \"" + this.titre + "\"";
    }
}
