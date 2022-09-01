// ignore_for_file: constant_identifier_names, avoid_print
part of '../core.dart';

/// A instances manager
class ReactterInstanceManager {
  static final _reactterInstanceManager = ReactterInstanceManager._();

  factory ReactterInstanceManager() {
    return _reactterInstanceManager;
  }

  ReactterInstanceManager._();

  // All ReactterInstanceManager´s instances
  HashSet<ReactterInstance> instances = HashSet<ReactterInstance>();

  /// Registers a [builder] function into to [instances]
  /// to allows to create the instance with [get].
  ///
  /// Returns `true` when instance has been registered.
  bool register<T extends Object?>({
    required ContextBuilder<T> builder,
    String? id,
  }) {
    final instance = ReactterInstance<T?>.withBuilder(id, builder);

    if (_reactterInstanceManager.instances.contains(instance)) {
      Reactter.log('Instance "$instance" already registered.');
      return false;
    }

    _reactterInstanceManager.instances.add(instance);
    UseEvent<T>(id).emit(Lifecycle.registered);
    Reactter.log('Instance "$instance" has been registered.');
    return true;
  }

  /// Removes a builder function from [instances].
  ///
  /// Returns `true` when instance has been unregistered.
  bool unregister<T extends Object>([String? id]) {
    final instance = ReactterInstance<T?>(id);
    final instanceFound = _reactterInstanceManager.instances.lookup(instance);

    if (instanceFound == null) {
      Reactter.log('Instance "$instance" don\'t exist.');
      return false;
    }

    _removeInstance<T>(instanceFound);

    _reactterInstanceManager.instances.remove(instance);

    UseEvent<T>(id)
      ..emit(Lifecycle.unregistered)
      ..dispose();

    Reactter.log('Instance "$instance" has been unregistered.');
    return true;
  }

  /// Gets the instance of [T] with or without [id] given.
  ///
  /// If not found and has registered, create a new instance.
  ///
  /// If found it, returns it, else returns `null`.
  T? get<T extends Object?>([String? id]) {
    return _getAndCreateIfNotExtist<T>(id)?.instance;
  }

  /// Registers, creates and gets the instance of [T] with or without [id] given.
  ///
  /// Returns it, else return `null`.
  T? create<T extends Object?>({
    required ContextBuilder<T> builder,
    String? id,
    Object? ref,
  }) {
    register<T>(builder: builder, id: id);

    final reactterInstance = _getAndCreateIfNotExtist<T>(id);

    if (ref != null) {
      reactterInstance?.refs.add(ref.hashCode);
    }

    return reactterInstance?.instance;
  }

  /// Deletes the instance from [instances] but keep the [builder] function.
  ///
  /// Returns `true` when the instance has been deleted.
  bool delete<T extends Object?>([String? id, Object? ref]) {
    final instanceToFind = ReactterInstance<T?>(id);
    final instanceFound =
        _reactterInstanceManager.instances.lookup(instanceToFind);

    if (instanceFound == null || instanceFound.instance == null) {
      Reactter.log(
        'Instance "$instanceToFind" already deleted.',
        isError: true,
      );

      return false;
    }

    if (ref != null) {
      instanceFound.refs.remove(ref.hashCode);
    }

    if (instanceFound.refs.isNotEmpty) {
      return false;
    }

    _removeInstance<T>(instanceFound);

    UseEvent<T>(id).dispose();

    return true;
  }

  /// Get the [ReactterInstance] of [instance] given.
  ///
  /// If found it, returns it, else returns `null`.
  ReactterInstance? find(Object? instance) {
    try {
      return _reactterInstanceManager.instances
          .firstWhere((element) => element.instance == instance);
    } catch (e) {
      return null;
    }
  }

  /// Valids if the instance of [T] with or without [id] given exists.
  bool exists<T extends Object?>([String? id]) {
    final instanceToFind = ReactterInstance<T?>(id);

    return _reactterInstanceManager.instances
            .lookup(instanceToFind)
            ?.instance !=
        null;
  }

  ReactterInstance<T?>? _getAndCreateIfNotExtist<T extends Object?>(
      [String? id]) {
    final instanceToFind = ReactterInstance<T?>(id);
    final instanceFound = _reactterInstanceManager.instances
        .lookup(instanceToFind) as ReactterInstance<T?>?;

    if (instanceFound == null) {
      Reactter.log(
        'Builder for instance "$instanceToFind" is not registered.\n' +
            'You should register instance with ' +
            '"Reactter.register<$T>(builder:() => $T())" or ' +
            '"Reactter.create<$T>(builder: () => $T())".',
        isError: true,
      );

      return instanceFound;
    }

    if (instanceFound.instance != null) {
      Reactter.log('Instance "$instanceFound" already created.');

      return instanceFound;
    }

    instanceFound.instance = instanceFound.builder?.call();
    UseEvent<T>(instanceFound.id).emit(Lifecycle.initialized);
    Reactter.log('Instance "$instanceFound" has been created.');

    return instanceFound;
  }

  void _removeInstance<T>(ReactterInstance reactterInstance) {
    final log = 'Instance "$reactterInstance" has been deleted.';

    if (reactterInstance.instance is ReactterContext) {
      (reactterInstance.instance as ReactterContext).dispose();
    }

    reactterInstance.instance = null;

    UseEvent<T>(reactterInstance.id).emit(Lifecycle.destroyed);

    Reactter.log(log);
  }
}
