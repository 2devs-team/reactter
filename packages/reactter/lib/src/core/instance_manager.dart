part of 'core.dart';

/// A mixin-class that adds instances management features
/// to classes that use it.
///
/// It allows registering, unregistering, getting, creating,
/// and deleting instances of a certain type.
///
/// It also provides methods to check if an instance exists
/// and to get the instance of a certain type with a given ID.
///
/// It stores instances and their builders, and
/// emits lifecycle events when instances are registered, unregistered,
/// initialized, and destroyed.
@internal
abstract class InstanceManager {
  Logger get logger;
  EventManager get eventManager;

  /// It stores the instances registered.
  final _instanceRegisters = HashSet<InstanceRegister>();

  /// It stores the instances and its registers for quick access.
  final _instances = HashMap<Object, InstanceRegister>();

  /// {@template register}
  /// Register a [builder] function
  /// for creating a new instance of [T] with an [id] optional.
  /// {@endtemplate}
  ///
  /// Use [mode] parameter for defining how to manage the instance.
  ///
  /// Returns `true` when instance has been registered.
  bool register<T extends Object?>(
    InstanceBuilder<T> builder, {
    String? id,
    InstanceManageMode mode = InstanceManageMode.builder,
  }) {
    var instanceRegister = _getInstanceRegister<T?>(id);

    if (instanceRegister != null) {
      logger.log(
        'The "$instanceRegister" builder already registered as `$mode`.',
      );
      return false;
    }

    instanceRegister = InstanceRegister<T>(
      builder,
      id: id,
      mode: mode,
    );

    _instanceRegisters.add(instanceRegister);

    eventManager.emit(instanceRegister, Lifecycle.registered);
    logger.log(
      'The "$instanceRegister" builder has been registered as `$mode`.',
    );
    return true;
  }

  /// {@template lazy_builder}
  /// Register a [builder] function for creating a new instance
  /// of [T] with an [id] optional as [InstanceManageMode.builder].
  /// {@endtemplate}
  ///
  /// Returns `true` when instance has been registered.
  ///
  /// {@macro builder}
  ///
  /// This method is equivalent to calling:
  ///
  /// ```dart
  /// Reactter.register<T>(
  ///   builder,
  ///   id: id,
  ///   mode: InstanceManageMode.builder,
  /// );
  bool lazyBuilder<T extends Object?>(
    InstanceBuilder<T> builder, {
    String? id,
  }) {
    return register<T>(
      builder,
      id: id,
      mode: InstanceManageMode.builder,
    );
  }

  /// {@template lazy_factory}
  /// Register a [builder] function for creating a new instance
  /// of [T] with an [id] optional as [InstanceManageMode.factory].
  /// {@endtemplate}
  ///
  /// Returns `true` when instance has been registered.
  ///
  /// {@macro factory}
  ///
  /// This method is equivalent to calling:
  ///
  /// ```dart
  /// Reactter.register<T>(
  ///   builder,
  ///   id: id,
  ///   mode: InstanceManageMode.factory,
  /// );
  bool lazyFactory<T extends Object?>(
    InstanceBuilder<T> builder, {
    String? id,
  }) {
    return register<T>(
      builder,
      id: id,
      mode: InstanceManageMode.factory,
    );
  }

  /// {@template lazy_singleton}
  /// Register a [builder] function for creating a new instance
  /// of [T] with an [id] optional as [InstanceManageMode.singleton].
  /// {@endtemplate}
  ///
  /// Returns `true` when instance has been registered.
  ///
  /// {@macro singleton}
  ///
  /// This method is equivalent to calling:
  ///
  /// ```dart
  /// Reactter.register<T>(
  ///   builder,
  ///   id: id,
  ///   mode: InstanceManageMode.singleton,
  /// );
  bool lazySingleton<T extends Object?>(
    InstanceBuilder<T> builder, {
    String? id,
  }) {
    return register<T>(
      builder,
      id: id,
      mode: InstanceManageMode.singleton,
    );
  }

  /// {@template create}
  /// Registers, creates and/or gets the instance of [T] with an [id] optional.
  /// {@endtemplate}
  ///
  /// Use [mode] parameter for defining how to manage the instance.
  ///
  /// {@template create_conditions}
  /// Under the following conditions:
  ///
  /// - if not found and hasn't registered it, registers, creates and returns it.
  /// - if not found and has registered it, creates and returns it.
  /// - if found it, returns it.
  /// - else return `null`.
  /// {@endtemplate}
  T? create<T extends Object?>(
    InstanceBuilder<T> builder, {
    String? id,
    Object? ref,
    InstanceManageMode mode = InstanceManageMode.builder,
  }) {
    register<T>(builder, id: id, mode: mode);

    return _getOrCreateIfNotExtist<T>(id, ref)?.instance;
  }

