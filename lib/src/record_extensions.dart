extension RecordExtension<T1, T2> on (T1, T2) {
  (T2, T1) swap() {
    return ($2, $1);
  }
}

extension RecordIterableExtension<T1, T2> on Iterable<(T1, T2)> {
  Map<T1, T2> asMap() =>
      Map.fromEntries(map(((T1, T2) e) => MapEntry(e.$1, e.$2)));
}
