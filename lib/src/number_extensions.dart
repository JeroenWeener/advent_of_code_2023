import 'package:advent_of_code_2023/src/iterable_extensions.dart';

extension NumberExtension on int {
  int gcd(int other) {
    int a = this;
    while (other != 0) {
      int t = other;
      other = a % t;
      a = t;
    }
    return a;
  }

  int lcm(int other) {
    return this ~/ this.gcd(other) * other;
  }
}

extension IntegerListExtension on Iterable<int> {
  int gcd() {
    return reduce((a, b) => a.gcd(b));
  }

  int lcm() {
    return reduce((a, b) => a.lcm(b));
  }
}

extension NumberListExtension<E extends num> on Iterable<E> {
  /// Scales all elements in this with [factor].
  Iterable<num> operator *(int factor) => map((E e) => e * factor);

  /// Scales elements in this with elements in [other].
  Iterable<num> multiply(Iterable<num> other) {
    assert(other.length >= length, 'Not enough elements to multiply');
    return zip(other).map(((E, num) e) => e.$1 * e.$2);
  }

  /// Returns the lowest value in this.
  E min() => reduce((E a, E b) => a < b ? a : b);

  /// Returns the highest value in this.
  E max() => reduce((E a, E b) => a > b ? a : b);

  /// Returns the sum of the values in this.
  E sum() => length == 0 ? 0 as E : reduce((E a, E b) => a + b as E);

  /// Returns the product of the values in this.
  E product() => reduce((E a, E b) => (a * b) as E);

  /// Returns an [Iterable] emitting the differences between the values in this.
  ///
  /// **NOTE:** if this turns out to unexpectedly cause a bottleneck in the
  /// program, consider calling `.toList` on the result.
  ///
  /// If there is less than 2 elements, the resulting iterable will not emit
  /// anything.
  Iterable<E> diff() sync* {
    if (length < 2) return;

    final Iterator valueIterator = iterator;

    valueIterator.moveNext();
    E value = valueIterator.current;

    while (valueIterator.moveNext()) {
      final E current = valueIterator.current;
      yield current - value as E;
      value = current;
    }
  }

  /// Sames as [diff], but returns the differences as absolute values.
  Iterable<E> diffAbs() => diff().map((E e) => e.abs() as E);
}

Iterable<int> range(int end, {int start = 0}) sync* {
  for (int i = start; i < end; i++) {
    yield i;
  }
}
