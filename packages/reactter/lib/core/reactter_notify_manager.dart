part of '../core.dart';

enum Lifecycle {
  /// This event is triggered when the [ReactterInstanceManager] registers the instance.
  registered,

  /// This event is triggered when the [ReactterInstanceManager] unregisters the instance.
  unregistered,

  /// This event is triggered when the [ReactterInstanceManager] initializes the instance.
  initialized,

  /// This event(exclusive to `flutter_reactter`) happens when the instance is going to be mounted in the widget tree.
  willMount,

  /// This event(exclusive to `flutter_reactter`) happens after the instance has been successfully mounted in the widget tree.
  didMount,

  /// This event is triggered anytime the instance's state is about to be updated. The event parameter is a [ReactterState].
  willUpdate,

  /// This event is triggered anytime the instance's state has been updated. The event parameter is a [ReactterState].
  didUpdate,

  /// This event(exclusive to `flutter_reactter`) happens when the instance is about to be unmounted from the widget tree.
  willUnmount,

  /// This event is triggered when the [ReactterInstanceManager] destroys the instance.
  destroyed,
}

/// A mixin-class that provides methods for notifying listeners
/// about updates to an object's state.
///
/// It includes methods for updating the state, refreshing the state,
/// disposing of the object, and adding/removing listeners.
///
/// It also includes methods for notifying listeners
/// synchronously and asynchronously.
mixin ReactterNotifyManager {
  bool _isDisposed = false;
  bool _isUpdating = false;
  bool get _hasListeners => Reactter._hasListeners(this);

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
}
