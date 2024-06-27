part of 'core.dart';

/// A mixin-class that adds dependency injection features
/// to classes that use it.
///
/// It allows registering, unregistering, getting, creating,
/// and deleting dependencies of a certain type.
///
/// It also provides methods to check if a dependency exists
/// and to get the dependency of a certain type with a given ID.
///
/// It stores dependencies and their builders, and
/// emits lifecycle events when dependencies are registered, unregistered,
/// initialized, and destroyed.
@internal
abstract class DependencyInjection {
  Logger get logger;
  EventHandler get eventHandler;

  /// It stores the dependencies registered.
  final _dependencyRegisters = HashSet<DependencyRegister>();

  /// It stores the dependencies and its registers for quick access.
  final _instances = HashMap<Object, DependencyRegister>();

  /// {@template register}
  /// Register a [builder] function of the [T] dependency with/without [id].
  /// {@endtemplate}
  ///
  /// Use [mode] parameter for defining how to manage the dependency.
  ///
  /// Returns `true` when dependency has been registered.
  bool register<T extends Object?>(
    InstanceBuilder<T> builder, {
    String? id,
    DependencyMode mode = DependencyMode.builder,
  }) {
    var dependencyRegister = _getDependencyRegister<T?>(id);

    if (dependencyRegister != null) {
      logger.log(
        'The "$dependencyRegister" builder already registered as `$mode`.',
      );
      return false;
    }

    dependencyRegister = DependencyRegister<T>(
      builder,
      id: id,
      mode: mode,
    );

    _dependencyRegisters.add(dependencyRegister);

    eventHandler.emit(dependencyRegister, Lifecycle.registered);
    logger.log(
      'The "$dependencyRegister" builder has been registered as `$mode`.',
    );
    return true;
  }

  /// {@template lazy_builder}
  /// Register a [builder] function of the [T] dependency with/without [id]
  /// as [DependencyMode.builder].
  /// {@endtemplate}
  ///
  /// Returns `true` when dependency has been registered.
  ///
  /// This method is equivalent to calling:
  ///
  /// ```dart
  /// Reactter.register<T>(
  ///   builder,
  ///   id: id,
  ///   mode: DependencyMode.builder,
  /// );
  /// ```
  ///
  /// - [DependencyMode.builder]:
  /// {@macro dependency_mode.builder}
  bool lazyBuilder<T extends Object?>(
    InstanceBuilder<T> builder, {
    String? id,
  }) {
    return register<T>(
      builder,
      id: id,
      mode: DependencyMode.builder,
    );
  }

  /// {@template lazy_factory}
  /// Register a [builder] function of the [T] dependency with/without [id]
  /// as [DependencyMode.factory].
  /// {@endtemplate}
  ///
  /// Returns `true` when dependency has been registered.
  ///
  /// This method is equivalent to calling:
  ///
  /// ```dart
  /// Reactter.register<T>(
  ///   builder,
  ///   id: id,
  ///   mode: DependencyMode.factory,
  /// );
  /// ```
  ///
  /// - [DependencyMode.factory]:
  /// {@macro dependency_mode.factory}
  bool lazyFactory<T extends Object?>(
    InstanceBuilder<T> builder, {
    String? id,
  }) {
    return register<T>(
      builder,
      id: id,
      mode: DependencyMode.factory,
    );
  }

  /// {@template lazy_singleton}
  /// Register a [builder] function of the [T] dependency with/without [id]
  /// as [DependencyMode.singleton].
  /// {@endtemplate}
  ///
  /// Returns `true` when dependency has been registered.
  ///
  /// This method is equivalent to calling:
  ///
  /// ```dart
  /// Reactter.register<T>(
  ///   builder,
  ///   id: id,
  ///   mode: DependencyMode.singleton,
  /// );
  /// ```
  ///
  /// - [DependencyMode.sigleton]:
  /// {@macro dependency_mode.sigleton}
  bool lazySingleton<T extends Object?>(
    InstanceBuilder<T> builder, {
    String? id,
  }) {
    return register<T>(
      builder,
      id: id,
      mode: DependencyMode.singleton,
    );
  }

