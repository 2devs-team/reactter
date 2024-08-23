part of '../internals.dart';

/// {@template reactter.rt_state_observer}
/// An abstract class that defines the interface for observing state changes.
/// Implementations of this class can be used to monitor the lifecycle of states.
/// {@endtemplate}
abstract class RtStateObserver implements IObserver {
  /// A set of all registered state observers.
  static final _observers = <RtStateObserver>{};

  /// Called when a state is created.
  ///
  /// [state] - The state that was created.
  void onStateCreated(covariant RtState state);

  /// Called when a state is bound to an instance.
  ///
  /// [state] - The state that was bound.
  /// [instance] - The instance to which the state was bound.
  void onStateBound(covariant RtState state, Object instance);

  /// Called when a state is unbound from an instance.
  ///
  /// [state] - The state that was unbound.
  /// [instance] - The instance from which the state was unbound.
  void onStateUnbound(covariant RtState state, Object instance);

  /// Called when a state is updated.
  ///
  /// [state] - The state that was updated.
  void onStateUpdated(covariant RtState state);

  /// Called when a state is disposed.
  ///
  /// [state] - The state that was disposed.
  void onStateDisposed(covariant RtState state);
}
