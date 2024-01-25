part of 'core.dart';

/// An abstract class that provides common functionality for managing
/// state in Reactter.
@internal
abstract class ReactterStateInternal implements ReactterStateBase {
  /// It's used to store a reference to an object instance
  /// that is attached to the state.
  Object? _instanceAttached;
  bool _isDisposed = false;
  bool _isUpdating = false;

  Object? get instanceAttached => _instanceAttached;
  bool get isDisposed => _isDisposed;
  bool get _hasListeners =>
      Reactter._hasListeners(this) ||
      (_instanceAttached != null && Reactter._hasListeners(_instanceAttached));

  @mustCallSuper
  void attachTo(Object instance) {
    assert(
      _instanceAttached == null,
      "Can't attach a new instance because an instance is already.\n"
      "Use `detachInstance` method, if you want to attach a new instance.",
    );

    Reactter.one(instance, Lifecycle.destroyed, _onInstanceDestroyed);
    _instanceAttached = instance;
  }

  @mustCallSuper
  void detachInstance() {
    if (_instanceAttached == null) return;

    Reactter.off(_instanceAttached!, Lifecycle.destroyed, _onInstanceDestroyed);
    _instanceAttached = null;
  }

  @mustCallSuper
  void update(covariant Function fnUpdate) {
    assert(!_isDisposed, "You can update when it's been disposed");

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
    assert(!_isDisposed, "You can refresh when it's been disposed");

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

    if (_instanceAttached != null) {
      Reactter.off(
        _instanceAttached!,
        Lifecycle.destroyed,
        _onInstanceDestroyed,
      );

      _instanceAttached = null;
    }

    Reactter.offAll(this);
  }

  /// When the instance is destroyed, this object is dispose.
  void _onInstanceDestroyed(_, __) => dispose();

  /// Notifies the listeners about the specified [event].
  /// If [Reactter._isUntrackedRunning] is true, the notification is skipped.
  /// If [Reactter._isBatchRunning] is true, the notification is deferred until the batch is completed.
  /// The [event] is emitted using [Reactter.emit] for the current instance and [_instanceAttached].
  void _notify(Enum event) {
    if (Reactter._isUntrackedRunning) return;

    final emit =
        Reactter._isBatchRunning ? Reactter._emitDefferred : Reactter.emit;

    emit(this, event, this);

    if (_instanceAttached != null) {
      emit(_instanceAttached!, event, this);
    }
  }
}
