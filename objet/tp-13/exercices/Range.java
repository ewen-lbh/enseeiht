package exercices;

import java.util.Iterator;

public class Range implements Iterable<Integer> {

  public static Range range(int start, int end, int step) {
    return new Range(start, end, step);
  }

  public static Range range(int start, int end) {
    return range(start, end, 1);
  }

  public static Range range(int end) {
    return range(0, end, 1);
  }

  public Range(int start, int end, int step) {
    if (step <= 0) throw new IllegalArgumentException(
      "Le pas doit être positif"
    );

    this.end = end;
    this.step = step;
    this.start = start;
  }

  private Integer end;
  private Integer step;
  private Integer start;

  @Override
  public Iterator<Integer> iterator() {
    return new Iterator<Integer>() {
      private Integer current = start;

      @Override
      public boolean hasNext() {
        return current + step <= end;
      }

      @Override
      public Integer next() {
        if (!hasNext()) throw new java.util.NoSuchElementException();
        Integer result = current;
        current += step;
        return result;
      }
    };
  }
}
