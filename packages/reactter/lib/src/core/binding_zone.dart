part of 'core.dart';

/// Represents an environment that Reactter uses for managing and
/// attaching instances to a collection of states.
@internal
class BindingZone {
  /// It's used to keep track of the current [BindingZone].
  static BindingZone? _currentZone;

  /// This is done to keep a reference to the previous [BindingZone] before
  /// creating a new instance.
  final _parentZone = _currentZone;

  /// It's used to store a collection of [StateBase].
  final states = Set<StateBase>();

  /// Returns the current [BindingZone].
  static BindingZone? get currentZone => _currentZone;

  BindingZone() {
    /// This is done to keep track of the current [ReactterZone] instance.
    _currentZone = this;
  }

  /// It's used to bind the instance to the stored states([StateBase]).
  static void autoBinding(Object? Function() getInstance) {
    final zone = BindingZone();
    zone.bindInstanceToStates(getInstance());
  }

  /// Stores the state given from parameter.
  static void recollectState(StateBase state) {
    _currentZone?.states.add(state);
  }

  /// Attaches the instance to the stored states([StateBase]), and if the instance is null,
  /// it adds the stored states to the [BindingZone] parent.
  void bindInstanceToStates<T extends Object?>(T instance) {
    try {
      if (instance == null) {
        _parentZone?.states.addAll(states);
        return;
      }

      for (final state in states) {
        if (state is State && state.instanceBinded != null) {
          state._validateInstanceBinded();
        } else {
          state.bind(instance);
        }
      }
    } finally {
      _dispose();
    }
  }

  /// Sets the current object to its parent object, if it exists.
  void _dispose() {
    _currentZone = _currentZone?._parentZone;
  }
}
