extension IterableExtension<E> on Iterable<E> {
  /// Returns all unique elements paired with the number of occurences they have
  /// in this [Iterable].
  List<(E, int)> counts() {
    return countsMap()
        .entries
        .map(
          (MapEntry entry) => (
            entry.key,
            entry.value,
          ) as (E, int),
        )
        .toList();
  }

  Map<E, int> countsMap() {
    final Map<E, int> counts = {};
    final Iterator elementIterator = iterator;
    while (elementIterator.moveNext()) {
      final E element = elementIterator.current;
      final int? count = counts[element];
      counts[element] = count == null ? 1 : count + 1;
    }

    return Map.fromEntries(counts.entries);
  }

  /// Convenience getter for accessing the second element in an [Iterable].
  E get second => elementAt(1);

  /// Convenience getter for accessing the middle element in an [Iterable].
  ///
  /// Asserts whether the iterable has an uneven number of elements.
  E get middle {
    assert(
      length % 2 == 1,
      'Cannot get middle element of iterable with an even number of elements',
    );
    return elementAt(length ~/ 2);
  }

  /// Zips this with [other].
  ///
  /// Returns an iterable containing [Pair]s, where the left element is from
  /// this and the right element is from [other].
  ///
  /// The resulting iterable will have the same length as the shortest iterable
  /// of the two. Values of the longer iterable that are 'alone' are dropped.
  Iterable<(E, R)> zip<R>(Iterable<R> other) sync* {
    final iteratorA = iterator;
    final iteratorB = other.iterator;

    while (iteratorA.moveNext() && iteratorB.moveNext()) {
      yield (iteratorA.current, iteratorB.current);
    }
  }

  /// Shorthand for [slidingWindow].
  Iterable<List<E>> sw(int windowSize) => slidingWindow(windowSize);

  /// Returns a sliding window for a window of size [windowSize].
  ///
  /// [windowSize] should be [1..length].
  ///
  /// TODO: .toList repeats last element???
  Iterable<List<E>> slidingWindow(int windowSize) sync* {
    assert(
        windowSize <= length, 'Window size is larger than number of elements');
    assert(windowSize > 0, 'Window size should be at least 1');

    List<E> window = [];
    final Iterator valueIterator = iterator;

    for (int i = 0; i < windowSize; i++) {
      valueIterator.moveNext();
      window.add(valueIterator.current);
    }

    yield window;

    while (valueIterator.moveNext()) {
      window.removeAt(0);
      window.add(valueIterator.current);

      yield window;
    }
  }

  Iterable<(E, E)> combinations() sync* {
    for (int i = 0; i < length; i++) {
      final E a = elementAt(i);
      for (E b in skip(i)) {
        yield (a, b);
      }
    }
  }

  Iterable<E> repeat(int n) {
    assert(n >= 0);

    if (n == 0) {
      return [];
    }
    return followedBy(repeat(n - 1));
  }
}

extension IterableIterableExtension<E> on Iterable<Iterable<E>> {
  List<List<E>> T() {
    assert(map((es) => es.length).every((e) => e == first.length));

    List<List<E>> result = [];
    for (int i = 0; i < first.length; i++) {
      result.add(map((e) => e.elementAt(i)).toList());
    }
    return result;
  }

  Iterable<E> flatten() {
    return reduce((a, b) => a.toList() + b.toList());
  }
}
