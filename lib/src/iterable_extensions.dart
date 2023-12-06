extension IterableExtension<E> on Iterable<E> {
  /// Returns all unique elements paired with the number of occurences they have
  /// in this [Iterable].
  Iterable<(E, int)> counts() {
    final Map<E, int> counts = {};
    final Iterator elementIterator = iterator;
    while (elementIterator.moveNext()) {
      final E element = elementIterator.current;
      final int? count = counts[element];
      counts[element] = count == null ? 1 : count + 1;
    }

    return counts.entries
        .map((MapEntry<E, int> entry) => (entry.key, entry.value));
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
}

extension IterableIterableExtension<E> on Iterable<Iterable<E>> {
  Iterable<Iterable<E>> get T sync* {
    assert(map((es) => es.length).every((e) => e == first.length));

    for (var i = 0; i < first.length; i++) {
      yield map((e) => e.elementAt(i));
    }
  }
}
