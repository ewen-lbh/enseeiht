package allumettes;
import static org.junit.Assert.*;

import org.junit.*;

public class StrategieRapideTest {

    @Test
    public void testGetPriseConditionsNormales() {
        StrategieRapide s = new StrategieRapide();
        Jeu jeu = new Plateau();
        assertEquals(Plateau.PRISE_MAX, s.getPrise(jeu));
        jeu.retirer(0);
    }
}
