import org.junit.*;
import static org.junit.Assert.*;


public class CompteSimpleTest {
    public static final double EPSILON = 1e-12;
    Personne p1;
    Personne p2;
    CompteSimple c1;
    CompteSimple c2;

    @Before
    public void setUp() {
        this.p1 = new Personne("Ewen", "Le Bihan", 20);
        this.p2 = new Personne("Jean", "Dupont", 30);
        this.c1 = new CompteSimple(100, p1);
        this.c2 = new CompteSimple(p2);
    }

    @Test
    public 
}
