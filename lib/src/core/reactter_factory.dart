// ignore_for_file: constant_identifier_names, avoid_print

import '../engine/reactter_interface_instance.dart';

/// The key used to indentify global instances inside [ReactterFactory]
const GLOBAL_KEY = '_[GLOBAL]_';

class ReactterFactory {
  static final ReactterFactory _reactterFactory = ReactterFactory._();

  factory ReactterFactory() {
    return _reactterFactory;
  }

  ReactterFactory._();

  /// Store the builders from every [UseContext] in memory to create when needed.
  Map<Type, Object Function()> builders = {};
  // Map<String, ...> = Map<String + Type.hashCode.toString(), ...>

  /// Store every instance created from [builders].
  ///
  /// This variable is who keep all the states running in memory.
  Map<String, List<Object>> instances = {};

  /// Store every key used by an [instance].
  ///
  /// Example: `_[Global]_`
  Map<Object, String> instancesKeys = {};

  /// Going to save all the instance running in case there are more than one of the same type.
  ///
  /// This object is experimental.
  Map<String, int> instancesRunning = {};

  /// Register a builder function in [builders].
  void register<T extends Object>(T Function() builder) {
    if (_reactterFactory.builders[T] != null) {
      Reactter.log('Instance "${T.toString()}" already registered');
      return;
    }

    _reactterFactory.builders.addEntries([MapEntry(T, builder)]);
    Reactter.log('Instance "${T.toString()}" has been registered');
  }

  /// Remove a builder function from [builders].
  void unregistered<T extends Object>() {
    _reactterFactory.builders.remove(T);
    Reactter.log('Instance "${T.toString()}" has been unregistered');
  }

  /// Search for a [T] instance given. This [T] has to be a [ReactterContext] object.
  ///
  /// If a [builder] of [T] isn't in [builders] returns `null`
  ///
  /// Create the instance if is not create but is already registered in [builders]
  T? getInstance<T extends Object>([bool create = false, String? imp]) {
    // print('getInstance: $imp');
    if (create) {
      final _builder = _reactterFactory.builders[T];
      final _key = _getKey<T>();

      if (_builder == null) {
        Reactter.log(
            'Builder for instance "${T.toString()}" is not registered. You should register instance with "Reactter.factory.register<${T.toString()}>()" or "CreateContext<${T.toString()}>(...)"');
        return null;
      }

      final _instance = _builder();

      Reactter.log(
          'Instance "${T.toString()}"(${_instance.hashCode}) has been created');

      _addInstance<T>(key: _key, instance: _instance as T);

      _addInstanceRunning<T>(
        key: _getKey<T>(true),
        instance: _instance,
      );

      return _instance;
    }

    var _instance = _getGlobalInstance<T>();

    if (_instance == null) {
      final _builder = _reactterFactory.builders[T];

      if (_builder == null) {
        return null;
      }

      _instance = _builder() as T;

      Reactter.log(
        'Instance "${T.toString()}"(${_instance.hashCode}) has been created as global',
      );

      _addInstance<T>(
        key: _getKey<T>(true),
        instance: _instance,
      );
    } else {
      Reactter.log(
          'Instance "${T.toString()}"(${_instance.hashCode}) already created');
    }

    _addInstanceRunning(
      key: _getKey<T>(true),
      instance: _instance,
    );

    return _instance;
  }

  /// Delete the instace from [instances] but keep the [builder] in memory.
  void deleted(Object instance) {
    try {
      final _key = _reactterFactory.instances.entries
          .firstWhere((_instance) => _instance.value.contains(instance))
          .key;

      final numInstancesRunning =
          (_reactterFactory.instancesRunning[_key] ?? 0) - 1;

      _reactterFactory.instancesRunning[_key] ??= numInstancesRunning;

      if (numInstancesRunning <= 0) {
        _reactterFactory.instances.remove(_key);
        _reactterFactory.instancesRunning.remove(_key);

        Reactter.log(
            'Instance "${instance.runtimeType.toString()}"($instance.hashCode) has been deleted');
      }
    } catch (e) {
      Reactter.log(
        'Instance "${instance.runtimeType.toString()}" already deleted',
        isError: true,
      );
    }
  }

  /// Get a key for identify objects in [instancesKeys].
  String _getKey<T>([
    bool global = false,
  ]) {
    if (global) {
      return '$GLOBAL_KEY${T.hashCode.toString()}';
    }

    return T.hashCode.toString();
  }

  /// Get a key for identify objects in [instancesKeys] in case it would be a Global instance.
  T? _getGlobalInstance<T>() {
    final trueKey = _getKey<T>(true);

    return instances[trueKey]?.first as T?;
  }

  _addInstance<T extends Object>({
    required String key,
    required T instance,
  }) {
    _reactterFactory.instances[key] ??= [];
    _reactterFactory.instances[key]?.add(instance);
  }

  _addInstanceRunning<T extends Object>({
    required String key,
    required T instance,
  }) {
    _reactterFactory.instancesRunning[key] ??=
        (_reactterFactory.instancesRunning[key] ?? 0) + 1;
  }
}
