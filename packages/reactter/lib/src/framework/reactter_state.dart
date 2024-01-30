part of 'framework.dart';

/// A abstract class that represents a stare in Reactter.
///
/// It provides methods for attaching and detaching an object instance to
/// the state, notifying listeners of state changes, and disposing of the state
/// object when it is no longer needed.
abstract class ReactterState extends State {
  @internal
  StateManager get stateManager => Reactter;
  @internal
  EventManager get eventManager => Reactter;
}

/// An implementation of the [ReactterState].
abstract class ReactterStateImpl extends ReactterState {
  ReactterStateImpl() {
    Zone.recollectState(this);
  }
}
