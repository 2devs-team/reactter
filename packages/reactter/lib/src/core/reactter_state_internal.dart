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

    final _isUpdatingTmp = _isUpdating;
    _isUpdating = true;

    _notify(Lifecycle.didUpdate);

    if (_isUpdatingTmp) return;
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

  void _notify(Enum event) {
    Reactter.emit(this, event, this);

    if (_instanceAttached != null) {
      Reactter.emit(_instanceAttached!, event, this);
    }
  }
}
