part of 'core.dart';

/// An abstract class that provides common functionality for managing
/// state in Reactter.
@internal
abstract class State implements StateBase {
  bool _isUpdating = false;

  /// The reference instance to the current state.
  Object? get instanceBinded => _instanceBinded;
  Object? _instanceBinded;

  /// Returns `true` if the state has been disposed.
  bool get isDisposed => _isDisposed;
  bool _isDisposed = false;

  bool get _hasListeners =>
      eventHandler._hasListeners(this) ||
      (_instanceBinded != null && eventHandler._hasListeners(_instanceBinded));

  @mustCallSuper
  @override
  void bind(Object instance) {
    assert(!_isDisposed, "Can't bind when it's been disposed");
    assert(
      _instanceBinded == null,
      "Can't bind a new instance because an instance is already.\n"
      "Use `detachInstance` method, if you want to bind a new instance.",
    );

    eventHandler.one(instance, Lifecycle.destroyed, _onInstanceDestroyed);
    _instanceBinded = instance;

    if (BindingZone.currentZone == null) _validateInstanceBinded();
  }

  @override
  @mustCallSuper
  void unbind() {
    assert(!_isDisposed, "Can't unbind when it's been disposed");

    if (_instanceBinded == null) return;

    eventHandler.off(
      _instanceBinded!,
      Lifecycle.destroyed,
      _onInstanceDestroyed,
    );
    _instanceBinded = null;
  }

  @override
  @mustCallSuper
  void update(covariant Function fnUpdate) {
    assert(!_isDisposed, "Can't update when it's been disposed");

    if (!_hasListeners || _isUpdating) {
      fnUpdate();
      return;
    }

    _isUpdating = true;
    _notify(Lifecycle.willUpdate);
    fnUpdate();
    _notify(Lifecycle.didUpdate);
    _isUpdating = false;
  }

  @override
  @mustCallSuper
  void refresh() {
    assert(!_isDisposed, "Can't refresh when it's been disposed");

    if (!_hasListeners || _isUpdating) {
      return _notify(Lifecycle.didUpdate);
    }

    _isUpdating = true;
    _notify(Lifecycle.didUpdate);
    _isUpdating = false;
  }

  @override
  @mustCallSuper
  void dispose() {
    _isDisposed = true;

    if (_instanceBinded != null) {
      eventHandler.off(
        _instanceBinded!,
        Lifecycle.destroyed,
        _onInstanceDestroyed,
      );

      _instanceBinded = null;
    }

    eventHandler.offAll(this);
  }

  void _validateInstanceBinded() {
    if (instanceInjection.isRegistered(instanceBinded)) return;

    logger.log(
      "The instance binded($instanceBinded) to $this is not in Reactter's context and cannot be disposed automatically.\n"
      "You can solve this problem in two ways:\n"
      "1. Call the 'dispose' method manually when $this is no longer needed.\n"
      "2. Create $instanceBinded using the instance manager methods.\n"
      "**Ignore this message if you are sure that it will be disposed.**",
      level: LogLevel.warning,
    );
  }

  /// When the instance is destroyed, this object is dispose.
  void _onInstanceDestroyed(_, __) => dispose();

  /// Notifies the listeners about the specified [event].
  /// If [Reactter._isUntrackedRunning] is true, the notification is skipped.
  /// If [Reactter._isBatchRunning] is true, the notification is deferred until the batch is completed.
  /// The [event] is emitted using [Reactter.emit] for the current instance and [_instanceBinded].
  void _notify(Enum event) {
    if (stateManagment._isUntrackedRunning) return;

    final emit = stateManagment._isBatchRunning
        ? stateManagment._emitDefferred
        : eventHandler.emit;

    emit(this, event, this);

    if (_instanceBinded == null) return;

    emit(_instanceBinded!, event, this);
  }
}
