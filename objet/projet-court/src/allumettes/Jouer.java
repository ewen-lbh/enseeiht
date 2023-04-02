package allumettes;

import java.util.Scanner;

/**
 * Lance une partie des 13 allumettes en fonction des arguments fournis
 * sur la ligne de commande.
 *
 * @author Xavier Crégut
 * @version $Revision: 1.5 $
 */
public class Jouer {

    /**
     * Lancer une partie. En argument sont donnés les deux joueurs sous
     * la forme nom@stratégie.
     *
     * @param args la description des deux joueurs
     */
    public static void main(String[] args) {
        Scanner scanneur = new Scanner(System.in);
        try {
            verifierNombreArguments(args);
            boolean arbitreConfiant = args[0].equals("-confiant");

            int indiceArguments = arbitreConfiant ? 1 : 0;
            Joueur joueur1 = creerJoueur(args[indiceArguments++], scanneur);
            Joueur joueur2 = creerJoueur(args[indiceArguments++], scanneur);

            Arbitre arbitre = new Arbitre(joueur1, joueur2, arbitreConfiant);
            Jeu jeu = new Plateau();

            jouer(jeu, arbitre);
        } catch (ConfigurationException e) {
            System.out.println();
            System.out.println("Erreur : " + e.getMessage());
            afficherUsage();
            System.exit(1);
        } finally {
            scanneur.close();
        }
    }

    /**
     * Lancer une partie.
     * @param jeu Le jeu sur lequel on joue
     * @param arbitre L'arbitre qui arbitre la partie
     */
    private static void jouer(Jeu jeu, Arbitre arbitre) {
        // Je ne vois pas pourquoi while(true) ... break ... serait une mauvaise idée, mais une alternative est d'avoir une variable booléenne que l'on met à false quand la partie est terminée.
        boolean jeuEnCours = true;
        while (jeuEnCours) {
            try {
                arbitre.arbitrer(jeu);
                // Sauter une ligne
                System.out.println("");
            } catch (PartieTermineeException | PartieAbandonneeException e) {
                // La partie est terminée.
                System.out.println(e.getMessage());
                jeuEnCours = false
            }
        }
    }

    /**
     * Créer un joueur à partir de sa description (nom@stratégie)
     * @param description la description du joueur au format nom@stratégie
     * @param scanneur le scanneur pour lire les entrées de l'utilisateur
     * @return le joueur créé
     */
    private static Joueur creerJoueur(String description, Scanner scanneur) {
        String[] parts = description.split("@");
        if (parts.length != 2) {
            throw new ConfigurationException(
                "Description de joueur invalide : " + description
            );
        }
        String nom = parts[0];
        String nomStrategie = parts[1];
        Joueur joueur;
        Strategie strategie;
        switch (nomStrategie) {
            case "naif":
                strategie = new StrategieNaif();
                break;
            case "rapide":
                strategie = new StrategieRapide();
                break;
            case "expert":
                strategie = new StrategieExpert();
                break;
            case "humain":
                strategie = new StrategieHumain(scanneur, nom);
                break;
            case "tricheur":
                strategie = new StrategieTricheur();
                break;
            default:
                throw new ConfigurationException("Stratégie inconnue : " + nomStrategie);
        }
        return new Joueur(nom, strategie);
    }

    private static void verifierNombreArguments(String[] args) {
        final int nbJoueurs = 2;
        if (args.length < nbJoueurs) {
            throw new ConfigurationException("Trop peu d'arguments : " + args.length);
        }
        if (args.length > nbJoueurs + 1) {
            throw new ConfigurationException("Trop d'arguments : " + args.length);
        }
    }

    /** Afficher des indications sur la manière d'exécuter cette classe. */
    public static void afficherUsage() {
        System.out.println(
            "\n" +
            "Usage :" +
            "\n\t" +
            "java allumettes.Jouer joueur1 joueur2" +
            "\n\t\t" +
            "joueur est de la forme nom@stratégie" +
            "\n\t\t" +
            "strategie = naif | rapide | expert | humain | tricheur" +
            "\n" +
            "\n\t" +
            "Exemple :" +
            "\n\t" +
            "	java allumettes.Jouer Xavier@humain " +
            "Ordinateur@naif" +
            "\n"
        );
    }
}
