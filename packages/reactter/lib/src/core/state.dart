part of 'core.dart';

/// An abstract class that provides common functionality for managing
/// state in Reactter.
@internal
abstract class State implements StateBase {
  bool _isUpdating = false;

  /// The reference instance to the current state.
  Object? get bindedTo => _bindedTo;
  Object? _bindedTo;

  /// Returns `true` if the state has been disposed.
  bool get isDisposed => _isDisposed;
  bool _isDisposed = false;

  bool get _hasListeners =>
      eventManager._hasListeners(this) ||
      (_bindedTo != null && eventManager._hasListeners(_bindedTo));

  @mustCallSuper
  void bind(Object instance) {
    assert(!_isDisposed, "Can't bind when it's been disposed");
    assert(
      _bindedTo == null,
      "Can't bind a new instance because an instance is already.\n"
      "Use `detachInstance` method, if you want to bind a new instance.",
    );

    eventManager.one(instance, Lifecycle.destroyed, _onInstanceDestroyed);
    _bindedTo = instance;
  }

  @mustCallSuper
  void unbind() {
    assert(!_isDisposed, "Can't unbind when it's been disposed");

    if (_bindedTo == null) return;

    eventManager.off(_bindedTo!, Lifecycle.destroyed, _onInstanceDestroyed);
    _bindedTo = null;
  }

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

  @mustCallSuper
  void dispose() {
    _isDisposed = true;

    if (_bindedTo != null) {
      eventManager.off(
        _bindedTo!,
        Lifecycle.destroyed,
        _onInstanceDestroyed,
      );

      _bindedTo = null;
    }

    eventManager.offAll(this);
  }

  /// When the instance is destroyed, this object is dispose.
  void _onInstanceDestroyed(_, __) => dispose();

  /// Notifies the listeners about the specified [event].
  /// If [Reactter._isUntrackedRunning] is true, the notification is skipped.
  /// If [Reactter._isBatchRunning] is true, the notification is deferred until the batch is completed.
  /// The [event] is emitted using [Reactter.emit] for the current instance and [_bindedTo].
  void _notify(Enum event) {
    if (stateManager._isUntrackedRunning) return;

    final emit = stateManager._isBatchRunning
        ? stateManager._emitDefferred
        : eventManager.emit;

    emit(this, event, this);

    if (_bindedTo == null) return;

    emit(_bindedTo!, event, this);

    if (_bindedTo is! LifecycleObserver) return;

    if (event == Lifecycle.willUpdate) {
      (_bindedTo as LifecycleObserver).onWillUpdate(this);
    } else if (event == Lifecycle.didUpdate) {
      (_bindedTo as LifecycleObserver).onDidUpdate(this);
    }
  }
}
