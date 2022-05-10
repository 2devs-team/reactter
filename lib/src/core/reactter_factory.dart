// ignore_for_file: constant_identifier_names, avoid_print

import 'dart:ui';
import 'reactter_types.dart';
import '../engine/reactter_interface_instance.dart';

/// A instance manager
class ReactterInstance<T> {
  Type type = T;
  final String? id;
  ContextBuilder<T>? builder;
  T? instance;

  /// Stores the number of times the instance is used
  int nRunning = 0;

  ReactterInstance(this.id);
  ReactterInstance.withBuilder(this.id, ContextBuilder<T> _builder) {
    builder = _builder;
  }

  @override

  /// Is equal with [T] and [id]
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

/// A instances manager
class ReactterFactory {
  static final ReactterFactory _reactterFactory = ReactterFactory._();

  factory ReactterFactory() {
    return _reactterFactory;
  }

  ReactterFactory._();

  /// Stores all instances.
  ///
  /// This variable is who keep all the states running in memory.
  List<ReactterInstance> instances = [];

  /// Registers a builder function into to [instances] to create a new instance
  ///
  /// returns true when instance has been registered.
  bool register<T extends Object>(
    ContextBuilder<T> builder, [
    String? id,
  ]) {
    final _instance = ReactterInstance<T>.withBuilder(id, builder);

    if (_reactterFactory.instances.contains(_instance)) {
      Reactter.log('Instance "$_instance" already registered');
      return false;
    }

    _reactterFactory.instances.add(_instance);
    Reactter.log('Instance "$_instance" has been registered');
    return true;
  }

  /// Remove a builder function from [instances].
  void unregistered<T extends Object>(String? id) {
    final _instance = ReactterInstance<T>(id);

    if (!_reactterFactory.instances.contains(_instance)) {
      Reactter.log('Instance "$_instance" don\'t exist');
      return;
    }

    _reactterFactory.instances.remove(_instance);
    Reactter.log('Instance "$_instance" has been unregistered');
  }

  /// Obtains a instance of [T] given.
  ///
  /// If a [builder] of [T] isn't in [instances] returns `null`
  ///
  /// Creates the instance if is not create but is already registered in [instances]
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

  /// Deletes the instance from [instances] but keep the [builder] in memory.
  void deleted(Object instance) {
    try {
      final _instance =
          _reactterFactory.instances.firstWhere((inst) => inst == instance);

      _instance.nRunning -= 1;

      if (_instance.nRunning < 1) {
        final _log = 'Instance "$_instance" has been deleted';

        _instance.instance = null;

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