  /// {@template builder}
  /// Registers, creates and/or gets the instance of [T] type with an [id] optional
  /// as [InstanceManageMode.builder].
  /// {@endtemplate}
  ///
  /// {@macro create_conditions}
  ///
  /// {@macro builder}
  ///
  /// This method is equivalent to calling:
  ///
  /// ```dart
  /// Reactter.create<T>(
  ///   builder,
  ///   id: id,
  ///   ref: ref,
  ///   mode: InstanceManageMode.builder,
  /// );
  /// ```
  T? builder<T extends Object?>(
    InstanceBuilder<T> builder, {
    String? id,
    Object? ref,
  }) {
    return create<T>(
      builder,
      id: id,
      ref: ref,
      mode: InstanceManageMode.builder,
    );
  }

  /// {@template factory}
  /// Registers, creates and/or gets the instance of [T] type with an [id] optional
  /// as [InstanceManageMode.factory].
  /// {@endtemplate}
  ///
  /// {@macro create_conditions}
  ///
  /// {@macro factory}
  ///
  /// This method is equivalent to calling:
  ///
  /// ```dart
  /// Reactter.create<T>(
  ///   builder,
  ///   id: id,
  ///   ref: ref,
  ///   mode: InstanceManageMode.factory,
  /// );
  /// ```
  T? factory<T extends Object?>(
    InstanceBuilder<T> builder, {
    String? id,
    Object? ref,
  }) {
    return create<T>(
      builder,
      id: id,
      ref: ref,
      mode: InstanceManageMode.factory,
    );
  }

  /// {@template singleton}
  /// Registers, creates and/or gets the instance of [T] type with an [id] optional
  /// as [InstanceManageMode.singleton].
  /// {@endtemplate}
  ///
  /// {@macro create_conditions}
  ///
  /// {@macro singleton}
  ///
  /// This method is equivalent to calling:
  ///
  /// ```dart
  /// Reactter.create<T>(
  ///   builder,
  ///   id: id,
  ///   ref: ref,
  ///   mode: InstanceManageMode.singleton,
  /// );
  /// ```
  T? singleton<T extends Object?>(
    InstanceBuilder<T> builder, {
    String? id,
    Object? ref,
  }) {
    return create<T>(
      builder,
      id: id,
      ref: ref,
      mode: InstanceManageMode.singleton,
    );
  }

  /// {@template get}
  /// Creates and/or gets the instance of [T] with an [id] optional.
  /// {@endtemplate}
  ///
  /// {@template get_conditions}
  /// Under the following conditions:
  ///
  /// - if found it, returns it.
  /// - if not found and has registered it, creates and returns it.
  /// - else returns `null`.
  /// {@endtemplate}
  T? get<T extends Object?>([String? id, Object? ref]) {
    return _getOrCreateIfNotExtist<T>(id, ref)?.instance;
  }

  /// Deletes the instance from the store
  /// if it has been removed from all references
  /// and meets the conditions of instance type.
  ///
  /// Returns `true` when the instance has been deleted.
  bool delete<T extends Object?>([String? id, Object? ref]) {
    final instanceRegister = _getInstanceRegister<T>(id);

    if (instanceRegister?.instance == null) {
      final instanceRef = InstanceRef<T>(id);

      logger.log('The "$instanceRef" instance already deleted.');

      return false;
    }

    if (ref != null) {
      instanceRegister!.refs.remove(ref.hashCode);
    }

    if (instanceRegister!.refs.isNotEmpty) {
      return false;
    }

    switch (instanceRegister.mode) {
      case InstanceManageMode.builder:
        destroy<T>(id: id);
        return true;
      case InstanceManageMode.factory:
        _removeInstance<T>(instanceRegister);
        logger.log(
          'The "$instanceRegister" builder has been retained '
          'because it\'s `${InstanceManageMode.factory}`.',
        );
        return true;
      case InstanceManageMode.singleton:
        logger.log(
          'The "$instanceRegister" instance has been retained '
          'because it\'s `${InstanceManageMode.singleton}`.',
        );
    }

    return false;
  }

  /// Removes a builder function registed of [T] type with an [id] optional.
  ///
  /// Returns `true` when instance has been unregistered.
  bool unregister<T extends Object?>([String? id]) {
    final instanceRegister = _getInstanceRegister<T?>(id);
    final typeLabel =
        instanceRegister?.mode.label ?? InstanceManageMode.builder.label;

    if (instanceRegister == null) {
      final instanceRef = InstanceRef<T>(id);

      logger.log('The "$instanceRef" $typeLabel already deregistered.');

      return false;
    }

    if (instanceRegister._instance != null) {
      final idParam = id != null ? "id: '$id, '" : '';

      logger.log(
        'The "$T" builder couldn\'t deregister '
        'because the "$instanceRegister" instance is active.\n'
        'You should delete the instance before with:\n'
        '`Reactter.delete<$T>(${id ?? ''});` or \n'
        '`Reactter.destroy<$T>($idParam, onlyInstance: true);`\n',
        level: LogLevel.warning,
      );

      return false;
    }

    _instanceRegisters.remove(instanceRegister);

    eventManager.emit(instanceRegister, Lifecycle.unregistered);
    eventManager.offAll(instanceRegister);
    logger.log('The "$instanceRegister" $typeLabel has been deregistered.');

    return true;
  }

