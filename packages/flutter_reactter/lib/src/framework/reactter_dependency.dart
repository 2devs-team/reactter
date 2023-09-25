part of '../framework.dart';

/// A class that holds a reference to a state or an instance, and it can add and remove listeners
/// to the state or instance
@internal
class ReactterDependency<T> {
  Object? _instance;
  final Set<ReactterState>? _states;

  ReactterDependency({
    String? id,
    Object? instance,
    Set<ReactterState>? states,
  })  : assert((instance != null && states == null) ||
            (states != null && instance == null)),
        _instance = instance,
        _states = states;

  void _addListener(
    CallbackEvent<Object, ReactterState> callback,
  ) {
    if (_states != null) {
      for (final state in _states!) {
        Reactter.on(state, Lifecycle.didUpdate, callback);
      }
    }

    if (_instance != null) {
      Reactter.on(_instance, Lifecycle.didUpdate, callback);
    }
  }

  void _addStatesAndListener(
    Set<ReactterState> states,
    CallbackEvent<Object, ReactterState> callback,
  ) {
    for (final state in states) {
      if (_states?.contains(state) == true) continue;

      _states?.add(state);
      Reactter.on(state, Lifecycle.didUpdate, callback);
    }
  }

  void _addInstanceAndListener(
    Object? instance,
    CallbackEvent<Object, ReactterState> callback,
  ) {
    if (_instance != null) return;

    _instance = instance;

    Reactter.on(_instance, Lifecycle.didUpdate, callback);
  }

  void _removeListener(
    CallbackEvent<Object, ReactterState> callback,
  ) {
    if (_states != null) {
      for (final state in _states!) {
        Reactter.off(state, Lifecycle.didUpdate, callback);

        if (state is UseCompute && state.instanceAttached == null) {
          state.dispose();
        }
      }
    }

    if (_instance != null) {
      Reactter.off(_instance, Lifecycle.didUpdate, callback);
    }
  }
}
