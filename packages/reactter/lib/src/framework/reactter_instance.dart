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

/// A generic class that represents an instance of a Reactter object and
/// provides methods for generating unique keys and retrieving the stored instance.
class ReactterInstance<T> {
  final String? id;

  const ReactterInstance([this.id]);

  /// A getter that returns the instance of [T].
  T? get instance => fromStore<T>(this)?.instance;

  static ReactterInstance<T?>? fromStore<T extends Object?>(Object? instance) {
    if (instance == null) return null;

    if (instance is ReactterInstance<T?>) {
      return Reactter._reactterInstance.lookup(instance)
          as ReactterInstance<T?>?;
    }

    return Reactter._instances[instance] as ReactterInstance<T?>?;
  }

  @override
  String toString() {
    final type = T.toString().replaceAll(RegExp(r'\?'), '');
    final id = this.id != null ? "[id='${this.id}']" : "";

    return '$type$id';
  }

  int _getTypeHashCode<TT extends T?>() => TT.hashCode;

  @override
  int get hashCode => _getTypeHashCode() ^ id.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is ReactterInstance<T?>) {
      return other.id == this.id;
    }

    return identical(other, this.instance);
  }
}

class _ReactterInstanceBuilder<T> extends ReactterInstance<T?> {
  final InstanceBuilder<T?> builder;

  /// It's used to store the mode of managing an instance.
  final InstanceManageMode mode;

  /// Stores the refs where the instance was created.
  final refs = HashSet<int>();

  T? _instance;
  T? get instance => _instance;

  static _ReactterInstanceBuilder<T>? fromStore<T extends Object?>(
    Object? instance,
  ) =>
      Reactter._reactterInstance.lookup(instance)
          as _ReactterInstanceBuilder<T>?;

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

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is _ReactterInstanceBuilder<T>) {
      return other.id == this.id;
    }

    if (other is ReactterInstance<T?>) {
      return other.id == this.id;
    }

    return identical(other, this.instance);
  }
}
