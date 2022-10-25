part of '../core.dart';

mixin ReactterState on ReactterNotifyManager {
  bool _shouldNotifyInstance = false;

  /// The instance where it was created
  Object? _instance;

  /// When the instance is destroyed, this object is dispose.
  void _onInstanceDestroyed(_, __) => dispose();

  /// Attaches the given instance to the current scope.
  void _attachIt(Object inst) {
    if (_instance != null) {
      Reactter.off(_instance!, Lifecycle.destroyed, _onInstanceDestroyed);
    }

    Reactter.one(inst, Lifecycle.destroyed, _onInstanceDestroyed);

    _instance = inst;
    _shouldNotifyInstance = _instance != null;
  }

  /// Called when this object is removed
  @mustCallSuper
  void dispose() {
    super.dispose();

    if (_instance != null) {
      Reactter.off(_instance, Lifecycle.destroyed, _onInstanceDestroyed);
    }
    _instance = null;
  }

  void _notify(Enum event) {
    super._notify(event);

    if (_shouldNotifyInstance) {
      Reactter.emit(_instance!, event, this);
    }
  }

  Future<void> _notifyAsync(Enum event) async {
    await super._notifyAsync(event);

    if (_shouldNotifyInstance) {
      await Reactter.emitAsync(_instance!, event, this);
    }
  }

  void _dispose() {
    Reactter.dispose(this);
    super._dispose();
  }
}
