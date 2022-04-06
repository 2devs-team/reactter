// ignore_for_file: constant_identifier_names, avoid_print

import '../engine/reactter_interface_instance.dart';
import 'reactter_types.dart';

/// The key used to indentify global instances inside [ReactterFactory]
const GLOBAL_KEY = '[GLOBAL]';
const CREATE_KEY = '[CREATE]';

class ReactterFactory {
  static final ReactterFactory _reactterFactory = ReactterFactory._();

  factory ReactterFactory() {
    return _reactterFactory;
  }

  ReactterFactory._();

  /// Store the builders from every [UseContext] in memory to create when needed.
  Map<String, Object Function()> builders = {};
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
  void register<T extends Object>(
    BuilderContext<T> builder, [
    String id = "",
    bool save = false,
  ]) {
    final findBuilder = _reactterFactory.builders["$T"] != null;
    final findIdBuilder = _reactterFactory.builders["$T[id='$id']"] != null;

    if (id == "") {
      if (findBuilder) {
        Reactter.log('Instance "${T.toString()}$id" already registered');
        return;
      }

      _reactterFactory.builders.addEntries([MapEntry("$T", builder)]);

      Reactter.log('Instance "${T.toString()}" has been registered');

      return;
    }

    if (findIdBuilder) {
      Reactter.log('Instance "${T.toString()}$id" already registered');
      return;
    }

    if (save) {
      _reactterFactory.builders.addEntries([MapEntry("$T[id='$id']", builder)]);
    }

    Reactter.log("Instance '$T[id='$id']' has been registered");
  }

  /// Remove a builder function from [builders].
  void unregistered<T extends Object>() {
    _reactterFactory.builders.remove("$T");
    Reactter.log('Instance "$T" has been unregistered');
  }

  /// Search for a [T] instance given. This [T] has to be a [ReactterContext] object.
  ///
  /// If a [builder] of [T] isn't in [builders] returns `null`
  ///
  /// Create the instance if is not create but is already registered in [builders]
  T? getInstance<T extends Object>({String? id, bool save = false}) {
    // if (id != null) {
    //   final _builder = _reactterFactory.builders[T];
    //   final _key = _getKey<T>();

    //   if (_builder == null) {
    //     Reactter.log(
    //         'Builder for instance "${T.toString()}" is not registered. You should register instance with "Reactter.factory.register<${T.toString()}>()" or "CreateContext<${T.toString()}>(...)"');
    //     return null;
    //   }

    //   final _instance = _builder();

    //   Reactter.log(
    //       'Instance "${T.toString()}[id=$id]"(${_instance.hashCode}) has been created');

    //   _addInstance<T>(key: _key, instance: _instance as T);

    //   _addInstanceRunning<T>(
    //     key: _getKey<T>(id: id),
    //     instance: _instance,
    //   );

    //   return _instance;
    // }

    var _instance = _getInstance<T>(id: id);
    final _id = id != null ? "[id='$id']" : "";

    if (_instance == null) {
      InstanceBuilder<T>? _builder = (id == null || save == false)
          ? _reactterFactory.builders[T.toString()]
          : _reactterFactory.builders["$T$_id"];

      if (_builder == null) {
        Reactter.log(
            'Builder for instance "${T.toString()}" is not registered. You should register instance with "Reactter.factory.register<${T.toString()}>()" or "CreateContext<${T.toString()}>(...)"');
        return null;
      }

      _instance = _builder() as T;

      Reactter.log(
        'Instance "${T.toString()}$_id"(${_instance.hashCode}) has been created',
      );

      _addInstance<T>(
        key: _getKey<T>(id: id),
        instance: _instance,
      );
    } else {
      Reactter.log(
          'Instance "${T.toString()}$_id"(${_instance.hashCode}) already created');
    }

    _addInstanceRunning(
      key: _getKey<T>(),
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
  String _getKey<T>({String? id}) {
    if (id == null) {
      return '${GLOBAL_KEY}_${T.hashCode.toString()}';
    }

    return '${CREATE_KEY}_[$id]_${T.hashCode.toString()}';
  }

  /// Get a key for identify objects in [instances]
  T? _getInstance<T>({String? id}) {
    final _key = _getKey<T>(id: id);

    return instances[_key]?.first as T?;
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
