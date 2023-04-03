package allumettes;

import static org.junit.Assert.*;

import org.junit.*;

public class StrategieRapideTest {

    @Test
    public void testGetPriseConditionsNormales()
        throws CoupInvalideException, OperationInterditeException {
        StrategieRapide s = new StrategieRapide();
        Jeu jeu = new Plateau();
        assertEquals(Plateau.PRISE_MAX, s.getPrise(jeu));
        jeu.retirer(1);
        assertEquals(Plateau.PRISE_MAX, s.getPrise(jeu));
        jeu.retirer(4);
        assertEquals(3, s.getPrise(jeu));
    }

    @Test
    public void testGetPriseConditionsLimites()
        throws CoupInvalideException, OperationInterditeException {
        StrategieRapide s = new StrategieRapide();
        Jeu jeu = new Plateau(2);
        System.out.printf("%d\n", jeu.getNombreAllumettes());
        assertEquals(1, s.getPrise(jeu));
    }

    @Test
    public void testGetPriseConditionsLimites2()
        throws CoupInvalideException, OperationInterditeException {
        StrategieRapide s = new StrategieRapide();
        Jeu jeu = new Plateau(1);
        assertEquals(1, s.getPrise(jeu));
    }

    @Test(expected = IllegalArgumentException.class)
    public void testGetPriseConditionsLimites3()
        throws CoupInvalideException, OperationInterditeException {
        StrategieRapide s = new StrategieRapide();
        Jeu jeu = new Plateau(0);
        assertEquals(1, s.getPrise(jeu));
    }

    @Test
    public void testGetPriseConditionsLimites4()
        throws CoupInvalideException, OperationInterditeException {
        StrategieRapide s = new StrategieRapide();
        Jeu jeu = new Plateau(Plateau.NB_ALLUMETTES_INITIAL);
        assertEquals(Plateau.PRISE_MAX, s.getPrise(jeu));
    }

    @Test
    public void testGetPriseConditionsLimites5()
        throws CoupInvalideException, OperationInterditeException {
        StrategieRapide s = new StrategieRapide();
        Jeu jeu = new Plateau(Plateau.NB_ALLUMETTES_INITIAL + 1);
    }

    @Test(expected = IllegalArgumentException.class)
    public void testGetPriseConditionsLimites6()
        throws CoupInvalideException, OperationInterditeException {
        StrategieRapide s = new StrategieRapide();
        Jeu jeu = new Plateau(-1);
    }
}
