part of 'core.dart';

/// Represents an environment that Reactter uses for managing and
/// attaching instances to a collection of states.
@internal
class ReactterZone {
  /// It's used to keep track of the current [ReactterZone].
  static ReactterZone? _current;

  /// This is done to keep a reference to the previous [ReactterZone] before
  /// creating a new instance.
  final _parent = _current;

  /// It's used to store a collection of [ReactterState].
  final states = Set<ReactterStateBase>();

  /// Returns the current [ReactterZone].
  static ReactterZone? get current => _current;

  ReactterZone() {
    /// This is done to keep track of the current [ReactterZone] instance.
    _current = this;
  }

  /// Takes a function as a parameter and automatically attaches an
  /// instance of the object returned by that function.
  static void autoAttachInstance(Object? Function() getInstance) {
    final zone = ReactterZone();
    zone.attachInstance(getInstance());
  }

  /// Stores the state given from parameter.
  static void recollectState(ReactterStateBase state) {
    _current?.states.add(state);
  }

  /// Attaches an instance to the stored states([ReactterState]), and if the instance is null,
  /// it adds the stored states to the [ReactterZone] parent.
  void attachInstance<T extends Object?>(T instance) {
    try {
      if (instance == null) {
        _parent?.states.addAll(states);
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
    _current = _current?._parent;
  }
}
