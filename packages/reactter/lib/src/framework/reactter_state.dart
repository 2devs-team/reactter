part of 'framework.dart';

/// A abstract class that represents a stare in Reactter.
///
/// It provides methods for attaching and detaching an object instance to
/// the state, notifying listeners of state changes, and disposing of the state
/// object when it is no longer needed.
abstract class ReactterState extends State {
  @override
  @internal
  DependencyInjection get dependencyInjection => Reactter;
  @override
  @internal
  StateManagement get stateManagment => Reactter;
  @override
  @internal
  EventHandler get eventHandler => Reactter;
  @override
  @internal
  Logger get logger => Reactter;
}

/// An implementation of the [ReactterState].
abstract class ReactterStateImpl extends ReactterState {
  ReactterStateImpl() {
    BindingZone.recollectState(this);
  }
}
