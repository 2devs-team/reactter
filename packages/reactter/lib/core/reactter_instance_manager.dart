// ignore_for_file: constant_identifier_names, avoid_print
part of '../core.dart';

/// A mixin-class to provides the ability to manager instances.
mixin ReactterInstanceManager {
  final HashMap<String, ReactterInstance> _instancesByKey = HashMap();
  final HashMap<Object, ReactterInstance> _instancesCreated = HashMap();

  /// Registers a [builder] function into to [_instancesByKey]
  /// to allows to create the instance with [get].
  ///
  /// Returns `true` when instance has been registered.
  bool register<T extends Object?>({
    required ContextBuilder<T> builder,
    String? id,
  }) {
    final instanceKey = ReactterInstance.generateKey<T?>(id);
    var reactterInstance = _instancesByKey[instanceKey];

    if (reactterInstance?._builder != null) {
      Reactter.log('Instance "$reactterInstance" already registered.');
      return false;
    }

    reactterInstance =
        _instancesByKey[instanceKey] = ReactterInstance<T>(id, builder);

    Reactter.emit(reactterInstance, Lifecycle.registered);
    Reactter.log('Instance "$reactterInstance" has been registered.');
    return true;
  }

  /// Removes a builder function from [_instancesByKey].
  ///
  /// Returns `true` when instance has been unregistered.
  bool unregister<T extends Object>([String? id]) {
    final instanceKey = ReactterInstance.generateKey<T?>(id);
    var reactterInstance = _instancesByKey[instanceKey];

    if (reactterInstance == null) {
      reactterInstance = ReactterInstance<T>(id);
      Reactter.log('Instance "$reactterInstance" don\'t exist.');
      return false;
    }

    _removeInstance<T>(reactterInstance);

    Reactter.emit(reactterInstance, Lifecycle.unregistered);
    Reactter.dispose(reactterInstance);

    _instancesByKey.remove(instanceKey);

    Reactter.log('Instance "$reactterInstance" has been unregistered.');
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

  /// Deletes the instance from [_instancesByKey] but keep the [_builder] function.
  ///
  /// Returns `true` when the instance has been deleted.
  bool delete<T extends Object?>([String? id, Object? ref]) {
    final instanceKey = ReactterInstance.generateKey<T?>(id);
    var reactterInstance = _instancesByKey[instanceKey];

    if (reactterInstance == null || reactterInstance.instance == null) {
      reactterInstance = ReactterInstance<T>(id);
      Reactter.log(
        'Instance "$reactterInstance" already deleted.',
        isError: true,
      );
      return false;
    }

    if (ref != null) {
      reactterInstance.refs.remove(ref.hashCode);
    }

    if (reactterInstance.refs.isNotEmpty) {
      return false;
    }

    _removeInstance<T>(reactterInstance);

    Reactter.dispose(reactterInstance);

    return true;
  }

  /// Get the [ReactterInstance] of [instance] given.
  ///
  /// If found it, returns it, else returns `null`.
  ReactterInstance? find(Object? instance) => _instancesCreated[instance];

  /// Valids if the instance of [T] with or without [id] given exists.
  bool exists<T extends Object?>([String? id]) {
    final instanceKey = ReactterInstance.generateKey<T?>(id);

    return _instancesByKey[instanceKey]?.instance != null;
  }

  T? instanceOf<T extends Object?>([String? id]) {
    final instanceKey = ReactterInstance.generateKey<T?>(id);
    return _instancesByKey[instanceKey]?.instance;
  }

  ReactterInstance<T?>? _getAndCreateIfNotExtist<T extends Object?>([
    String? id,
  ]) {
    final instanceKey = ReactterInstance.generateKey<T?>(id);
    var reactterInstance = _instancesByKey[instanceKey] as ReactterInstance<T>?;

    if (reactterInstance?._builder == null) {
      reactterInstance = ReactterInstance<T>(id);
      Reactter.log(
        'Builder for instance "$reactterInstance" is not registered.\n' +
            'You should register instance with ' +
            '"Reactter.register<$T>(builder:() => $T())" or ' +
            '"Reactter.create<$T>(builder: () => $T())".',
        isError: true,
      );

      return reactterInstance;
    }

    if (reactterInstance!.instance != null) {
      Reactter.log('Instance "$reactterInstance" already created.');

      return reactterInstance;
    }

    _asignInstanceToSignals<T>(reactterInstance);

    Reactter.emit(reactterInstance, Lifecycle.initialized);
    Reactter.log('Instance "$reactterInstance" has been created.');

    return reactterInstance;
  }

  void _asignInstanceToSignals<T>(ReactterInstance reactterInstance) {
    final _isBusy = Reactter._instancesBuilding;
    final List<Signal> _signalsTemp =
        _isBusy ? List.from(Reactter._signalsRecollected) : [];

    if (_isBusy) {
      Reactter._signalsRecollected.clear();
    }

    Reactter._instancesBuilding = true;

    final instance = _createInstance<T>(reactterInstance);

    if (instance is ReactterHookManager) {
      instance._listenStates();
      instance._isCreated = true;
    }

    if (instance != null) {
      for (final signal in Reactter._signalsRecollected) {
        signal._attachIt(instance);
      }
    }

    Reactter._signalsRecollected.clear();

    if (_isBusy) {
      Reactter._signalsRecollected.addAll(_signalsTemp);
    }

    Reactter._instancesBuilding = false;
  }

  T _createInstance<T>(ReactterInstance reactterInstance) {
    reactterInstance._instance = reactterInstance._builder?.call();

    if (reactterInstance._instance != null) {
      _instancesCreated[reactterInstance._instance!] = reactterInstance;
    }

    return reactterInstance._instance;
  }

  void _removeInstance<T>(ReactterInstance reactterInstance) {
    final log = 'Instance "$reactterInstance" has been deleted.';

    if (reactterInstance.instance is ReactterContext) {
      (reactterInstance.instance as ReactterContext).dispose();
    }

    if (reactterInstance.instance is ReactterHookManager) {
      (reactterInstance.instance as ReactterHookManager)._unlistenHooks();
    }

    _instancesCreated.remove(reactterInstance.instance);

    reactterInstance._instance = null;

    Reactter.emit(reactterInstance, Lifecycle.destroyed);

    Reactter.log(log);
  }
}
