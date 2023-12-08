extension StringExtension on String {
  /// Returns all unique characters paired with the number of occurences they
  /// have in this [String].
  Iterable<(String, int)> counts() {
    return countsMap().entries.map(
          (MapEntry entry) => (
            entry.key,
            entry.value,
          ),
        );
  }

  Map<String, int> countsMap() {
    final Map<String, int> counts = {};
    for (int i = 0; i < length; i++) {
      final String c = this[i];
      final int? count = counts[c];
      counts[c] = (count ?? 0) + 1;
    }

    return Map.fromEntries(counts.entries);
  }

  /// Convenience getter for accessing the first character in a [String].
  String get first => this[0];

  /// Convenience getter for accessing the second character in a [String].
  String get second => this[1];

  /// Convenience getter for accessing the last character in a [String].
  String get last => this[length - 1];

  /// Convenience getter for accessing the middle character in a [String].
  ///
  /// Asserts whether the string has an uneven number of characters.
  String get middle {
    assert(
      length % 2 == 1,
      'Cannot get middle character of string with an even number of characters',
    );
    return this[length ~/ 2];
  }

  String take(int n) {
    return substring(0, n);
  }

  Iterable<String> regexAllMatches(String re) {
    return RegExp(re).allMatches(this).map((e) => e.group(0)!);
  }

  String? regexFirstMatch(String re) {
    return RegExp(re).firstMatch(this)?.group(0);
  }

  bool regexHasMatch(String re) {
    return RegExp(re).hasMatch(this);
  }
}
