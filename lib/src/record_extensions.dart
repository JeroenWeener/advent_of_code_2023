extension RecordExtension<T1, T2> on (T1, T2) {
  (T2, T1) swap() {
    return ($2, $1);
  }
}
