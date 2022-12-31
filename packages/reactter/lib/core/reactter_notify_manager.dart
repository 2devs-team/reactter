part of '../core.dart';

/// A mixin-class Provides the ability to notify listeners when the state changes.
mixin ReactterNotifyManager {
  bool _isDisposed = false;
  bool _isUpdating = false;
  bool _hasListeners = false;
  int _listenersCount = 0;

  /// Executes [fnUpdate], and notify the listeners about to update.
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

  /// Executes [fnUpdate], and notify the listeners about to update as async way.
  @mustCallSuper
  Future<void> updateAsync(covariant Function fnUpdate) async {
    assert(!_isDisposed, "You can update when it's been disposed");

    if (!_hasListeners || _isUpdating) {
      return await fnUpdate();
    }

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

  /// Called when this object is removed
  @mustCallSuper
  void dispose() => _isDisposed = true;

  void _notify(Enum event) => Reactter.emit(this, event, this);

  Future<void> _notifyAsync(Enum event) async {
    return Reactter.emitAsync(this, event, this);
  }

  void _addListener() {
    _listenersCount++;
    _hasListeners = true;
  }

  void _removeListener() {
    _listenersCount--;
    _hasListeners = _listenersCount == 0;
  }

  void _removeAllListeners() {
    _listenersCount = 0;
    _hasListeners = false;
  }
}
