part of '../framework.dart';

/// A abstract-class that adds state management features to classes that use it.
///
/// It provides methods for attaching and detaching an object instance to
/// the state, notifying listeners of state changes, and disposing of the state
/// object when it is no longer needed.
abstract class ReactterState {
  static Object? _instanceToAttach;

  /// The instance where it was created
  Object? _instanceAttached;
  bool _isDisposed = false;
  bool _isUpdating = false;

  Object? get instanceAttached => _instanceAttached;
  bool get isDisposed => _isDisposed;
  bool get _hasListeners =>
      Reactter._hasListeners(this) ||
      (_instanceAttached != null && Reactter._hasListeners(_instanceAttached));

  /// Adds the current state to a list if instances of the Reactter class are being built.
  @mustCallSuper
  void createState() {
    if (_instanceToAttach != null) {
      attachTo(_instanceToAttach!);
    }

    if (Reactter.isInstancesBuilding) {
      Reactter._statesRecollected.add(this);
    }
  }

  /// Attaches an object instance to this state.
  @mustCallSuper
  void attachTo(Object instance) {
    // if (_instanceAttached != null) return;
    assert(
      _instanceAttached == null,
      "Can't attach a new instance because an instance is already.\n"
      "Use `detachInstance` method, if you want to attach a new instance.",
    );

    Reactter.one(instance, Lifecycle.destroyed, _onInstanceDestroyed);
    _instanceAttached = instance;
  }

  /// Detaches an object instance to this state.
  @mustCallSuper
  void detachInstance() {
    if (_instanceAttached == null) return;

    Reactter.off(_instanceAttached, Lifecycle.destroyed, _onInstanceDestroyed);
    _instanceAttached = null;
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

    if (_instanceAttached != null) {
      Reactter.off(
        _instanceAttached,
        Lifecycle.destroyed,
        _onInstanceDestroyed,
      );

      _instanceAttached = null;
    }

    Reactter.dispose(this);
  }

  /// When the instance is destroyed, this object is dispose.
  void _onInstanceDestroyed(_, __) => dispose();

  void _notify(Enum event) {
    Reactter.emit(this, event, this);

    if (_instanceAttached != null) {
      Reactter.emit(_instanceAttached!, event, this);
    }
  }

  Future<void> _notifyAsync(Enum event) async {
    await Reactter.emitAsync(this, event, this);

    if (_instanceAttached != null) {
      await Reactter.emitAsync(_instanceAttached!, event, this);
    }
  }
}
