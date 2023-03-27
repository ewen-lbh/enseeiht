import java.util.List;

/** Quelques outils (méthodes) sur les listes.  */
public class Outils {

  /** Retourne vrai ssi tous les éléments de la collection respectent le critère. */
  public static <F, E extends F> boolean tous(List<E> elements, Critere<F> critere) {
    for (F e : elements) {
      if (!critere.satisfaitSur(e)) {
        return false;
      }
    }
    return true;
  }

  /** Ajouter dans resultat tous les éléments de la source
   * qui satisfont le critère aGarder.
   */
  public static <F, Crit extends F, Src extends Crit> void filtrer(
    List<Src> source,
    Critere<Crit> aGarder,
    List<F> resultat
  ) {
    for (Src e : source) {
      if (aGarder.satisfaitSur(e)) {
        resultat.add(e);
      }
    }
  }
}
