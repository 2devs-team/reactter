part of '../core.dart';

class ReactterInstance<T> {
  final String? id;
  ContextBuilder<T?>? _builder;

  T? _instance;
  T? get instance => _instance;

  /// Stores the object from which it was instantiated
  HashSet<int> refs = HashSet<int>();

  ReactterInstance([this.id, this._builder]);

  ReactterInstance? get stored => Reactter._instances[key];
  String get key => generateKey<T?>(id);

  @override
  String toString() {
    final type = T.toString().replaceAll(RegExp(r'\?'), '');
    final id = this.id != null ? "[id='${this.id}']" : "";
    final hashCode = instance != null ? "(${instance.hashCode})" : "";

    return '$type$id$hashCode';
  }

  static generateKey<T extends Object?>([String? id]) =>
      "${T.hashCode}${id != null ? '[$id]' : ''}";
}
