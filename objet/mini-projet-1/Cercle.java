import java.awt.Color;

interface Mesurable2D {
    double perimetre();

    double aire();
}

class Cercle implements Mesurable2D {
    // C12
    public static final double PI = Math.PI;

    // E8 & E18
    private Color couleur;
    private Point centre;
    private double rayon;

    // E4
    public double getDiametre() {
        return 2 * this.rayon;
    }

    // E3
    public double getRayon() {
        return this.rayon;
    }

    // E16
    public void setRayon(double rayon) {
        assert rayon > 0;
        this.rayon = rayon;
    }

    // E2
    public Point getCentre() {
        Point centre = new Point(this.centre.getX(), this.centre.getY());
        return centre;
    }

    // E17
    public void setDiametre(double diametre) {
        assert diametre > 0;
        this.setRayon(diametre / 2);
    }

    // E9
    public Color getCouleur() {
        return this.couleur;
    }

    // E10
    public void setCouleur(Color couleur) {
        assert couleur != null;
        this.couleur = couleur;
    }

    // E1
    public void translater(double dx, double dy) {
        this.centre.translater(dx, dy);
    }

    // E5
    public boolean contient(Point p) {
        assert p != null;
        return this.centre.distance(p) <= this.rayon;
    }

    // E15
    public String toString() {
        return "C" + this.rayon + "@" + this.centre;
    }

    public void afficher() {
        System.out.println(this);
    }

    // E11
    public Cercle(Point centre, double rayon) {
        assert centre != null;
        assert rayon > 0;
        this.centre = new Point(centre.getX(), centre.getY());
        this.rayon = rayon;
        this.couleur = Color.BLUE;
    }

    // E13
    public Cercle(Point a, Point b, Color couleur) {
        assert a != null;
        assert b != null;
        assert couleur != null;
        assert a.distance(b) > 0;
        this.centre = new Point((a.getX() + b.getX()) / 2, (a.getY() + b.getY()) / 2);
        this.rayon = a.distance(b) / 2;
        this.couleur = couleur;
    }

    // E12
    public Cercle(Point a, Point b) {
        this(a, b, Color.BLUE);
    }

    // E14
    public static Cercle creerCercle(Point centre, Point surCirconference) {
        assert centre != null;
        assert surCirconference != null;
        return new Cercle(centre, centre.distance(surCirconference));
    }

    // E6
    public double perimetre() {
        return 2 * Cercle.PI * this.rayon;
    }

    public double aire() {
        return Cercle.PI * this.rayon * this.rayon;
    }
}
