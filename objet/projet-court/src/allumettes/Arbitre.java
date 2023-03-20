package allumettes;

public class Arbitre {

    private int tourAuJoueur;
    private Joueur j1;
    private Joueur j2;
    private boolean confiant;

    /**
     * Faire jouer un joueur, et contrôler la triche de son coup.
     *
     * @param jeu le jeu à arbitrer
     */
    public void arbitrer(Jeu jeu)
        throws PartieTermineeException, PartieAbandonneeException {
        Joueur joueur = this.tourAuJoueur == 1 ? this.j1 : this.j2;
        Joueur adversaire = this.tourAuJoueur == 1 ? this.j2 : this.j1;

        try {
            this.faireJouer(joueur, jeu);
        } catch (OperationInterditeException e) {
            throw new PartieAbandonneeException(joueur);
        }

        if (jeu.getNombreAllumettes() <= 0) {
            throw new PartieTermineeException(adversaire, joueur);
        }

        this.tourAuJoueur = this.tourAuJoueur == 1 ? 2 : 1;
    }

    private void faireJouer(Joueur joueur, Jeu jeu) throws OperationInterditeException {
        Jeu plateauJoueur = this.confiant ? jeu : new PlateauProcuration(jeu);

        System.out.printf("Allumettes restantes : %d\n", jeu.getNombreAllumettes());
        try {
            int prise = joueur.getPrise(plateauJoueur);
            System.out.printf(
                "%s prend %d allumette%s.\n",
                joueur.getNom(),
                prise,
                prise > 1 ? "s" : ""
            );
            int limite = Math.min(Jeu.PRISE_MAX, jeu.getNombreAllumettes());
            if (prise > limite) {
                throw new CoupInvalideException(
                    prise,
                    String.format("Nombre invalide : %d (> %d)", prise, limite)
                );
            }
            jeu.retirer(prise);
        } catch (CoupInvalideException e) {
            System.out.println("Impossible ! " + e.getProbleme());
            this.faireJouer(joueur, jeu);
        } catch (OperationInterditeException e) {
            throw e;
        }
    }

    /**
     * Nouvel arbitre entre deux joueurs.
     *
     * @param j1 un joueur (le premier à jouer)
     * @param j2 l'autre joueur
     */
    public Arbitre(Joueur j1, Joueur j2) {
        this.j1 = j1;
        this.j2 = j2;
        this.tourAuJoueur = 1;
    }

    public Arbitre(Joueur j1, Joueur j2, boolean confiant) {
        this(j1, j2);
        this.confiant = confiant;
    }
}
