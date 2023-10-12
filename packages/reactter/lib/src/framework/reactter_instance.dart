part of '../framework.dart';

/// Represents different ways of creating and managing instances.
enum InstanceType {
  /// {@template builder}
  /// It's the type of instance that will be registered and instantiated
  /// unless it has already done so.
  /// When the dependency tree no longer needs it,
  /// it is completely deleted,
  /// including deregistration (deleting the builder function).
  ///
  /// It uses less RAM than [factory] and [singleton],
  /// but it consumes more CPU than the other types.
  /// {@endtemplate}
  builder,

  /// {@template factory}
  /// It's the type of instance that will be registered once only
  /// and instantiated unless it has already done so.
  /// When the dependency tree no longer needs it,
  /// the instance is deleted and the builder function is kept in the register.
  ///
  /// It uses more RAM than [builder] but not more than [singleton],
  /// and consumes more CPU than [singleton] but not more than [builder].
  /// {@endtemplate}
  factory,

  /// {@template singleton}
  /// It's the type of instance that will be registered
  /// and instantiated once only.
  /// This type preserves the instance and its states,
  /// even if the dependency tree stops using it.
  ///
  /// Use `Reactter.unregister` if you want to force destroy
  /// the instance and its register
  /// or use `Reactter.delete` for deleting the instance only.
  ///
  /// It consumes less CPU than [builder] and [factory],
  /// but uses more RAM than the other types.
  /// {@endtemplate}
  singleton,
}

/// A singleton instance of [T]
class ReactterInstance<T> {
  final String? id;

  ReactterInstance([this.id]);

  /// A getter that returns the instance of [T].
  T? get instance => _stored?.instance;

  /// Generating a unique key for a given object [T] and optional `id`
  String get _key => generateKey<T?>(id);

  /// A getter that returns the stored instance of [T].
  _ReactterInstanceBuilder<T?>? get _stored =>
      Reactter._instancesByKey[_key] as _ReactterInstanceBuilder<T?>?;

  @override
  String toString() {
    final type = T.toString().replaceAll(RegExp(r'\?'), '');
    final id = this.id != null ? "[id='${this.id}']" : "";

    return '$type$id';
  }

  /// It generates a unique key for a given object [T] and optional `id`
  static String generateKey<T>([String? id]) {
    return "${T.hashCode}${id != null ? '[$id]' : ''}";
  }

  static String _getInstanceKey(Object? instance) {
    if (instance is ReactterInstance) {
      return instance._stored?._key ?? instance._key;
    }

    return Reactter._instancesCreated[instance]?._key ?? "${instance.hashCode}";
  }
}

class _ReactterInstanceBuilder<T> extends ReactterInstance<T> {
  InstanceBuilder<T?> builder;

  /// It's used to store the type of instance that will be created and managed by the framework.
  /// The `InstanceType` enum defines three possible values: `factory`, `lazy`, and `singleton`. By
  /// assigning one of these values to the `type` variable, the framework can determine how the instance
  /// should be created and managed.
  InstanceType type;

  /// Stores the refs where the instance was created.
  final refs = HashSet<int>();

  T? _instance;
  T? get instance => _instance;

  _ReactterInstanceBuilder(
    this.builder, {
    String? id,
    this.type = InstanceType.builder,
  }) : super(id);

  @override
  String toString() {
    final hashCode = instance != null ? "(${instance.hashCode})" : "";

    return '${super.toString()}$hashCode';
  }
}
