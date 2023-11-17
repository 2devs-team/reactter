extension IterableExtensions<E> on Iterable<E> {
  /// Returns the first element or `null` if `this` is empty.
  E? get firstOrNull => isEmpty ? null : first;

  /// Returns the last element or `null` if `this` is empty.
  E? get lastOrNull => isEmpty ? null : last;

  E? elementAtOrNull(int index) {
    RangeError.checkNotNegative(index, "index");

    if (index >= length) return null;

    return elementAt(index);
  }
}
