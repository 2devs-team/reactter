part of '../../widgets.dart';

/// A class that holds a reference to a state or an instance, and it can add and remove listeners
/// to the state or instance
class ReactterDependency<T> {
  final String? _id;
  Object? _instance;
  final Set<ReactterState>? _states;

  ReactterDependency({
    String? id,
    Object? instance,
    Set<ReactterState>? states,
  })  : assert((instance != null && states == null) ||
            (states != null && instance == null)),
        _id = id,
        _instance = instance,
        _states = states;

  void _addListener(
    CallbackEvent<ReactterHookManager, ReactterState> callback,
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
    CallbackEvent<ReactterHookManager, ReactterState> callback,
  ) {
    for (final state in states) {
      if (_states?.contains(state) == true) continue;

      _states?.add(state);
      Reactter.on(state, Lifecycle.didUpdate, callback);
    }
  }

  void _addInstanceAndListener(
    Object? instance,
    CallbackEvent<ReactterHookManager, ReactterState> callback,
  ) {
    if (_instance != null) return;

    _instance = instance;

    Reactter.on(_instance, Lifecycle.didUpdate, callback);
  }

  void _removeListener(
    CallbackEvent<ReactterHookManager, ReactterState> callback,
  ) {
    if (_states != null) {
      for (final state in _states!) {
        Reactter.off(state, Lifecycle.didUpdate, callback);
      }
    }

    if (_instance != null) {
      Reactter.off(_instance, Lifecycle.didUpdate, callback);
    }
  }

  /// Is equal with [T] and [_id]
  @override
  bool operator ==(Object other) =>
      other is ReactterDependency<T?> && other._id == _id;

  @override
  int get hashCode => Object.hash(T, _id);
}
