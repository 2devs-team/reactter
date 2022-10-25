part of '../core.dart';

mixin ReactterNotifyManager {
  bool _isDisposed = false;
  bool _isUpdating = false;
  bool _shouldNotifyListeners = false;

  /// Increments when this is subscribes to `Lifecycle.willUpdate` or
  /// `Lifecycle.didUpdate` event.
  int _count = 0;
  int get _listenersCount => _count;
  set _listenersCount(int val) {
    _count = val;
    _shouldNotifyListeners = _listenersCount > 0;
  }

  /// Executes [fnUpdate], and notify the listeners about to update.
  @mustCallSuper
  void update(covariant Function fnUpdate) {
    assert(!_isDisposed, "You can update when it's been disposed");

    if (_isUpdating) return fnUpdate();

    _isUpdating = true;

    _notify(Lifecycle.willUpdate);
    fnUpdate();
    _notify(Lifecycle.didUpdate);

    _isUpdating = false;
  }

  /// Executes [fnUpdate], and notify the listeners about to update as async way.
  @mustCallSuper
  Future<void> updateAsync(covariant Function fnUpdate) async {
    assert(!_isDisposed, "You can update when it's been disposed");

    if (_isUpdating) return await fnUpdate();

    _isUpdating = true;

    await _notifyAsync(Lifecycle.willUpdate);
    await fnUpdate();
    await _notifyAsync(Lifecycle.didUpdate);

    _isUpdating = false;
  }

  /// Forces update and notifies to listeners that it did update
  @mustCallSuper
  void refresh() {
    assert(!_isDisposed, "You can refresh when it's been disposed");

    final _isUpdatingTmp = _isUpdating;
    _isUpdating = true;

    _notify(Lifecycle.didUpdate);

    if (_isUpdatingTmp) return;
    _isUpdating = false;
  }

  void _notify(Enum event) {
    if (_shouldNotifyListeners) {
      Reactter.emit(this, event, this);
    }
  }

  Future<void> _notifyAsync(Enum event) async {
    if (_shouldNotifyListeners) {
      Reactter.emitAsync(this, event, this);
    }
  }

  /// Called when this object is removed
  @mustCallSuper
  void dispose() {
    _dispose();
  }

  @mustCallSuper
  void _dispose() {
    _isDisposed = true;
  }
}
