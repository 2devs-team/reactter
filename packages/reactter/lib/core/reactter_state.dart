part of '../core.dart';

/// A mixin-class to provides features of a state
mixin ReactterState on ReactterNotifyManager {
  /// The instance where it was created
  Object? _instance;

  bool get _hasListeners {
    return super._hasListeners ||
        (_instance is ReactterNotifyManager &&
            (_instance as ReactterNotifyManager)._hasListeners);
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

  /// Attaches the given instance to the current scope.
  void _attachIt(Object inst) {
    if (_instance != null) {
      Reactter.off(_instance!, Lifecycle.destroyed, _onInstanceDestroyed);
    }

    Reactter.one(inst, Lifecycle.destroyed, _onInstanceDestroyed);

    _instance = inst;
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
