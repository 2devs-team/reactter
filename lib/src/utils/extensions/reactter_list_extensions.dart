library reactter;

extension ListExtension<T> on List<T> {
  /// Transfrom a [List<R>] to [List<T>].
  ///
  /// Where [fn] is a Function that returns [T].
  List<R> to<R>(R Function(T) fn) => map((item) => fn(item)).toList();

  /// Returns `true` if the predicate returns true.
  T? find(bool Function(T) comparison) {
    for (T element in this) {
      if (comparison(element)) return element;
    }

    return null;
  }

  /// Iterate a [List<T>].
  ///
  /// Where [fn] is a Function that returns [T], but you have access to the [index] too.
  List<T>? mapIndexed(T Function(T e, int i) fn) {
    var i = 0;
    final result = map((e) => fn(e, i++)).toList();
    return result;
  }
}
