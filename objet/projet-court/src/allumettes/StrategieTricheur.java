package allumettes;

public class StrategieTricheur extends Strategie {

    @Override
    public int getPrise(Jeu jeu)
        throws OperationInterditeException, CoupInvalideException {
        System.out.println("[Je triche...]");
        jeu.retirer(jeu.getNombreAllumettes() - 2);
        System.out.printf("[Allumettes restantes: %d]\n", jeu.getNombreAllumettes());
        return 1;
    }
}
