part of '../framework.dart';

/// Represents different ways for managing instances.
enum InstanceManageMode {
  /// {@template builder}
  /// It's a ways to manage an instance, which registers a builder function
  /// and creates the instance, unless it has already done so.
  ///
  /// When the dependency tree no longer needs it, it is completely deleted,
  /// including deregistration (deleting the builder function).
  ///
  /// It uses less RAM than [factory] and [singleton],
  /// but it consumes more CPU than the other modes.
  /// {@endtemplate}
  builder,

  /// {@template factory}
  /// It's a ways to manage an instance, which registers
  /// a builder function only once and creates the instance if not already done.
  ///
  /// When the dependency tree no longer needs it,
  /// the instance is deleted and the builder function is kept in the register.
  ///
  /// It uses more RAM than [builder] but not more than [singleton],
  /// and consumes more CPU than [singleton] but not more than [builder].
  /// {@endtemplate}
  factory,

  /// {@template singleton}
  /// It's a ways to manage a instance, which registers a builder function
  /// and creates the instance only once.
  ///
  /// This mode preserves the instance and its states,
  /// even if the dependency tree stops using it.
  ///
  /// Use `Reactter.destroy` if you want to force destroy
  /// the instance and its register.
  ///
  /// It consumes less CPU than [builder] and [factory],
  /// but uses more RAM than the other modes.
  /// {@endtemplate}
  singleton,
}

extension InstanceManageModeExt on InstanceManageMode {
  String get label => '$this'.split('.').last;
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

  /// It's used to store the mode of managing an instance.
  InstanceManageMode mode;

  /// Stores the refs where the instance was created.
  final refs = HashSet<int>();

  T? _instance;
  T? get instance => _instance;

  _ReactterInstanceBuilder(
    this.builder, {
    String? id,
    this.mode = InstanceManageMode.builder,
  }) : super(id);

  @override
  String toString() {
    final hashCode = instance != null ? "(${instance.hashCode})" : "";

    return '${super.toString()}$hashCode';
  }
}
