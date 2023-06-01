part of '../core.dart';

/// A mixin-class that adds state management features to classes that use it.
///
/// It provides methods for attaching and detaching an object instance to
/// the state, notifying listeners of state changes, and disposing of the state
/// object when it is no longer needed.
mixin ReactterState on ReactterNotifyManager {
  /// The instance where it was created
  Object? _instance;

  bool get _hasListeners {
    return super._hasListeners ||
        (_instance != null && Reactter._hasListeners(_instance));
  }

  /// Adds the current state to a list if instances of the Reactter class are being built.
  @mustCallSuper
  void createState() {
    if (Reactter._instancesBuilding) {
      Reactter._statesRecollected.add(this);
    }
  }

  /// Called when this object is removed
  @mustCallSuper
  void dispose() {
    super.dispose();

    if (_instance != null) {
      Reactter.off(_instance, Lifecycle.destroyed, _onInstanceDestroyed);
    }
    _instance = null;

    Reactter.dispose(this);
  }

  /// When the instance is destroyed, this object is dispose.
  void _onInstanceDestroyed(_, __) => dispose();

  /// Attaches an object instance to this state.
  @mustCallSuper
  void attachTo(Object instance) {
    if (_instance != null && _instance != instance) detachTo(_instance!);

    Reactter.one(instance, Lifecycle.destroyed, _onInstanceDestroyed);

    _instance = instance;
  }

  /// Detaches an object instance to this state.
  @mustCallSuper
  void detachTo(Object instance) {
    Reactter.off(instance, Lifecycle.destroyed, _onInstanceDestroyed);

    _instance = null;
  }

  void _notify(Enum event) {
    super._notify(event);

    if (_instance != null) {
      Reactter.emit(_instance!, event, this);
    }
  }

  Future<void> _notifyAsync(Enum event) async {
    await super._notifyAsync(event);

    if (_instance != null) {
      Reactter.emitAsync(_instance!, event, this);
    }
  }
}
