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

	private static void jouer(Jeu jeu, Arbitre arbitre) {
		while (true) {
			try {
				arbitre.arbitrer(jeu);
				System.out.println("");
			} catch (PartieTermineeException | PartieAbandonneeException e) {
				System.out.println(e.getMessage());
				break;
			}
		}
	}

	private static Joueur creerJoueur(String description, Scanner scanneur) {
		String[] parts = description.split("@");
		if (parts.length != 2) {
			throw new ConfigurationException("Description de joueur invalide : "
					+ description);
		}
		String nom = parts[0];
		String strategie = parts[1];
		Joueur joueur;
		switch (strategie) {
			case "naif":
				joueur = new JoueurNaif(nom);
				break;
			case "rapide":
				joueur = new JoueurRapide(nom);
				break;
			case "expert":
				joueur = new JoueurExpert(nom);
				break;
			case "humain":
				joueur = new JoueurHumain(nom, scanneur);
				break;
			case "tricheur":
				joueur = new JoueurTricheur(nom);
				break;
			default:
				throw new ConfigurationException("Stratégie inconnue : "
						+ strategie);
		}
		return joueur;
	}

	private static void verifierNombreArguments(String[] args) {
		final int nbJoueurs = 2;
		if (args.length < nbJoueurs) {
			throw new ConfigurationException("Trop peu d'arguments : "
					+ args.length);
		}
		if (args.length > nbJoueurs + 1) {
			throw new ConfigurationException("Trop d'arguments : "
					+ args.length);
		}
	}

	/** Afficher des indications sur la manière d'exécuter cette classe. */
	public static void afficherUsage() {
		System.out.println("\n" + "Usage :"
				+ "\n\t" + "java allumettes.Jouer joueur1 joueur2"
				+ "\n\t\t" + "joueur est de la forme nom@stratégie"
				+ "\n\t\t" + "strategie = naif | rapide | expert | humain | tricheur"
				+ "\n"
				+ "\n\t" + "Exemple :"
				+ "\n\t" + "	java allumettes.Jouer Xavier@humain "
				+ "Ordinateur@naif"
				+ "\n");
	}

}
