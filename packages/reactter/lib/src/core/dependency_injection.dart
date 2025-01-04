part of '../internals.dart';

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
abstract class DependencyInjection implements IContext {
  /// It stores the dependencies registered.
  final _dependencyRegisters = HashSet<DependencyRegister>();

  /// It stores the dependencies and its registers for quick access.
  final _instances = HashMap<Object, DependencyRegister>();

  /// {@template reactter.register}
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
      _notifyDependencyFailed(
        dependencyRegister,
        DependencyFail.alreadyRegistered,
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
    return true;
  }

  /// {@template reactter.lazy_builder}
  /// Register a [builder] function of the [T] dependency with/without [id]
  /// as [DependencyMode.builder].
  /// {@endtemplate}
  ///
  /// Returns `true` when dependency has been registered.
  ///
  /// This method is equivalent to calling:
  ///
  /// ```dart
  /// Rt.register<T>(
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

  /// {@template reactter.lazy_factory}
  /// Register a [builder] function of the [T] dependency with/without [id]
  /// as [DependencyMode.factory].
  /// {@endtemplate}
  ///
  /// Returns `true` when dependency has been registered.
  ///
  /// This method is equivalent to calling:
  ///
  /// ```dart
  /// Rt.register<T>(
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

  /// {@template reactter.lazy_singleton}
  /// Register a [builder] function of the [T] dependency with/without [id]
  /// as [DependencyMode.singleton].
  /// {@endtemplate}
  ///
  /// Returns `true` when dependency has been registered.
  ///
  /// This method is equivalent to calling:
  ///
  /// ```dart
  /// Rt.register<T>(
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

  /// {@template reactter.create}
  /// Register a [builder] function of the [T] dependency with/without [id]
  /// and creates the instance if it isn't already registered,
  /// else gets its instance only.
  /// {@endtemplate}
  ///
  /// Use [mode] parameter for defining how to manage the dependency.
  ///
  /// {@template reactter.create_conditions}
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

  /// {@template reactter.builder}
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
  /// Rt.create<T>(
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

  /// {@template reactter.factory}
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
  /// Rt.create<T>(
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

  /// {@template reactter.singleton}
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
  /// Rt.create<T>(
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

  /// {@template reactter.get}
  /// Creates and/or gets the instance of the [T] dependency with/without [id].
  /// {@endtemplate}
  ///
  /// {@template reactter.get_conditions}
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

      _notifyDependencyFailed(
        dependencyRef,
        DependencyFail.alreadyDeleted,
      );

      return false;
    }

    if (ref != null) {
      dependencyRegister!.refs.remove(ref);
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

        _notifyDependencyFailed(
          dependencyRegister,
          DependencyFail.builderRetainedAsFactory,
        );

        return true;
      case DependencyMode.singleton:
        _notifyDependencyFailed(
          dependencyRegister,
          DependencyFail.dependencyRetainedAsSingleton,
        );
    }

    return false;
  }

  /// Removes a builder function registed of [T] type with an [id] optional.
  ///
  /// Returns `true` when dependency has been unregistered.
  bool unregister<T extends Object?>([String? id]) {
    final dependencyRegister = _getDependencyRegister<T?>(id);

    if (dependencyRegister == null) {
      final dependencyRef = DependencyRef<T>(id);

      _notifyDependencyFailed(
        dependencyRef,
        DependencyFail.alreadyUnregistered,
      );

      return false;
    }

    if (dependencyRegister._instance != null) {
      _notifyDependencyFailed(
        dependencyRegister,
        DependencyFail.cannotUnregisterActiveInstance,
      );

      return false;
    }

    _dependencyRegisters.remove(dependencyRegister);

    eventHandler.emit(dependencyRegister, Lifecycle.unregistered);
    eventHandler.offAll(dependencyRegister);

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

      _notifyDependencyFailed(
        dependencyRef,
        DependencyFail.alreadyDeleted,
      );

      return false;
    }

    if (dependencyRegister != null) {
      dependencyRegister.refs.clear();
      _removeInstance<T>(dependencyRegister);
    }

    if (onlyInstance) return true;

    return unregister<T>(id);
  }

  /// {@template reactter.find}
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

  /// Checks if the [instance] is active in Reactter.
  bool isActive(Object? instance) {
    return _instances[instance] != null;
  }

  /// Checks if the [T] dependency with/without [id] is registered in Reactter.
  bool hasRegister<T extends Object?>([String? id]) {
    final DependencyRef dependencyRef = DependencyRef<T?>(id);
    return _dependencyRegisters.lookup(dependencyRef) != null;
  }

  /// Returns [DependencyMode] of instance parameter.
  DependencyMode? getDependencyMode(Object? instance) {
    return _instances[instance]?.mode;
  }

  /// Returns the reference at a specified index for a given type and
  /// optional ID.
  Object? getRefAt<T extends Object?>(int index, [String? id]) {
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

      _notifyDependencyFailed(
        dependencyRef,
        DependencyFail.missingInstanceBuilder,
      );

      return getDependencyRegisterByRef<T>(dependencyRef);
    }

    if (ref != null) {
      instanceRegister.refs.add(ref);
    }

    if (instanceRegister.instance != null) {
      _notifyDependencyFailed(
        instanceRegister,
        DependencyFail.alreadyCreated,
      );

      return instanceRegister;
    }

    BindingZone.autoBinding(() => _createInstance<T>(instanceRegister));

    eventHandler.emit(
      instanceRegister,
      Lifecycle.created,
      instanceRegister.instance,
    );

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
    final instance = dependencyRegister.instance;

    dependencyRegister._instance = null;

    _instances.remove(instance);
    eventHandler.emit(instance, Lifecycle.deleted, instance);
    eventHandler.emit(dependencyRegister, Lifecycle.deleted, instance);

    if (instance is IState && !instance.isDisposed) {
      instance.dispose();
    }
  }

  /// Returns the [DependencyRef] associated with the given instance.
  /// If the instance is null or not found, returns null.
  DependencyRef<T>? getDependencyRef<T extends Object?>(Object? instance) {
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
  DependencyRegister<T?>? getDependencyRegisterByRef<T extends Object?>(
    DependencyRef<T?>? dependencyRef,
  ) {
    if (dependencyRef == null) return null;

    return _dependencyRegisters.lookup(dependencyRef as dynamic)
        as DependencyRegister<T?>?;
  }

  void _notifyDependencyFailed(
    DependencyRef dependencyRef,
    DependencyFail fail,
  ) {
    for (final observer
        in RtDependencyObserver._observers.toList(growable: false)) {
      observer.onDependencyFailed(dependencyRef, fail);
    }
  }
}
