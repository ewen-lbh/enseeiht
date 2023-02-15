/** Tester le polymorphisme (principe de substitution) et la liaison
 * dynamique.
 * @author	Xavier Crégut
 * @version	1.5
 */
public class TestPolymorphisme {

	/** Méthode principale */
	public static void main(String[] args) {
		// Créer et afficher un point p1
		Point p1 = new Point(3, 4);	// Est-ce autorisé ? Pourquoi ?
                                    // Oui, car 3 et 4 sont compatibles avec double, et Point est bien un constructeur de Point ou d'une classe fille de Point.
		p1.translater(10,10);		// Quel est le translater exécuté ?
                                    // Le translater de Point, car p1 est un Point.
		System.out.print("p1 = "); p1.afficher (); System.out.println ();
										// Qu'est ce qui est affiché ?
                                        // p1 = (13, 14)

		// Créer et afficher un point nommé pn1
		PointNomme pn1 = new PointNomme (30, 40, "PN1");
										// Est-ce autorisé ? Pourquoi ?
                                        // Les arguments sont dans des types compatibles
		pn1.translater (10,10);		// Quel est le translater exécuté ?
                                    // PointNomme n'override pas translater, donc le translater de Point est exécuté.
		System.out.print ("pn1 = "); pn1.afficher(); System.out.println ();
										// Qu'est ce qui est affiché ?
                                        // pn1 = PN1:(40, 50)

		// Définir une poignée sur un point
		Point q;

		// Attacher un point à q et l'afficher
		q = p1;				// Est-ce autorisé ? Pourquoi ?
                            // p1 est un Point, donc pointe sur un Point, et q pointe également sur un Point
		System.out.println ("> q = p1;");
		System.out.print ("q = "); q.afficher(); System.out.println ();
										// Qu'est ce qui est affiché ?
                                        // q = (13, 14)

		// Attacher un point nommé à q et l'afficher
		q = pn1;			// Est-ce autorisé ? Pourquoi ?
                            // PointNomme hérite de Point, donc implémente son interface, donc est un Point.
		System.out.println ("> q = pn1;");
		System.out.print ("q = "); q.afficher(); System.out.println ();
										// Qu'est ce qui est affiché ?
                                        // q = (40, 50)

		// Définir une poignée sur un point nommé
		PointNomme qn;

		// Attacher un point à q et l'afficher
		/* qn = p1;			// Est-ce autorisé ? Pourquoi ?
                            // NON, car p1 est un Point, et qn est un PointNomme, et Point n'implémente pas l'interface de PointNomme.
		System.out.println ("> qn = p1;");
		System.out.print ("qn = "); qn.afficher(); System.out.println ();
										// Qu'est ce qui est affiché ?
                                        */

		// Attacher un point nommé à qn et l'afficher
		qn = pn1;			// Est-ce autorisé ? Pourquoi ?
                            // qn et pn1 pointent vers des PointNomme, les interfaces sont donc compatibles
		System.out.println ("> qn = pn1;");
		System.out.print ("qn = "); qn.afficher(); System.out.println ();
										// Qu'est ce qui est affiché ?
                                        // qn = PN1:(30, 40)

		double d1 = p1.distance (pn1);	// Est-ce autorisé ? Pourquoi ?
                                        // pn1 est un PointNomme qui hérite de donc implémente Point
		System.out.println ("distance = " + d1);

		double d2 = pn1.distance (p1);	// Est-ce autorisé ? Pourquoi ?
                                        // distance provient de Point car PointNomme ne l'override pas, donc un Point est accepté comme argument
		System.out.println ("distance = " + d2);

		double d3 = pn1.distance (pn1);	// Est-ce autorisé ? Pourquoi ?
                                        // pn1 est un PointNomme qui hérite de donc implémente Point, et distance provient de Point car PointNomme ne l'override pas
		System.out.println ("distance = " + d3);

		System.out.println ("> qn = q;");
		/* qn = q;				// Est-ce autorisé ? Pourquoi ?
                            // qn pointe sur un PointNomme et q est une poignée sur un Point
		System.out.print ("qn = "); qn.afficher(); System.out.println ();
										// Qu'est ce qui est affiché ?
                                        */

		System.out.println ("> qn = (PointNomme) q;");
		qn = (PointNomme) q;		// Est-ce autorisé ? Pourquoi ?
                                    // Oui, car q pointe sur un objet PointNomme qui a été considéré comme un Point, mais les données nécéssaires à l'implémentation de l'interface de PointNomme sont présentes, il n'y aura pas d'exceptions levées.
		System.out.print ("qn = "); qn.afficher(); System.out.println ();

		/* System.out.println ("> qn = (PointNomme) p1;");
		qn = (PointNomme) p1;		// Est-ce autorisé ? Pourquoi ?
                                    // p1 pointe réellement sur un Point (et nom un objet PointNomme considéré comme un Point), donc non, l'appel lèvera une exception
		System.out.print ("qn = "); qn.afficher(); System.out.println (); */
	}

}
