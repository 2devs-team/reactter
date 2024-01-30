part of 'core.dart';

/// Represents an environment that Reactter uses for managing and
/// attaching instances to a collection of states.
@internal
class Zone {
  /// It's used to keep track of the current [Zone].
  static Zone? _currentZone;

  /// This is done to keep a reference to the previous [Zone] before
  /// creating a new instance.
  final _parentZone = _currentZone;

  /// It's used to store a collection of [StateBase].
  final states = Set<StateBase>();

  /// Returns the current [Zone].
  static Zone? get currentZone => _currentZone;

  Zone() {
    /// This is done to keep track of the current [ReactterZone] instance.
    _currentZone = this;
  }

  /// Takes a function as a parameter and automatically attaches an
  /// instance of the object returned by that function.
  static void autoAttachInstance(Object? Function() getInstance) {
    final zone = Zone();
    zone.attachInstance(getInstance());
  }

  /// Stores the state given from parameter.
  static void recollectState(StateBase state) {
    _currentZone?.states.add(state);
  }

  /// Attaches an instance to the stored states([StateBase]), and if the instance is null,
  /// it adds the stored states to the [Zone] parent.
  void attachInstance<T extends Object?>(T instance) {
    try {
      if (instance == null) {
        _parentZone?.states.addAll(states);
        return;
      }

      for (final state in states) {
        state.attachTo(instance);
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
