part of '../internals.dart';

/// Represents an environment that Reactter uses for managing and
/// attaching instances to a collection of states.
@internal
class BindingZone<T extends Object?> {
  /// It's used to keep track of the current [BindingZone].
  static BindingZone? _currentZone;

  /// This is done to keep a reference to the previous [BindingZone] before
  /// creating a new instance.
  final _parentZone = _currentZone;

  /// It's used to store a collection of [IState].
  final _states = <IState>{};

  /// Returns the current [BindingZone].
  static BindingZone? get currentZone => _currentZone;

  /// The verification status indicates whether the object is verified or not.
  ///
  /// Note: The [_isVerified] variable is set to `true` within a finally block,
  /// ensuring it is always updated.
  bool _isVerified = false;
  get isVerified {
    try {
      return _isVerified;
    } finally {
      _isVerified = true;
    }
  }

  BindingZone() {
    /// This is done to keep track of the current [BindingZone] instance.
    _currentZone = this;
  }

  /// {@template reactter.binding_zone.auto_binding}
  /// Automatically binds the instance to the stored states([IState]).
  /// If the instance is null, it adds the stored states to the [BindingZone] parent.
  /// {@endtemplate}
  static T autoBinding<T extends Object?>(
    T Function() getInstance, [
    Object? boundInstance,
  ]) {
    final zone = BindingZone<T?>();
    final instance = getInstance();

    final instanceToBind = boundInstance ?? instance;

    zone._bindInstanceToStates(instanceToBind);

    return instance;
  }

  /// Stores the state given from parameter.
  static void recollectState(IState state) {
    _currentZone?._states.add(state);
  }

  /// Attaches the instance to the stored states([IState]), and if the instance is null,
  /// it adds the stored states to the [BindingZone] parent.
  E _bindInstanceToStates<E extends Object?>(E instance) {
    try {
      if (instance == null) {
        _parentZone?._states.addAll(_states);
        return instance;
      }

      for (final state in _states.toList(growable: false)) {
        if (state != instance && state.boundInstance == null) {
          state.bind(instance);
        }
      }

      return instance;
    } finally {
      _dispose();
      if (instance is IState) instance._register();
    }
  }

  /// Sets the current object to its parent object, if it exists.
  void _dispose() {
    _currentZone = _currentZone?._parentZone;
  }
}
