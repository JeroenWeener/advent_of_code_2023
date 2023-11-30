extension IterableDebugExtensions<E> on Iterable<E> {
  /// Prints elements emitted by the [Iterable] and re-emits them.
  ///
  /// Optionally, a function [f] can be passed that dictates what should be
  /// printed exactly.
  Iterable<E> mapPrint([Function(E element)? f]) {
    return map((E e) {
      print(f == null ? e : f(e));
      return e;
    });
  }

  /// Prints the length of the [Iterable] and re-emits it.
  Iterable<E> passPrint() {
    print(length);
    return this;
  }
}
