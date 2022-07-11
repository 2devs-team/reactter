// ignore_for_file: constant_identifier_names, avoid_print
part of '../core.dart';

/// A instances manager
extension ReactterInstanceManager on _ReactterInterface {
  /// Registers a [builder] function into to [Reactter.factory.instances]
  /// to allows to create the instance with [get].
  ///
  /// returns `true` when instance has been registered.
  bool register<T extends Object?>({
    required ContextBuilder<T> builder,
    String? id,
  }) {
    final instance = ReactterInstance<T?>.withBuilder(id, builder);

    if (Reactter.factory.instances.contains(instance)) {
      Reactter.log('Instance "$instance" already registered.');
      return false;
    }

    Reactter.factory.instances.add(instance);
    UseEvent<T>(id).emit(Lifecycle.registered);
    Reactter.log('Instance "$instance" has been registered.');
    return true;
  }

  /// Remove a builder function from [Reactter.factory.instances].
  ///
  /// returns `true` when instance has been unregistered.
  bool unregister<T extends Object>([String? id]) {
    final instance = ReactterInstance<T?>(id);

    if (!Reactter.factory.instances.contains(instance)) {
      Reactter.log('Instance "$instance" don\'t exist.');
      return false;
    }

    Reactter.factory.instances.remove(instance);
    UseEvent<T>(id).emit(Lifecycle.unregistered);
    Reactter.log('Instance "$instance" has been unregistered.');
    return true;
  }

  /// Gets the instance of [T] with or without [id] given.
  ///
  /// If found it, returns it, else returns `null`.
  T? get<T extends Object?>([String? id]) {
    final instanceToFind = ReactterInstance<T?>(id);
    final instanceFound = Reactter.factory.instances.lookup(instanceToFind);

    if (instanceFound == null) {
      Reactter.log(
        'Builder for instance "$instanceToFind" is not registered.\n' +
            'You should register instance with ' +
            '"Reactter.register<$T>(builder:() => $T())" or ' +
            '"Reactter.create<$T>(builder: () => $T())".',
        isError: true,
      );
    }

    return instanceFound?.instance;
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

    final instanceToFind = ReactterInstance<T?>(id);
    final instanceFound = Reactter.factory.instances.lookup(instanceToFind);

    if (instanceFound == null) {
      Reactter.log(
        'Builder for instance "$instanceToFind" is not registered.\n' +
            'You should register instance with ' +
            '"Reactter.register<$T>(builder:() => $T())" or ' +
            '"Reactter.create<$T>(builder: () => $T())".',
        isError: true,
      );

      return null;
    }

    if (ref != null && !instanceFound.refs.contains(ref.hashCode)) {
      instanceFound.refs.add(ref.hashCode);
    }

    if (instanceFound.instance != null) {
      Reactter.log('Instance "$instanceFound" already created.');

      return instanceFound.instance;
    }

    instanceFound.instance = instanceFound.builder?.call();
    UseEvent<T>(id).emit(Lifecycle.initialized);
    Reactter.log('Instance "$instanceFound" has been created.');

    return instanceFound.instance;
  }

  /// Deletes the instance from [Reactter.factory.instances] but keep the [builder] function.
  ///
  /// Returns `true` when the instance has been deleted.
  bool delete<T extends Object?>({
    String? id,
    Object? ref,
    Function? onDelete,
  }) {
    final instanceToFind = ReactterInstance<T?>(id);
    final instanceFound = Reactter.factory.instances.lookup(instanceToFind);

    if (instanceFound == null) {
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

    onDelete?.call();

    final log = 'Instance "$instanceFound" has been deleted.';

    if (instanceFound.instance is ReactterContext) {
      (instanceFound.instance as ReactterContext).dispose();
    }

    instanceFound.instance = null;

    UseEvent<T>(id)
      ..emit(Lifecycle.destroyed)
      ..dispose();

    Reactter.log(log);

    return true;
  }

  /// Get the [ReactterInstance] of [instance] given.
  ///
  /// If found it, returns it, else returns `null`.
  ReactterInstance? find(Object? instance) {
    try {
      return Reactter.factory.instances
          .firstWhere((element) => element.instance == instance);
    } catch (e) {
      return null;
    }
  }

  /// Valids if the instance of [T] with or without [id] given exists.
  bool exists<T extends Object?>([String? id]) {
    final instanceToFind = ReactterInstance<T?>(id);

    return Reactter.factory.instances.lookup(instanceToFind)?.instance != null;
  }
}
