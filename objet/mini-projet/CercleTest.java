import java.awt.Color;
import org.junit.*;
import static org.junit.Assert.*;

/**
 * Classe de test (incomplète) de la classe Cercle.
 * 
 * @author Ewen Le Bihan
 * @version $Revision$
 */
public class CercleTest {

    // Précision pour les comparaisons réelle
    public final static double EPSILON = 0.001;

    // Les points et cercles des exigences
    private Point E12_1A, E12_1B, E13_1A, E13_1B, E14_1Centre, E14_1Circonf, E12_2A, E12_2B;
    private Cercle E12_1Cercle, E13_1Cercle, E14_1Cercle, E12_2Cercle;
    private Point E12_3A;
    private Point E12_3B;
    private Cercle E12_3Cercle;
    private Point E12_4A;
    private Point E12_4B;
    private Cercle E12_4Cercle;

    @Before
    public void setUp() {
        // Points opposés
        // Symmétrie diagonale, pente 1
        E12_1A = new Point(2, 4);
        E12_1B = new Point(4, 2);
        // Symmétrie verticale
        E12_2A = new Point(0, -1);
        E12_2B = new Point(0, 1);
        // Symmétrie horizontale
        E12_3A = new Point(3, -3);
        E12_3B = new Point(-3, -3);
        // Symmétrie diagonale, pente -0.5
        E12_4A = new Point(1, 1);
        E12_4B = new Point(3, 3);

        E13_1A = new Point(1, 3);
        E13_1B = new Point(3, 2);
        E14_1Centre = new Point(1, 3);
        E14_1Circonf = new Point(3, 2);

        // Cercle
        E12_1Cercle = new Cercle(E12_1A, E12_1B);
        E12_2Cercle = new Cercle(E12_2A, E12_2B);
        E12_3Cercle = new Cercle(E12_3A, E12_3B);
        E12_4Cercle = new Cercle(E12_4A, E12_4B);

        E13_1Cercle = new Cercle(E13_1A, E13_1B, Color.RED);
        E14_1Cercle = Cercle.creerCercle(E14_1Centre, E14_1Circonf);
    }

    /**
     * Vérifier si deux points ont mêmes coordonnées.
     * 
     * @param p1 le premier point
     * @param p2 le deuxième point
     */
    static void memesCoordonnees(String message, Point p1, Point p2) {
        assertEquals(message + " (x)", p1.getX(), p2.getX(), EPSILON);
        assertEquals(message + " (y)", p1.getY(), p2.getY(), EPSILON);
    }

    @Test
    public void testerE12() {
        memesCoordonnees("E12_1: Le cercle n'est pas au milieu de la droite entre les deux points",
                E12_1Cercle.getCentre(),
                new Point(3, 3));
        assertEquals("E12_1: Le cercle n'est pas bleu", Color.BLUE, E12_1Cercle.getCouleur());

        memesCoordonnees("E12_2: Le cercle n'est pas au milieu de la droite entre les deux points",
                E12_2Cercle.getCentre(),
                new Point(0, 0));
        assertEquals("E12_2: Le cercle n'est pas bleu", Color.BLUE, E12_2Cercle.getCouleur());

        memesCoordonnees("E12_3: Le cercle n'est pas au milieu de la droite entre les deux points",
                E12_3Cercle.getCentre(),
                new Point(0, -3));
        assertEquals("E12_3: Le cercle n'est pas bleu", Color.BLUE, E12_3Cercle.getCouleur());

        memesCoordonnees("E12_4: Le cercle n'est pas au milieu de la droite entre les deux points",
                E12_4Cercle.getCentre(),
                new Point(2, 2));
    }

    @Test(expected = AssertionError.class)
    public void testerE12DistanceNulle() {
        new Cercle(E12_1A, E12_1A);
    }

    @Test
    public void testerE13() {
        memesCoordonnees("E13: Le cercle n'est pas au milieu de la droite entre les deux points",
                E13_1Cercle.getCentre(),
                new Point(2, 2.5));
        assertEquals("E13: Le cercle n'est pas rouge", Color.RED, E13_1Cercle.getCouleur());
    }

    @Test(expected = AssertionError.class)
    public void testerE13CouleurNulle() {
        new Cercle(E12_1A, E12_1B, null);
    }

    @Test(expected = AssertionError.class)
    public void testerE13PointNul() {
        new Cercle(null, E12_1B, Color.RED);
    }

    @Test
    public void testerE14() {
        memesCoordonnees("E14: Le centre n'est pas celui passé en argument", E14_1Centre, E14_1Cercle.getCentre());
        assertEquals(Math.sqrt(5), E14_1Cercle.getRayon(), EPSILON);
    }
}
