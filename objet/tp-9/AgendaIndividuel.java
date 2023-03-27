/**
 * Définition d'un agenda individuel.
 */
public class AgendaIndividuel extends AgendaAbstrait {

	private String[] rendezVous;	// le texte des rendezVous


	/**
	 * Créer un agenda vide (avec aucun rendez-vous).
	 *
	 * @param nom le nom de l'agenda
	 * @throws IllegalArgumentException si nom nul ou vide
	 */
	public AgendaIndividuel(String nom) throws IllegalArgumentException {
		super(nom);
		this.rendezVous = new String[Agenda.CRENEAU_MAX + 1];
			// On gaspille une case (la première qui ne sera jamais utilisée)
			// mais on évite de nombreux « creneau - 1 »
	}


	@Override
	public void enregistrer(int creneau, String rdv) throws CreneauInvalideException, OccupeException {
        this.verifierCreneauValide(creneau);
        if (rdv == null || rdv.length() == 0) {
            throw new IllegalArgumentException("Le rendez-vous doit avoir au moins un caractère");
        }
        if (this.rendezVous[creneau] != null) {
            throw new OccupeException("Le créneau " + creneau + " est déjà occupé");
        }
		this.rendezVous[creneau] = rdv;
	}


	@Override
	public boolean annuler(int creneau) throws CreneauInvalideException {
        this.verifierCreneauValide(creneau);
		boolean modifie = this.rendezVous[creneau] != null;
		this.rendezVous[creneau] = null;
		return modifie;
	}


	@Override
	public String getRendezVous(int creneau) throws CreneauInvalideException, LibreException {
        this.verifierCreneauValide(creneau);
		String rdv = this.rendezVous[creneau];
        if (rdv == null) {
            throw new LibreException("Le créneau " + creneau + " est libre");
        }
        return rdv;
	}


}
