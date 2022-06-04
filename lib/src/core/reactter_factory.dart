// ignore_for_file: constant_identifier_names, avoid_print

import 'dart:collection';
import 'dart:ui';
import 'reactter_types.dart';
import '../engine/reactter_interface_instance.dart';

/// A instance manager
class ReactterInstance<T> {
  Type type = T;
  final String? id;
  ContextBuilder<T>? builder;
  T? instance;

  /// Stores the object from which it was instantiated
  HashSet<Object> fromList = HashSet<Object>();

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
  HashSet<ReactterInstance> instances = HashSet<ReactterInstance>();
  // Map<int, ReactterInstance> instances = {};

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

  bool existsInstance<T extends Object>([String? id]) {
    final instanceToFind = ReactterInstance<T>(id);

    return _reactterFactory.instances.lookup(instanceToFind)?.instance != null;
  }

  /// Obtains a instance of [T] given.
  ///
  /// If a [builder] of [T] isn't in [instances] returns `null`
  ///
  /// Creates the instance if is not create but is already registered in [instances]
  T? getInstance<T extends Object>(String? id, Object from) {
    final instanceToFind = ReactterInstance<T>(id);
    final instanceFound = _reactterFactory.instances.lookup(instanceToFind);

    if (instanceFound == null) {
      Reactter.log(
        'Builder for instance "$instanceToFind" is not registered. You should register instance with "Reactter.factory.register<$T>(() => $T())" or "UseContext(() => $T())"',
        isError: true,
      );

      return null;
    }

    if (instanceFound.instance == null) {
      instanceFound.instance = instanceFound.builder?.call();

      Reactter.log(
        'Instance "$instanceFound" has been created',
      );
    } else {
      Reactter.log(
        'Instance "$instanceFound" already created',
      );
    }

    if (!instanceFound.fromList.contains(from)) {
      instanceFound.fromList.add(from);
    }

    return instanceFound.instance;
  }

  /// Deletes the instance from [instances] but keep the [builder] in memory.
  void deletedInstance<T extends Object>(
    String? id,
    Object from, [
    Function? cbDelete,
  ]) {
    final instanceToFind = ReactterInstance<T>(id);
    final instanceFound = _reactterFactory.instances.lookup(instanceToFind);

    if (instanceFound == null) {
      return Reactter.log(
        'Instance "$instanceToFind" already deleted',
        isError: true,
      );
    }

    instanceFound.fromList.remove(from);

    if (instanceFound.fromList.isNotEmpty) {
      return;
    }

    cbDelete?.call();

    final log = 'Instance "$instanceFound" has been deleted';

    instanceFound.instance = null;

    Reactter.log(log);
  }
}
