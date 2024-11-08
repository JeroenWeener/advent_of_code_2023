extension RecordExtension<T1, T2> on (T1, T2) {
  (T2, T1) swap() {
    return ($2, $1);
  }
}

extension NumRecordExtension<T extends num> on (T, T) {
  (T, T) operator *(T scalar) {
    return ($1 * scalar as T, $2 * scalar as T);
  }
}

extension RecordIterableExtension<T1, T2> on Iterable<(T1, T2)> {
  Map<T1, T2> asMap() =>
      Map.fromEntries(map(((T1, T2) e) => MapEntry(e.$1, e.$2)));
}

extension DoubleStringRecordExtension on (String, String) {
  (String, String) sort() {
    if ($1.compareTo($2) < 0) {
      return this;
    }
    return ($2, $1);
  }
}

extension DoubleIntRecordExtension on (int, int) {
  (int, int) operator +((int, int) other) {
    return ($1 + other.$1, $2 + other.$2);
  }

  (int, int) operator -((int, int) other) {
    return ($1 - other.$1, $2 - other.$2);
  }

  (int, int) operator %(int modulo) {
    return ($1 % modulo, $2 % modulo);
  }

  bool operator <((int, int) other) {
    return $1 < other.$1 || $1 == other.$1 && $2 < other.$2;
  }
}

extension TripleIntRecordExtension on (int, int, int) {
  (int, int, int) operator +((int, int, int) other) {
    return ($1 + other.$1, $2 + other.$2, $3 + other.$3);
  }

  (int, int, int) operator -((int, int, int) other) {
    return ($1 - other.$1, $2 - other.$2, $3 - other.$3);
  }
}
