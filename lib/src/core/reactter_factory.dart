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
  ReactterInstance.withBuilder(this.id, this.builder);

  @override

  /// Is equal with [T] and [id]
  bool operator ==(Object other) =>
      other is ReactterInstance<T> && other.id == id;

  @override
  int get hashCode => hashValues(T, id);

  @override
  String toString() {
    final id = this.id != null ? "[id='${this.id}']" : "";
    final hashCode = instance != null ? "(${instance.hashCode})" : "";

    return '$type$id$hashCode';
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
    final instance = ReactterInstance<T>.withBuilder(id, builder);

    if (_reactterFactory.instances.contains(instance)) {
      Reactter.log('Instance "$instance" already registered');
      return false;
    }

    _reactterFactory.instances.add(instance);
    Reactter.log('Instance "$instance" has been registered');
    return true;
  }

  /// Remove a builder function from [instances].
  void unregistered<T extends Object>(String? id) {
    final instance = ReactterInstance<T>(id);

    if (!_reactterFactory.instances.contains(instance)) {
      Reactter.log('Instance "$instance" don\'t exist');
      return;
    }

    _reactterFactory.instances.remove(instance);
    Reactter.log('Instance "$instance" has been unregistered');
  }

  /// Obtains a instance of [T] given.
  ///
  /// If a [builder] of [T] isn't in [instances] returns `null`
  ///
  /// Creates the instance if is not create but is already registered in [instances]
  T? getInstance<T extends Object>([String? id]) {
    try {
      final instanceToFind = ReactterInstance<T>(id);
      final instance = _reactterFactory.instances
              .firstWhere((instance) => instance == instanceToFind)
          as ReactterInstance<T>;

      if (instance.instance == null) {
        instance.instance = instance.builder?.call();

        Reactter.log(
          'Instance "$instance" has been created',
        );
      } else {
        Reactter.log(
          'Instance "$instance" already created',
        );
      }

      instance.nRunning += 1;

      return instance.instance;
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
      final instanceFinded =
          _reactterFactory.instances.firstWhere((inst) => inst == instance);

      instanceFinded.nRunning -= 1;

      if (instanceFinded.nRunning < 1) {
        final log = 'Instance "$instance" has been deleted';

        instanceFinded.instance = null;

        Reactter.log(log);
      }
    } catch (e) {
      Reactter.log(
        'Instance "$instance"(${instance.hashCode}) already deleted',
        isError: true,
      );
    }
  }
}
