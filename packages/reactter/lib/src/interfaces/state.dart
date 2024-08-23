part of '../internals.dart';

/// {@template reactter.rt_state}
/// A abstract class that represents a stare in Reactter.
/// {@endtemplate}
abstract class IState implements IContext {
  bool get isDisposed;

  /// The reference instance to the current state.
  Object? get boundInstance;

  /// A label used for debugging purposes.
  String get debugLabel => "$runtimeType[$hashCode]";

  /// A map containing properties used for debugging purposes.
  Map<String, dynamic> get debugProperties;

  /// This method is typically used for internal
  /// registration purposes within the state management system.
  @protected
  @mustCallSuper
  void _register();

  /// Stores a reference to an object instance
  @mustCallSuper
  void bind(Object instance);

  /// Removes the reference to the object instance
  @mustCallSuper
  void unbind();

  /// Executes [fnUpdate], and notify the listeners about to update.
  ///
  /// This method triggers the `Lifecycle.didUpdate` event,
  /// which allows listeners to react to the updated state.
  @mustCallSuper
  void update(covariant Function fnUpdate);

  /// Executes [fnUpdate], and notify the listeners about to update.
  ///
  /// This method triggers the `Lifecycle.didUpdate` event,
  /// which allows listeners to react to the updated state.
  @mustCallSuper
  @Deprecated("Use 'notify' instead.")
  void refresh();

  /// It's used to notify listeners that the state has been updated.
  /// It is typically called after making changes to the state object.
  ///
  /// This method triggers the `Lifecycle.didUpdate` event,
  /// which allows listeners to react to the updated state.
  @mustCallSuper
  void notify();

  /// Called when this object is removed
  @mustCallSuper
  void dispose();

  void _validateInstanceBinded();
}
