// ignore_for_file: constant_identifier_names

library reactter;

import 'package:reactter/reactter.dart';

const GLOBAL_KEY = '_[GLOBAL]_';

class ReactterFactory {
  static final ReactterFactory _reactterFactory = ReactterFactory._();

  factory ReactterFactory() {
    return _reactterFactory;
  }

  ReactterFactory._();

  Map<Type, Object Function()> builders = {};
  // Map<String, ...> = Map<String + Type.hashCode.toString(), ...>
  Map<String, List<Object>> instances = {};
  Map<Object, String> instancesKeys = {};
  Map<String, int> instancesRunning = {};

  void register<T extends Object>(T Function() builder) {
    if (_reactterFactory.builders[T] != null) {
      Reactter.log('Instance "${T.toString()}" already registered');
      return;
    }

    _reactterFactory.builders.addEntries([MapEntry(T, builder)]);
    Reactter.log('Instance "${T.toString()}" has been registered');
  }

  void unregistered<T extends Object>() {
    _reactterFactory.builders.remove(T);
    Reactter.log('Instance "${T.toString()}" has been unregistered');
  }

  T? getInstance<T extends Object>([bool create = false, String? imp]) {
    print('getInstance: $imp');
    if (create) {
      final _builder = _reactterFactory.builders[T];
      final _key = _getKey();

      if (_builder == null) {
        Reactter.log(
            'Builder for instance "${T.toString()}" is not registered. You should register instance with "Reactter.factory.register<${T.toString()}>()" or "CreateContext<${T.toString()}>(...)"');
        return null;
      }

      final _instance = _builder();

      Reactter.log(
          'Instance "${T.toString()}"($_instance.hashCode) has been created');

      _addInstance<T>(key: _key, instance: _instance);

      return _instance as T;
    }

    var _instance = _getGlobalInstance<T>();

    if (_instance == null) {
      final _builder = _reactterFactory.builders[T];

      if (_builder == null) {
        return null;
      }

      _instance = _builder();

      Reactter.log(
        'Instance "${T.toString()}"($_instance.hashCode) has been created as global',
      );
    }

    _addInstance<T>(
      key: _getKey(true),
      instance: _instance,
    );

    return _instance as T;
  }

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

  String _getKey<T extends Object>([
    bool global = false,
  ]) {
    if (global) {
      return '$GLOBAL_KEY${T.hashCode.toString()}';
    }

    return T.hashCode.toString();
  }

  Object? _getGlobalInstance<T extends Object>() {
    return instances[_getKey<T>(true)]?.first;
  }

  _addInstance<T extends Object>({
    required String key,
    required Object instance,
  }) {
    _reactterFactory.instances[key] ??= [];
    _reactterFactory.instances[key]?.add(instance);

    _reactterFactory.instancesRunning[key] ??=
        (_reactterFactory.instancesRunning[key] ?? 0) + 1;
  }
}
