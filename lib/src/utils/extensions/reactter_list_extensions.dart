library reactter;

extension ListExtension<T> on List<T> {
  List<R> to<R>(R Function(T) fn) => map((item) => fn(item)).toList();

  T? find(bool Function(T) comparison) {
    for (T element in this) {
      if (comparison(element)) return element;
    }

    return null;
  }

  List<T>? mapIndexed<E>(T Function(T e, int i) fn) {
    var i = 0;
    final result = map((e) => fn(e, i++)).toList();
    return result;
  }
}
