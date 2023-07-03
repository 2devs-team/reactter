part of '../framework.dart';

/// A singleton instance of [T]
class ReactterInstance<T> {
  final String? id;
  ContextBuilder<T?>? _builder;

  T? _instance;
  T? get instance => _instance;

  /// Stores the object from which it was instantiated
  HashSet<int> refs = HashSet<int>();

  ReactterInstance([this.id, this._builder]);

  /// A getter that returns the stored instance of [T].
  ReactterInstance? get stored => Reactter._instancesByKey[key];

  /// Generating a unique key for a given object [T] and optional `id`
  String get key => generateKey<T?>(id);

  @override
  String toString() {
    final type = T.toString().replaceAll(RegExp(r'\?'), '');
    final id = this.id != null ? "[id='${this.id}']" : "";
    final hashCode = instance != null ? "(${instance.hashCode})" : "";

    return '$type$id$hashCode';
  }

  /// It generates a unique key for a given object [T] and optional `id`
  static String generateKey<T extends Object?>([String? id]) {
    return "${T.hashCode}${id != null ? '[$id]' : ''}";
  }

  static String getInstanceKey(Object? instance) {
    if (instance is ReactterInstance) {
      return instance.stored?.key ?? instance.key;
    }

    return Reactter.find(instance)?.key ?? "${instance.hashCode}";
  }
}
