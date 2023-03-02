import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class GroupeAgenda extends AgendaAbstrait {
    private List<Agenda> agendas;

    public GroupeAgenda(String nom) {
        super(nom);
        this.agendas = new ArrayList<Agenda>();
    }

    public GroupeAgenda(String nom, List<Agenda> agendas) {
        super(nom);
        this.agendas = new ArrayList<Agenda>(agendas);
    }

    public void ajouter(Agenda agenda) {
        this.agendas.add(agenda);
    }

    @Override
    public boolean annuler(int creneau) throws CreneauInvalideException {
        this.verifierCreneauValide(creneau);
        boolean anyModified = false;
        for (Agenda agenda : this.agendas) {
            anyModified = anyModified || agenda.annuler(creneau);
        }
        return anyModified;
    }

    @Override
    public void enregistrer(int creneau, String rdv)
            throws CreneauInvalideException, IllegalArgumentException, OccupeException {
        this.verifierCreneauValide(creneau);
        System.out.println(this.agendas);
        for (Agenda agenda : this.agendas) {
            try {
                agenda.getRendezVous(creneau);
                throw new OccupeException("L'agenda " + agenda.getNom() + " est déjà occupé");
            } catch (LibreException e) {
                continue;
            }
        }

        this.agendas.forEach(agenda -> {
            try {
                agenda.enregistrer(creneau, rdv);
            } catch (CreneauInvalideException | OccupeException e) {
                // Déjà handled par le for
            }
        });
    }

    @Override
    public String getRendezVous(int creneau)
            throws CreneauInvalideException, OccupeException, IllegalArgumentException, LibreException {
        Set<String> rendezVous = new HashSet<String>();

        for (Agenda agenda : this.agendas) {
            try {
                rendezVous.add(agenda.getRendezVous(creneau));
            } catch (LibreException e) {
                rendezVous.add(null);
                continue;
            }
        }

        if (rendezVous.size() > 1) {
            return null;
        }

        String rdv = rendezVous.iterator().next();

        if (rdv == null) {
            throw new LibreException("Aucun rendez-vous n'est prévu à ce créneau");
        }

        return rdv;

    }
}
