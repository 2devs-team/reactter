part of '../core.dart';

class ReactterInstance<T> {
  final String? id;
  ContextBuilder<T?>? _builder;

  T? _instance;
  T? get instance => _instance;

  /// Stores the object from which it was instantiated
  HashSet<int> refs = HashSet<int>();

  // factory ReactterInstance([String? id]) {
  //   final reactterInstance = ReactterInstance<T>.symbol(id);

  //   final reactterInstanceFound =
  //       Reactter._instances.lookup(reactterInstance) as ReactterInstance<T>?;

  //   if (reactterInstanceFound != null) {
  //     return reactterInstanceFound;
  //   }

  //   Reactter._instances.add(reactterInstance);

  //   return reactterInstance;
  // }

  // ReactterInstance.symbol(this.id, [this._builder]);
  ReactterInstance([this.id, this._builder]);

  ReactterInstance? get stored => Reactter._instances[key];
  String get key => generateKey<T?>(id);

  /// Is equal with [T] and [id]
  @override
  bool operator ==(Object other) =>
      other is ReactterInstance<T?> && other.id == id;

  @override
  int get hashCode => Object.hash(T, id);

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
