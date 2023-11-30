import 'package:advent_of_code_2023/src/iterable_extensions.dart';

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
