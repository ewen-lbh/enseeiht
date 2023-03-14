import java.io.*;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collector;
import java.util.stream.Collectors;
import java.util.zip.*;

/**
 * La classe principale.
 *
 * Tous les traitements demandés sont faits dans la mêthode
 * {@code repondreQuestions}.
 * Il serait plus logique d'écrire des méthodes qui pemettraient d'améliorer
 * la structuration et la réutilisation.  Cependant l'objectif est ici la
 * manipulation de l'API des collections, pas la structuration du code
 * en sous-programmes.
 */

public class Main {

  private static void repondreQuestions(Reader in) {
    Iterable<PointDeVente> iterable = PointDeVenteUtils.fromXML(in);

    // Construire un tableau associatif (pdvs) des points de vente avec un
    // accès par identifiant
    Map<Long, PointDeVente> pdvs = new HashMap<>();
    for (PointDeVente pointDeVente : iterable) {
      pdvs.put(pointDeVente.getIdentifiant(), pointDeVente);
    }

    // Nombre de point de vente
    pdvs.size();

    // Afficher le nombre de services existants
    System.out.println(
      pdvs
        .values()
        .stream()
        .map(point -> point.getServices().size())
        .reduce(0, (a, b) -> a + b)
    );

    // Afficher les services fournis
    System.out.println(
      pdvs
        .values()
        .stream()
        .map(point -> point.getServices())
        .collect(Collectors.toSet())
    );

    // Afficher la ville correspondant au point de vente d'identifiant
    // 31075001 et le prix du gazole le 25 janvier 2017 à 10h.
    System.out.println(
      pdvs.get(31075001L).getVille() +
      ": " +
      pdvs
        .get(31075001L)
        .getPrix(Carburant.GAZOLE, LocalDateTime.of(2017, 1, 25, 10, 0))
    );

    // Afficher le nombre de villes offrant au moins un point de vente
    Set<String> villesAvecPointsDeVente = pdvs
      .values()
      .stream()
      .map(point -> point.getVille())
      .collect(Collectors.toSet());
    System.out.println(villesAvecPointsDeVente.size());

    // Afficher le nombre moyen de points de vente par ville
    Long somme = 0L;
    for (String ville : villesAvecPointsDeVente) {
      somme +=
        pdvs
          .values()
          .stream()
          .filter(point -> point.getVille().equals(ville))
          .count();
    }
    System.out.println(somme / villesAvecPointsDeVente.size());

    // le nombre de villes offrants un certain nombre de carburants
    Integer nombreDeCarburants = 2;
    pdvs
      .values()
      .stream()
      .filter(point -> point.getPrix().size() == nombreDeCarburants)
      .count();

    // Afficher le nombre et les points de vente dont le code postal est 31200
    Set<PointDeVente> pointsDeVenteToulouse200 = pdvs
      .values()
      .stream()
      .filter(point -> point.getCodePostal().equals("31200"))
      .collect(Collectors.toSet());
    System.out.println(
      pointsDeVenteToulouse200.size() +
      " points de vente à Toulouse (31200) : " +
      pointsDeVenteToulouse200
    );

    // Nombre de PDV de la ville de Toulouse qui proposent et du Gazole
    // et du GPLc.
    pdvs
      .values()
      .stream()
      .filter(point ->
        point.getVille().equals("Toulouse") &&
        point.getPrix().containsKey(Carburant.GAZOLE) &&
        point.getPrix().containsKey(Carburant.GPLc)
      )
      .count();
    // Afficher le nom et le nombre de points de vente des villes qui ont au
    // moins 20 points de vente

  }

  private static Reader ouvrir(String nomFichier)
    throws FileNotFoundException, IOException {
    if (nomFichier.endsWith(".zip")) {
      // On suppose que l'archive est bien formée :
      // elle contient fichier XML !
      ZipFile zfile = new ZipFile(nomFichier);
      ZipEntry premiere = zfile.entries().nextElement();
      return new InputStreamReader(zfile.getInputStream(premiere));
    } else {
      return new FileReader(nomFichier);
    }
  }

  public static void main(String[] args) {
    if (args.length != 1) {
      System.out.println("usage : java Main <fichier.xml ou fichier.zip>");
    } else {
      try (Reader in = ouvrir(args[0])) {
        repondreQuestions(in);
      } catch (FileNotFoundException e) {
        System.out.println("Fichier non trouvé : " + args[0]);
      } catch (Exception e) {
        System.out.println(e.getMessage());
        e.printStackTrace();
      }
    }
  }
}
