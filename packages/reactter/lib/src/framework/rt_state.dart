part of 'framework.dart';

/// {@template reactter.rt_state}
/// A abstract class that represents a stare in Reactter.
///
/// It provides methods for attaching and detaching an object instance to
/// the state, notifying listeners of state changes, and disposing of the state
/// object when it is no longer needed.
/// {@endtemplate}
abstract class RtState extends State {
  @override
  @internal
  DependencyInjection get dependencyInjection => Rt;
  @override
  @internal
  StateManagement get stateManagment => Rt;
  @override
  @internal
  EventHandler get eventHandler => Rt;
  @override
  @internal
  Logger get logger => Rt;
}

/// {@template reactter.rt_state_impl}
/// An implementation of the [RtState].
/// {@endtemplate}
abstract class RtStateImpl extends RtState {
  RtStateImpl() {
    BindingZone.recollectState(this);
  }
}

/// {@macro reactter.rt_state}
@Deprecated(
  'Use `RtState` instead. '
  'This feature was deprecated after v7.3.0.',
)
typedef ReactterState = RtState;

/// {@macro reactter.rt_state_impl}
@Deprecated(
  'Use `RtStateImpl` instead. '
  'This feature was deprecated after v7.3.0.',
)
typedef ReactterStateImpl = RtStateImpl;
