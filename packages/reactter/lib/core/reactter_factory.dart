// ignore_for_file: constant_identifier_names, avoid_print
part of '../core.dart';

/// A instance manager
class ReactterInstance<T> {
  final String? id;
  ContextBuilder<T?>? builder;
  T? instance;

  /// Stores the object from which it was instantiated
  HashSet<int> fromList = HashSet<int>();

  ReactterInstance(this.id);
  ReactterInstance.withBuilder(this.id, this.builder);

  /// Is equal with [T] and [id]
  @override
  bool operator ==(Object other) =>
      other is ReactterInstance<T?> && other.id == id;

  @override
  int get hashCode => hashValues(T, id);

  @override
  String toString() {
    final type = T.toString().replaceAll(RegExp(r'\?'), '');
    final id = this.id != null ? "[id='${this.id}']" : "";
    final hashCode = instance != null ? "(${instance.hashCode})" : "";

    return '$type$id$hashCode"';
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

  /// Registers a builder function into to [instances] to create a new instance
  ///
  /// returns `true` when instance has been registered.
  bool register<T extends Object?>({
    required ContextBuilder<T> builder,
    String? id,
  }) {
    final instance = ReactterInstance<T?>.withBuilder(id, builder);

    if (_reactterFactory.instances.contains(instance)) {
      Reactter.log('Instance "$instance" already registered.');
      return false;
    }

    _reactterFactory.instances.add(instance);
    UseEvent<T>(id).trigger(LifeCycle.registered);
    Reactter.log('Instance "$instance" has been registered.');
    return true;
  }

  /// Remove a builder function from [instances].
  void unregister<T extends Object>([String? id]) {
    final instance = ReactterInstance<T?>(id);

    if (!_reactterFactory.instances.contains(instance)) {
      Reactter.log('Instance "$instance" don\'t exist.');
      return;
    }

    _reactterFactory.instances.remove(instance);
    UseEvent<T>(id).trigger(LifeCycle.unregistered);
    Reactter.log('Instance "$instance" has been unregistered.');
  }

  /// Valid if exists the instance of [T] with or without [id] given.
  bool existsInstance<T extends Object?>([String? id]) {
    final instanceToFind = ReactterInstance<T?>(id);

    return _reactterFactory.instances.lookup(instanceToFind)?.instance != null;
  }

  /// Get the instance manager([ReactterInstance]) of instance.
  /// If not found it, returns `null`.
  ReactterInstance? findInstance(Object? instance) {
    try {
      return _reactterFactory.instances
          .firstWhere((element) => element.instance == instance);
    } catch (e) {
      return null;
    }
  }

  /// Obtains a instance of [T] given.
  ///
  /// If a [builder] of [T] isn't in [instances] returns `null`
  ///
  /// Creates the instance if is not create but is already registered in [instances]
  T? getInstance<T extends Object?>({
    String? id,
    Object? ref,
  }) {
    final instanceToFind = ReactterInstance<T?>(id);
    final instanceFound = _reactterFactory.instances.lookup(instanceToFind);

    if (instanceFound == null) {
      Reactter.log(
        'Builder for instance "$instanceToFind" is not registered. You should register instance with "Reactter.factory.register<$T>(() => $T())" or "ReactterProvider(() => $T())".',
        isError: true,
      );

      return null;
    }

    if (instanceFound.instance == null) {
      instanceFound.instance = instanceFound.builder?.call();
      UseEvent<T>(id).trigger(LifeCycle.initialized);

      Reactter.log('Instance "$instanceFound" has been created.');
    } else {
      Reactter.log('Instance "$instanceFound" already created.');
    }

    if (ref != null && !instanceFound.fromList.contains(ref.hashCode)) {
      instanceFound.fromList.add(ref.hashCode);
    }

    return instanceFound.instance;
  }

  // Registers and obtains the instance of [T] with or without [id] given.
  T? createInstance<T extends Object?>({
    required ContextBuilder<T> builder,
    String? id,
    Object? ref,
  }) {
    register<T>(builder: builder, id: id);
    return getInstance<T>(id: id, ref: ref);
  }

  /// Deletes the instance from [instances] but keep the [builder] in memory.
  void deletedInstance<T extends Object?>(
    String? id,
    Object ref, [
    Function? cbDelete,
  ]) {
    final instanceToFind = ReactterInstance<T?>(id);
    final instanceFound = _reactterFactory.instances.lookup(instanceToFind);

    if (instanceFound == null) {
      return Reactter.log(
        'Instance "$instanceToFind" already deleted.',
        isError: true,
      );
    }

    instanceFound.fromList.remove(ref.hashCode);

    if (instanceFound.fromList.isNotEmpty) {
      return;
    }

    cbDelete?.call();

    final log = 'Instance "$instanceFound" has been deleted.';

    if (instanceFound.instance is ReactterContext) {
      (instanceFound.instance as ReactterContext).dispose();
    }

    instanceFound.instance = null;

    UseEvent<T>(id).trigger(LifeCycle.destroyed);
    UseEvent<T>(id).clear();

    Reactter.log(log);
  }
}
