/**
 * AgendaAbstrait factorise la définition du nom et de l'accesseur associé.
 */
public abstract class AgendaAbstrait extends ObjetNomme implements Agenda {

    /**
     * Initialiser le nom de l'agenda.
     *
     * @param nom le nom de l'agenda
     * @throws IllegalArgumentException si nom n'a pas au moins un caractère
     */
    public AgendaAbstrait(String nom) throws IllegalArgumentException {
        super(nom);
    }

    public void verifierCreneauValide(int creneau) throws CreneauInvalideException {
        if (creneau < Agenda.CRENEAU_MIN || creneau > Agenda.CRENEAU_MAX) {
            throw new CreneauInvalideException(
                    "Le créneau doit être entre " + Agenda.CRENEAU_MIN + " et " + Agenda.CRENEAU_MAX);
        }
    }
}
