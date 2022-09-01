// ignore_for_file: non_constant_identifier_names

part of '../core.dart';

class _ReactterInterface {
  bool isLogEnable = true; //kDebugMode;
  LogWriterCallback log = defaultLogWriterCallback;

  ReactterInstanceManager _instanceManager = ReactterInstanceManager();

  HashSet<ReactterInstance> get instances => _instanceManager.instances;

  /// Registers a [builder] function into to [instances]
  /// to allows to create the instance with [get].
  ///
  /// Returns `true` when instance has been registered.
  bool register<T extends Object?>({
    required ContextBuilder<T> builder,
    String? id,
  }) =>
      _instanceManager.register<T>(builder: builder, id: id);

  /// Removes a builder function from [instances].
  ///
  /// Returns `true` when instance has been unregistered.
  bool unregister<T extends Object>([String? id]) =>
      _instanceManager.unregister<T>(id);

  /// Gets the instance of [T] with or without [id] given.
  ///
  /// If not found and has registered, create a new instance.
  ///
  /// If found it, returns it, else returns `null`.
  T? get<T extends Object?>([String? id]) => _instanceManager.get<T>(id);

  /// Registers, creates and gets the instance of [T] with or without [id] given.
  ///
  /// Returns it, else return `null`.
  T? create<T extends Object?>({
    required ContextBuilder<T> builder,
    String? id,
    Object? ref,
  }) =>
      _instanceManager.create<T>(builder: builder, id: id, ref: ref);

  /// Deletes the instance from [instances] but keep the [builder] function.
  ///
  /// Returns `true` when the instance has been deleted.
  bool delete<T extends Object?>([String? id, Object? ref]) =>
      _instanceManager.delete<T>(id, ref);

  /// Get the [ReactterInstance] of [instance] given.
  ///
  /// If found it, returns it, else returns `null`.
  ReactterInstance? find(Object? instance) => _instanceManager.find(instance);

  /// Valids if the instance of [T] with or without [id] given exists.
  bool exists<T extends Object?>([String? id]) =>
      _instanceManager.exists<T>(id);
}

final Reactter = _ReactterInterface();
