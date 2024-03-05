part of 'core.dart';

/// A abstract class that represents a stare in Reactter.
@internal
abstract class StateBase {
  @internal
  InstanceManager get instanceManager;
  @internal
  StateManager get stateManager;
  @internal
  EventManager get eventManager;
  @internal
  Logger get logger;

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

  /// It's used to notify listeners that the state has been updated.
  /// It is typically called after making changes to the state object.
  ///
  /// This method triggers the `Lifecycle.didUpdate` event,
  /// which allows listeners to react to the updated state.
  @mustCallSuper
  void refresh();

  /// Called when this object is removed
  @mustCallSuper
  void dispose();
}