  /// {@template create}
  /// Register a [builder] function of the [T] dependency with/without [id]
  /// and creates the instance if it isn't already registered,
  /// else gets its instance only.
  /// {@endtemplate}
  ///
  /// Use [mode] parameter for defining how to manage the dependency.
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
    DependencyMode mode = DependencyMode.builder,
  }) {
    register<T>(builder, id: id, mode: mode);

    return _getOrCreateIfNotExtist<T>(id, ref)?.instance;
  }

  /// {@template builder}
  /// Register a [builder] function of the [T] dependency with/without [id]
  /// as [DependencyMode.builder]
  /// and creates the instance if it isn't already registered,
  /// else gets its instance only.
  ///
  /// {@endtemplate}
  ///
  /// {@macro create_conditions}
  ///
  /// This method is equivalent to calling:
  ///
  /// ```dart
  /// Reactter.create<T>(
  ///   builder,
  ///   id: id,
  ///   ref: ref,
  ///   mode: DependencyMode.builder,
  /// );
  /// ```
  ///
  /// - [DependencyMode.builder]:
  /// {@macro dependency_mode.builder}
  T? builder<T extends Object?>(
    InstanceBuilder<T> builder, {
    String? id,
    Object? ref,
  }) {
    return create<T>(
      builder,
      id: id,
      ref: ref,
      mode: DependencyMode.builder,
    );
  }

  /// {@template factory}
  /// Register a [builder] function of the [T] dependency with/without [id]
  /// as [DependencyMode.factory]
  /// and creates the instance if it isn't already registered,
  /// else gets its instance only.
  /// {@endtemplate}
  ///
  /// {@macro create_conditions}
  ///
  /// This method is equivalent to calling:
  ///
  /// ```dart
  /// Reactter.create<T>(
  ///   builder,
  ///   id: id,
  ///   ref: ref,
  ///   mode: DependencyMode.factory,
  /// );
  /// ```
  ///
  /// - [DependencyMode.factory]:
  /// {@macro dependency_mode.factory}
  T? factory<T extends Object?>(
    InstanceBuilder<T> builder, {
    String? id,
    Object? ref,
  }) {
    return create<T>(
      builder,
      id: id,
      ref: ref,
      mode: DependencyMode.factory,
    );
  }

  /// {@template singleton}
  /// Register a [builder] function of the [T] dependency with/without [id]
  /// as [DependencyMode.singleton]
  /// and creates the instance if it isn't already registered,
  /// else gets its instance only.
  /// {@endtemplate}
  ///
  /// {@macro create_conditions}
  ///
  /// This method is equivalent to calling:
  ///
  /// ```dart
  /// Reactter.create<T>(
  ///   builder,
  ///   id: id,
  ///   ref: ref,
  ///   mode: DependencyMode.singleton,
  /// );
  /// ```
  ///
  /// - [DependencyMode.sigleton]:
  /// {@macro dependency_mode.sigleton}
  T? singleton<T extends Object?>(
    InstanceBuilder<T> builder, {
    String? id,
    Object? ref,
  }) {
    return create<T>(
      builder,
      id: id,
      ref: ref,
      mode: DependencyMode.singleton,
    );
  }

  /// {@template get}
  /// Creates and/or gets the instance of the [T] dependency with/without [id].
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

  /// Deletes the dependency from the store
  /// if it has been removed from all references
  /// and meets the conditions of dependency type.
  ///
  /// Under the following conditions:
  ///
  /// - if the dependency is builder mode, destroys the instance and builder function.
  /// - if the dependency is factory mode, removes the instance only.
  /// - if the dependency is singleton mode, retains both instance and builder function.
  ///
  /// Returns `true` when the dependency has been deleted.
  bool delete<T extends Object?>([String? id, Object? ref]) {
    final dependencyRegister = _getDependencyRegister<T>(id);

    if (dependencyRegister?.instance == null) {
      final dependencyRef = DependencyRef<T>(id);

      logger.log('The "$dependencyRef" dependency already deleted.');

      return false;
    }

    if (ref != null) {
      dependencyRegister!.refs.remove(ref.hashCode);
    }

    if (dependencyRegister!.refs.isNotEmpty) {
      return false;
    }

    switch (dependencyRegister.mode) {
      case DependencyMode.builder:
        destroy<T>(id: id);
        return true;
      case DependencyMode.factory:
        _removeInstance<T>(dependencyRegister);
        logger.log(
          'The "$dependencyRegister" builder has been retained '
          'because it\'s `${DependencyMode.factory}`.',
        );
        return true;
      case DependencyMode.singleton:
        logger.log(
          'The "$dependencyRegister" dependency has been retained '
          'because it\'s `${DependencyMode.singleton}`.',
        );
    }

    return false;
  }

  /// Removes a builder function registed of [T] type with an [id] optional.
  ///
  /// Returns `true` when dependency has been unregistered.
  bool unregister<T extends Object?>([String? id]) {
    final dependencyRegister = _getDependencyRegister<T?>(id);
    final typeLabel =
        dependencyRegister?.mode.label ?? DependencyMode.builder.label;

    if (dependencyRegister == null) {
      final dependencyRef = DependencyRef<T>(id);

      logger.log('The "$dependencyRef" $typeLabel already deregistered.');

      return false;
    }

    if (dependencyRegister._instance != null) {
      final idParam = id != null ? "id: '$id, '" : '';

      logger.log(
        'The "$T" builder couldn\'t deregister '
        'because the "$dependencyRegister" dependency is active.\n'
        'You should delete the instance before with:\n'
        '`Reactter.delete<$T>(${id ?? ''});` or \n'
        '`Reactter.destroy<$T>($idParam, onlyInstance: true);`\n',
        level: LogLevel.warning,
      );

      return false;
    }

    _dependencyRegisters.remove(dependencyRegister);

    eventHandler.emit(dependencyRegister, Lifecycle.unregistered);
    eventHandler.offAll(dependencyRegister);
    logger.log('The "$dependencyRegister" $typeLabel has been deregistered.');

    return true;
  }

  /// Destroys the instance and builder function
  /// of the [T] dependency with/without [id].
  ///
  /// If [onlyInstance] is `true`, ignores to deregister the builder.
  ///
  /// Returns `true` if it was successfully.
  bool destroy<T extends Object?>({
    String? id,
    bool onlyInstance = false,
  }) {
    final dependencyRegister = _getDependencyRegister<T>(id);

    if (dependencyRegister?.instance == null && onlyInstance) {
      final dependencyRef = DependencyRef<T>(id);

      logger.log('The "$dependencyRef" instance already deleted.');

      return false;
    }

    if (dependencyRegister != null) {
      dependencyRegister.refs.clear();
      _removeInstance<T>(dependencyRegister);
    }

    if (onlyInstance) return true;

    return unregister<T>(id);
  }

  /// {@template find}
  /// Gets the instance of the [T] dependency with/without [id].
  /// {@endtemplate}
  ///
  /// If found it, returns it, else returns `null`.
  T? find<T extends Object?>([String? id]) {
    return _getDependencyRegister<T>(id)?.instance;
  }

  /// Checks if the instance of [T] dependency with/without [id] exists.
  bool exists<T extends Object?>([String? id]) {
    return _getDependencyRegister<T>(id)?.instance != null;
  }

  /// Checks if an instance is registered in Reactter.
  bool isRegistered(Object? instance) {
    return _instances[instance] != null;
  }

  /// Checks if the [T] dependency with/without [id] is registered in Reactter.
  bool hasRegister<T extends Object?>([String? id]) {
    final DependencyRef dependencyRef = DependencyRef<T?>(id);
    return _dependencyRegisters.lookup(dependencyRef) != null;
  }

  @Deprecated(
    'Use `getDependencyMode` instead. '
    'This feature was deprecated after v7.1.0.',
  )
  InstanceManageMode? getInstanceManageMode(Object? instance) {
    return _instances[instance]?.mode;
  }

  /// Returns [DependencyMode] of instance parameter.
  DependencyMode? getDependencyMode(Object? instance) {
    return _instances[instance]?.mode;
  }

  /// Returns the hashCode reference at a specified index for a given type and
  /// optional ID.
  int? getHashCodeRefAt<T extends Object?>(int index, [String? id]) {
    final refs = _getDependencyRegister<T>(id)?.refs;

    if (refs == null || refs.length < index + 1) return null;

    return refs.elementAt(index);
  }

  /// Returns or creates a [DependencyRegister] and logs messages related
  /// to its creation or registration.
  DependencyRegister<T?>? _getOrCreateIfNotExtist<T>([
    String? id,
    Object? ref,
  ]) {
    final instanceRegister = _getDependencyRegister<T>(id);

    if (instanceRegister == null) {
      final dependencyRef = DependencyRef<T>(id);
      final idParam = id != null ? ", id: '$id'" : '';

      logger.log(
        'The "$dependencyRef" builder is not registered.\n'
        'You should register the instance build with: \n'
        '`Reactter.register<$T>(() => $T()$idParam);` or \n'
        '`Reactter.create<$T>(() => $T()$idParam);`.',
        level: LogLevel.warning,
      );

      return _getDependencyRegisterByRef<T>(dependencyRef);
    }

    if (instanceRegister.instance != null) {
      logger.log('The "$instanceRegister" instance already created.');

      return instanceRegister;
    }

    BindingZone.autoBinding(() => _createInstance<T>(instanceRegister));

    if (ref != null) {
      instanceRegister.refs.add(ref.hashCode);
    }

    // TODO: Remove this line after v8.0.0
    eventHandler.emit(instanceRegister, Lifecycle.initialized);
    eventHandler.emit(instanceRegister, Lifecycle.created);

    logger.log('The "$instanceRegister" instance has been created.');

    return instanceRegister;
  }

  /// Creates an instance of a given type using a [DependencyRegister].
  T? _createInstance<T>(DependencyRegister<T?> instanceRegister) {
    instanceRegister.builder();

    if (instanceRegister._instance != null) {
      _instances[instanceRegister._instance!] = instanceRegister;
    }

    return instanceRegister._instance;
  }

  /// Removes an instance of a generic type from a [DependencyRegister].
  void _removeInstance<T>(DependencyRegister<T?> dependencyRegister) {
    final log = 'The "$dependencyRegister" instance has been deleted.';
    final instance = dependencyRegister.instance;
    dependencyRegister._instance = null;

    _instances.remove(instance);
    // TODO: Remove this line after v8.0.0
    eventHandler.emit(instance, Lifecycle.destroyed);
    eventHandler.emit(instance, Lifecycle.deleted);
    // TODO: Remove this line after v8.0.0
    eventHandler.emit(dependencyRegister, Lifecycle.destroyed);
    eventHandler.emit(dependencyRegister, Lifecycle.deleted);
    logger.log(log);

    if (instance is StateBase) instance.dispose();
  }

  /// Returns the [DependencyRef] associated with the given instance.
  /// If the instance is null or not found, returns null.
  DependencyRef<T>? _getDependencyRef<T extends Object?>(Object? instance) {
    return _instances[instance] as DependencyRef<T>?;
  }

  /// Returns the [DependencyRegister] of [T] type with an [id] optional.
  DependencyRegister<T?>? _getDependencyRegister<T extends Object?>(
      [String? id]) {
    final DependencyRef dependencyRef = DependencyRef<T?>(id);
    return _dependencyRegisters.lookup(dependencyRef)
        as DependencyRegister<T?>?;
  }

  /// Returns the [DependencyRegister] of [T] type with a given [dependencyRef].
  DependencyRegister<T>? _getDependencyRegisterByRef<T extends Object?>(
    DependencyRef? dependencyRef,
  ) {
    return _dependencyRegisters.lookup(dependencyRef) as DependencyRegister<T>?;
  }
}