  /// Destroys the instance and builder of [T] type with an [id] optional.
  ///
  /// If [onlyInstance] is `true`, ignores to deresgisters the builder.
  ///
  /// Returns `true` if it was successfully.
  bool destroy<T extends Object?>({
    String? id,
    bool onlyInstance = false,
  }) {
    final instanceRegister = _getInstanceRegister<T>(id);

    if (instanceRegister?.instance == null && onlyInstance) {
      final instanceRef = InstanceRef<T>(id);

      logger.log('The "$instanceRef" instance already deleted.');

      return false;
    }

    if (instanceRegister != null) {
      instanceRegister.refs.clear();
      _removeInstance<T>(instanceRegister);
    }

    if (onlyInstance) return true;

    return unregister<T>(id);
  }

  /// {@template find}
  /// Gets the instance of [T] type with an [id] optional.
  /// {@endtemplate}
  ///
  /// If found it, returns it, else returns `null`.
  T? find<T extends Object?>([String? id]) {
    return _getInstanceRegister<T>(id)?.instance;
  }

  /// Valids if the instance of [T] type with [id] optional exists.
  bool exists<T extends Object?>([String? id]) {
    return _getInstanceRegister<T>(id)?.instance != null;
  }

  /// Checks if an instance is registered in Reactter.
  bool isRegistered(Object? instance) {
    return _instances[instance] != null;
  }

  /// Returns [InstanceManageMode] of instance parameter.
  InstanceManageMode? getInstanceManageMode(Object? instance) {
    return _instances[instance]?.mode;
  }

  /// Returns the hashCode reference at a specified index for a given type and
  /// optional ID.
  int? getHashCodeRefAt<T extends Object?>(int index, [String? id]) {
    final refs = _getInstanceRegister<T>(id)?.refs;

    if (refs == null || refs.length < index + 1) return null;

    return refs.elementAt(index);
  }

  /// Returns or creates a [InstanceRegister] and logs messages related
  /// to its creation or registration.
  InstanceRegister<T?>? _getOrCreateIfNotExtist<T>([
    String? id,
    Object? ref,
  ]) {
    final instanceRegister = _getInstanceRegister<T>(id);

    if (instanceRegister == null) {
      final instanceRef = InstanceRef<T>(id);
      final idParam = id != null ? ", id: '$id'" : '';

      logger.log(
        'The "$instanceRef" builder is not registered.\n'
        'You should register the instance build with: \n'
        '`Reactter.register<$T>(() => $T()$idParam);` or \n'
        '`Reactter.create<$T>(() => $T()$idParam);`.',
        level: LogLevel.warning,
      );

      return _getInstanceRegisterByInstanceRef<T>(instanceRef);
    }

    if (instanceRegister.instance != null) {
      logger.log('The "$instanceRegister" instance already created.');

      return instanceRegister;
    }

    BindingZone.autoBinding(() => _createInstance<T>(instanceRegister));

    if (ref != null) {
      instanceRegister.refs.add(ref.hashCode);
    }

    eventManager.emit(instanceRegister, Lifecycle.initialized);

    final instance = instanceRegister.instance;

    if (instance is LifecycleObserver) {
      instance.onInitialized();
    }

    logger.log('The "$instanceRegister" instance has been created.');

    return instanceRegister;
  }

  /// Creates an instance of a given type using a [InstanceRegister].
  T? _createInstance<T>(InstanceRegister<T?> instanceRegister) {
    instanceRegister._instance = instanceRegister.builder();

    if (instanceRegister._instance != null) {
      _instances[instanceRegister._instance!] = instanceRegister;
    }

    return instanceRegister._instance;
  }

  /// Removes an instance of a generic type from a [InstanceRegister].
  void _removeInstance<T>(InstanceRegister<T?> instanceRegister) {
    final log = 'The "$instanceRegister" instance has been deleted.';
    final instance = instanceRegister.instance;
    instanceRegister._instance = null;

    _instances.remove(instance);

    eventManager.emit(instance, Lifecycle.destroyed);
    eventManager.emit(instanceRegister, Lifecycle.destroyed);
    logger.log(log);

    if (instance is StateBase) instance.dispose();
  }

  /// Returns the [InstanceRef] associated with the given instance.
  /// If the instance is null or not found, returns null.
  InstanceRef<T>? _getInstanceRef<T extends Object?>(Object? instance) {
    return _instances[instance] as InstanceRef<T>?;
  }

  /// Returns an instance of [InstanceRegister] of [T] type with an [id] optional.
  InstanceRegister<T?>? _getInstanceRegister<T extends Object?>([String? id]) {
    final InstanceRef instanceRef = InstanceRef<T?>(id);
    return _instanceRegisters.lookup(instanceRef) as InstanceRegister<T?>?;
  }

  /// Returns an instance of [InstanceRegister] of [T] type with a given [instanceRef].
  InstanceRegister<T>? _getInstanceRegisterByInstanceRef<T extends Object?>(
    InstanceRef? instanceRef,
  ) {
    return _instanceRegisters.lookup(instanceRef) as InstanceRegister<T>?;
  }
}
