import 'iterable_extensions.dart';
import 'number_extensions.dart';

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

  Iterable<O> map<O>(O Function(String c) f) sync* {
    for (int i = 0; i < length; i++) {
      final String c = this[i];
      yield f(c);
    }
  }

  bool every(bool Function(String c) f) {
    return map((c) => f(c)).every((e) => e);
  }

  Iterable<String> where(bool Function(String c) f) {
    return map((c) => c).where((c) => f(c));
  }

  Iterable<T> expand<T>(Iterable<T> Function(String c) toElements) {
    return map((c) => toElements(c)).flatten();
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

  /// Extracts integers from this [String].
  ///
  /// **NOTE:** Parses '-' as part of the integer, treating it as a negative
  /// number. If this behavior is undesired, consider piping the result into
  /// `map((n) => n.abs())`.
  Iterable<int> extractInts() {
    return RegExp(r'-?\d+')
        .allMatches(this)
        .map((e) => e.group(0)!)
        .map(int.parse);
  }
}

extension StringIterableExtension on Iterable<String> {
  Iterable<Iterable<String>> T() sync* {
    assert(
      range(length).every((e) => elementAt(e).length == first.length),
    );

    for (int i = 0; i < first.length; i++) {
      yield map((e) => e[i]);
    }
  }
}
