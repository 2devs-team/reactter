part of '../core.dart';

/// A mixin-class that adds state management features to classes that use it.
///
/// It provides methods for attaching and detaching an object instance to
/// the state, notifying listeners of state changes, and disposing of the state
/// object when it is no longer needed.
abstract class ReactterState {
  /// The instance where it was created
  Object? _instance;
  bool _isDisposed = false;
  bool _isUpdating = false;
  bool get _hasListeners =>
      Reactter._hasListeners(this) ||
      (_instance != null && Reactter._hasListeners(_instance));

  /// Adds the current state to a list if instances of the Reactter class are being built.
  @mustCallSuper
  void createState() {
    if (Reactter._instancesBuilding) {
      Reactter._statesRecollected.add(this);
    }
  }

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
  void dispose() {
    _isDisposed = true;

    if (_instance != null) {
      Reactter.off(_instance, Lifecycle.destroyed, _onInstanceDestroyed);
    }
    _instance = null;

    Reactter.dispose(this);
  }

  /// When the instance is destroyed, this object is dispose.
  void _onInstanceDestroyed(_, __) => dispose();

  void _notify(Enum event) {
    Reactter.emit(this, event, this);

    if (_instance != null) {
      Reactter.emit(_instance!, event, this);
    }
  }

  Future<void> _notifyAsync(Enum event) async {
    await Reactter.emitAsync(this, event, this);

    if (_instance != null) {
      await Reactter.emitAsync(_instance!, event, this);
    }
  }
}
