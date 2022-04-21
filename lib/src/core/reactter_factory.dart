// ignore_for_file: constant_identifier_names, avoid_print

import 'dart:ui';

import '../engine/reactter_interface_instance.dart';
import 'reactter_types.dart';

class ReactterInstance<T> {
  Type type = T;
  final String? id;
  InstanceBuilder<T>? builder;
  int nRunning = 0;
  T? instance;

  ReactterInstance(this.id);
  ReactterInstance.withBuilder(this.id, InstanceBuilder<T> _builder) {
    builder = _builder;
  }

  @override
  bool operator ==(Object other) =>
      other is ReactterInstance<T> && other.id == id;

  @override
  int get hashCode => hashValues(T, id);

  @override
  String toString() {
    final _id = id != null ? "[id='$id']" : "";
    final _hashCode = instance != null ? "(${instance.hashCode})" : "";

    return '$type$_id$_hashCode';
  }
}

class ReactterFactory {
  static final ReactterFactory _reactterFactory = ReactterFactory._();

  factory ReactterFactory() {
    return _reactterFactory;
  }

  ReactterFactory._();

  /// Store all instances.
  ///
  /// This variable is who keep all the states running in memory.
  List<ReactterInstance> instances = [];

  /// Register a builder function in [builders].
  void register<T extends Object>(
    InstanceBuilder<T> builder, [
    String? id,
  ]) {
    final _instance = ReactterInstance<T>.withBuilder(id, builder);

    if (_reactterFactory.instances.contains(_instance)) {
      Reactter.log('Instance "$_instance" already registered');
      return;
    }

    _reactterFactory.instances.add(_instance);
    Reactter.log('Instance "$_instance" has been registered');
  }

  /// Remove a builder function from [builders].
  void unregistered<T extends Object>(String? id) {
    final _instance = ReactterInstance<T>(id);

    if (!_reactterFactory.instances.contains(_instance)) {
      Reactter.log('Instance "$_instance" don\'t exist');
      return;
    }

    _reactterFactory.instances.remove(_instance);
    Reactter.log('Instance "$_instance" has been unregistered');
  }

  /// Search for a [T] instance given. This [T] has to be a [ReactterContext] object.
  ///
  /// If a [builder] of [T] isn't in [builders] returns `null`
  ///
  /// Create the instance if is not create but is already registered in [builders]
  T? getInstance<T extends Object>([String? id]) {
    try {
      final _instanceToFind = ReactterInstance<T>(id);
      final _instance = _reactterFactory.instances
              .firstWhere((instance) => instance == _instanceToFind)
          as ReactterInstance<T>;

      if (_instance.instance == null) {
        _instance.instance = _instance.builder?.call();

        Reactter.log(
          'Instance "$_instance" has been created',
        );
      } else {
        Reactter.log(
          'Instance "$_instance" already created',
        );
      }

      _instance.nRunning += 1;

      return _instance.instance;
    } catch (e) {
      Reactter.log(
        'Builder for instance "$T" is not registered. You should register instance with "Reactter.factory.register<$T>(() => $T())" or "UseContext(() => $T())"',
        isError: true,
      );

      return null;
    }
  }

  /// Delete the instace from [instances] but keep the [builder] in memory.
  void deleted(Object instance) {
    try {
      final _instance =
          _reactterFactory.instances.firstWhere((inst) => inst == instance);

      _instance.nRunning -= 1;

      if (_instance.nRunning < 1) {
        final _log = 'Instance "$_instance" has been deleted';

        _reactterFactory.instances.remove(_instance);

        Reactter.log(_log);
      }
    } catch (e) {
      Reactter.log(
        'Instance "$instance"(${instance.hashCode}) already deleted',
        isError: true,
      );
    }
  }
}
