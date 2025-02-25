part of '../framework.dart';

/// {@template reactter.rt_state_observer}
/// A class that implements the [IStateObserver] interface.
///
/// It provides a set of callback functions that can be used to observe
/// the lifecycle of states.
///
/// This observer should be added to Reactter's observers for it to work,
/// using the [Rt.addObserver] method, like so:
///
/// ```dart
/// final stateObserver = RtStateObserver(
///   onCreated: (state) {
///     print('State created: $state');
///   },
///   onBound: (state, instance) {
///     print('State bound: $state, instance: $instance');
///   },
///   onUnbound: (state, instance) {
///     print('State unbound: $state, instance: $instance');
///   },
///   onUpdated: (state) {
///      print('State updated: $state');
///   },
///   onDisposed: (state) {
///     print('State disposed: $state');
///   },
/// );
///
/// Rt.addObserver(stateObserver);
/// ```
///
/// See also:
/// - [IStateObserver] - An abstract class that defines the interface for observing lifecycle of states.
/// - [Rt.addObserver] - A method that adds an observer to Reactter's observers.
/// {@endtemplate}
class RtStateObserver implements IStateObserver {
  /// {@macro reactter.i_state_observer.on_state_bound}
  final void Function(RtState state, Object instance)? onBound;

  /// {@macro reactter.i_state_observer.on_state_created}
  final void Function(RtState state)? onCreated;

  /// {@macro reactter.i_state_observer.on_state_mounted}
  final void Function(RtState state)? onDisposed;

  /// {@macro reactter.i_state_observer.on_state_unbound}
  final void Function(RtState state, Object instance)? onUnbound;

  /// {@macro reactter.i_state_observer.on_state_updated}
  final void Function(RtState state)? onUpdated;

  RtStateObserver({
    this.onBound,
    this.onCreated,
    this.onDisposed,
    this.onUnbound,
    this.onUpdated,
  });

  /// {@macro reactter.i_state_observer.on_state_bound}
  @override
  void onStateBound(RtState state, Object instance) {
    onBound?.call(state, instance);
  }

  /// {@macro reactter.i_state_observer.on_state_created}
  @override
  void onStateCreated(RtState state) {
    onCreated?.call(state);
  }

  /// {@macro reactter.i_state_observer.on_state_mounted}
  @override
  void onStateDisposed(RtState state) {
    onDisposed?.call(state);
  }

  /// {@macro reactter.i_state_observer.on_state_unbound}
  @override
  void onStateUnbound(RtState state, Object instance) {
    onUnbound?.call(state, instance);
  }

  /// {@macro reactter.i_state_observer.on_state_updated}
  @override
  void onStateUpdated(RtState state) {
    onUpdated?.call(state);
  }
}
