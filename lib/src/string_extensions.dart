import 'iterable_extensions.dart';
import 'number_extensions.dart';

extension StringExtension on String {
  /// Returns all unique characters paired with the number of occurences they
  /// have in this [String].
  List<(String, int)> counts() {
    return countsMap()
        .entries
        .map(
          (MapEntry entry) => (
            entry.key,
            entry.value,
          ) as (String, int),
        )
        .toList();
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

  String takeWhile(bool Function(String c) test) {
    return split('').takeWhile(test).join();
  }

  String skip(int n) {
    return substring(n);
  }

  String skipWhile(bool Function(String c) test) {
    return split('').skipWhile(test).join();
  }

  Iterable<O> map<O>(O Function(String c) f) sync* {
    for (int i = 0; i < length; i++) {
      final String c = this[i];
      yield f(c);
    }
  }

  Iterable<(int, String)> get indexed {
    return range(length).zip(split(''));
  }

  bool every(bool Function(String c) f) {
    return split('').every(f);
  }

  Iterable<String> where(bool Function(String c) f) {
    return split('').where((c) => f(c));
  }

  Iterable<T> expand<T>(Iterable<T> Function(String c) f) {
    return map(f).flatten();
  }

  Iterable<String> repeat(int n) {
    assert(n >= 0);

    if (n == 0) {
      return [];
    }
    return <String>[this].followedBy(repeat(n - 1));
  }

  String get reversed => codeUnits.reversed.map(String.fromCharCode).join('');

  Iterable<List<String>> sw(int windowSize) => slidingWindow(windowSize);

  Iterable<List<String>> slidingWindow(int windowSize) {
    return split('').slidingWindow(windowSize);
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
  List<int> extractInts() {
    return RegExp(r'-?\d+')
        .allMatches(this)
        .map((e) => e.group(0)!)
        .map(int.parse)
        .toList();
  }
}

extension StringIterableExtension on Iterable<String> {
  List<String> T() {
    assert(
      range(length).every((e) => elementAt(e).length == first.length),
    );

    List<String> result = [];
    for (int i = 0; i < first.length; i++) {
      result.add(map((e) => e[i]).join(''));
    }
    return result;
  }
}
