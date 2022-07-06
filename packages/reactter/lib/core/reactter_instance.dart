part of '../core.dart';

class ReactterInstance<T> {
  final String? id;
  ContextBuilder<T?>? builder;
  T? instance;

  /// Stores the object from which it was instantiated
  HashSet<int> refs = HashSet<int>();

  ReactterInstance(this.id);
  ReactterInstance.withBuilder(this.id, this.builder);

  /// Is equal with [T] and [id]
  @override
  bool operator ==(Object other) =>
      other is ReactterInstance<T?> && other.id == id;

  @override
  int get hashCode => hashValues(T, id);

  @override
  String toString() {
    final type = T.toString().replaceAll(RegExp(r'\?'), '');
    final id = this.id != null ? "[id='${this.id}']" : "";
    final hashCode = instance != null ? "(${instance.hashCode})" : "";

    return '$type$id$hashCode"';
  }
}
