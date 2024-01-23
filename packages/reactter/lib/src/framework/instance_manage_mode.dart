part of 'framework.dart';

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
