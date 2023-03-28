import java.awt.*;
import java.awt.event.*;
import java.util.*;
import javax.swing.*;
import javax.swing.event.*;

/** Programmation d'un jeu de Morpion avec une interface graphique Swing.
 *
 * REMARQUE : Dans cette solution, le patron MVC n'a pas été appliqué !
 * On a un modèle (?), une vue et un contrôleur qui sont fortement liés.
 *
 * @author	Xavier Crégut
 * @version	$Revision: 1.4 $
 */

public class MorpionSwing {

  // les images à utiliser en fonction de l'état du jeu.
  private static final Map<ModeleMorpion.Etat, ImageIcon> images = new HashMap<ModeleMorpion.Etat, ImageIcon>();

  static {
    images.put(ModeleMorpion.Etat.VIDE, new ImageIcon("../blanc.jpg"));
    images.put(ModeleMorpion.Etat.CROIX, new ImageIcon("../croix.jpg"));
    images.put(ModeleMorpion.Etat.ROND, new ImageIcon("../rond.jpg"));
  }

  // Choix de réalisation :
  // ----------------------
  //
  //  Les attributs correspondant à la structure fixe de l'IHM sont définis
  //	« final static » pour montrer que leur valeur ne pourra pas changer au
  //	cours de l'exécution.  Ils sont donc initialisés sans attendre
  //  l'exécution du constructeur !

  private ModeleMorpion modele; // le modèle du jeu de Morpion

  //  Les éléments de la vue (IHM)
  //  ----------------------------

  /** Fenêtre principale */
  private JFrame fenetre;

  /** Bouton pour quitter */
  private final JButton boutonQuitter = new JButton("Q");

  /** Bouton pour commencer une nouvelle partie */
  private final JButton boutonNouvellePartie = new JButton("N");

  /** Cases du jeu */
  private final JLabel[][] cases = new JLabel[3][3];

  /** Zone qui indique le joueur qui doit jouer */
  private final JLabel joueur = new JLabel();

  // Le constructeur
  // ---------------

  /** Construire le jeu de morpion */
  public MorpionSwing() {
    this(new ModeleMorpionSimple());
  }

  /** Construire le jeu de morpion */
  public MorpionSwing(ModeleMorpion modele) {
    // Initialiser le modèle
    this.modele = modele;

    // Créer les cases du Morpion
    for (int i = 0; i < this.cases.length; i++) {
      for (int j = 0; j < this.cases[i].length; j++) {
        this.cases[i][j] = new JLabel();
      }
    }

    // Initialiser le jeu
    this.recommencer();

    // Construire la vue (présentation)
    //	Définir la fenêtre principale
    this.fenetre = new JFrame("Morpion");
    this.fenetre.setLocation(100, 200);

    JMenuItem menuItemRecommencer = new JMenuItem("Nouvelle partie");
    JMenuItem menuItemQuitter = new JMenuItem("Quitter");
    JMenu menu = new JMenu("Jeu");
    menu.add(menuItemRecommencer);
    menu.add(menuItemQuitter);

    menuItemRecommencer.addActionListener(
      new ActionListener() {
        @Override
        public void actionPerformed(ActionEvent arg0) {
          recommencer();
        }
      }
    );

    menuItemQuitter.addActionListener(
      new ActionListener() {
        @Override
        public void actionPerformed(ActionEvent arg0) {
          System.exit(0);
        }
      }
    );

    JMenuBar menubar = new JMenuBar();
    menubar.add(menu);
    this.fenetre.setJMenuBar(menubar);
    // Construire le contrôleur (gestion des événements)
    this.fenetre.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

    //
    this.fenetre.setLayout(new GridLayout(4, 3));
    for (int i = 0; i < this.cases.length; i++) {
      for (int j = 0; j < this.cases[i].length; j++) {
        this.fenetre.add(this.cases[i][j]);
        final int positionI = i;
        final int positionJ = j;
        this.cases[i][j].addMouseListener(
            new MouseAdapter() {
              @Override
              public void mouseClicked(MouseEvent arg0) {
                try {
                  modele.cocher(positionI, positionJ);
                  cases[positionI][positionJ].setIcon(
                      images.get(modele.getValeur(positionI, positionJ))
                    );
                  joueur.setIcon(images.get(modele.getJoueur()));
                  if (modele.estGagnee()) {
                    JOptionPane.showMessageDialog(
                      fenetre,
                      "Partie terminée, les " + (
                        modele.getJoueur() == ModeleMorpion.Etat.CROIX
                          ? "croix"
                          : "ronds"
                      ) +
                      " ont gagné!"
                    );
                  } else if (modele.estTerminee()) {
                    JOptionPane.showMessageDialog(
                      fenetre,
                      "Partie terminée, égalité!"
                    );
                  }
                } catch (Exception e) {
                  System.out.println(e.getMessage());
                }
              }
            }
          );
      }
    }

    this.boutonNouvellePartie.addActionListener(
        new ActionListener() {
          @Override
          public void actionPerformed(ActionEvent arg0) {
            recommencer();
          }
        }
      );

    this.boutonQuitter.addActionListener(
        new ActionListener() {
          @Override
          public void actionPerformed(ActionEvent arg0) {
            System.exit(0);
          }
        }
      );

    this.fenetre.add(boutonNouvellePartie);
    this.fenetre.add(joueur);
    this.fenetre.add(boutonQuitter);

    // afficher la fenêtre
    // this.fenetre.setMinimumSize(new Dimension(200, 200));
    this.fenetre.pack(); // redimmensionner la fenêtre
    this.fenetre.setVisible(true); // l'afficher
  }

  // Quelques réactions aux interactions de l'utilisateur
  // ----------------------------------------------------

  /** Recommencer une nouvelle partie. */
  public void recommencer() {
    this.modele.recommencer();

    // Vider les cases
    for (int i = 0; i < this.cases.length; i++) {
      for (int j = 0; j < this.cases[i].length; j++) {
        this.cases[i][j].setIcon(images.get(this.modele.getValeur(i, j)));
      }
    }

    // Mettre à jour le joueur
    joueur.setIcon(images.get(modele.getJoueur()));
  }

  // La méthode principale
  // ---------------------

  public static void main(String[] args) {
    EventQueue.invokeLater(
      new Runnable() {
        public void run() {
          new MorpionSwing();
        }
      }
    );
  }
}
