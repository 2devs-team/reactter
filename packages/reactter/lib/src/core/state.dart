part of 'core.dart';

/// An abstract class that provides common functionality for managing
/// state in Reactter.
@internal
abstract class State implements StateBase {
  bool _isUpdating = false;

  /// A label used for debugging purposes.
  String get debugLabel => "$runtimeType[$hashCode]";

  /// A map containing properties used for debugging purposes.
  Map<String, dynamic> get debugProperties => {};

  /// The reference instance to the current state.
  Object? get boundInstance => _boundInstance;
  Object? _boundInstance;

  /// Returns `true` if the state has been disposed.
  bool get isDisposed => _isDisposed;
  bool _isDisposed = false;

  bool get _hasListeners =>
      eventHandler._hasListeners(this) ||
      (_boundInstance != null && eventHandler._hasListeners(_boundInstance));

  State() {
    BindingZone.recollectState(this);
    _notifyCreated();
  }

  @mustCallSuper
  @override
  void bind(Object instance) {
    assert(!_isDisposed, "Can't bind when it's been disposed");
    assert(
      _boundInstance == null,
      "Can't bind a new instance because an instance is already.\n"
      "You must unbind the current instance before binding a new one.",
    );

    eventHandler.one(instance, Lifecycle.deleted, _onInstanceDeleted);
    _boundInstance = instance;

    if (BindingZone.currentZone == null) _validateInstanceBinded();

    _notifyBound(instance);
  }

  @override
  @mustCallSuper
  void unbind() {
    assert(!_isDisposed, "Can't unbind when it's been disposed");

    if (_boundInstance == null) return;

    _notifyUnbound();

    eventHandler.off(_boundInstance!, Lifecycle.deleted, _onInstanceDeleted);
    _boundInstance = null;
  }

  @override
  @mustCallSuper
  void update(covariant Function fnUpdate) {
    assert(!_isDisposed, "Can't update when it's been disposed");

    if (!_hasListeners || _isUpdating) {
      fnUpdate();
      _notifyUpdated();
      return;
    }

    _isUpdating = true;
    _notify(Lifecycle.willUpdate);
    fnUpdate();
    _notify(Lifecycle.didUpdate);
    _notifyUpdated();
    _isUpdating = false;
  }

  @override
  @mustCallSuper
  void refresh() {
    assert(!_isDisposed, "Can't refresh when it's been disposed");

    if (!_hasListeners || _isUpdating) {
      _notifyUpdated();
      return;
    }

    _isUpdating = true;
    _notify(Lifecycle.didUpdate);
    _notifyUpdated();
    _isUpdating = false;
  }

  @override
  @mustCallSuper
  void dispose() {
    _isDisposed = true;

    if (_boundInstance != null) {
      eventHandler.off(_boundInstance!, Lifecycle.deleted, _onInstanceDeleted);
      _boundInstance = null;
    }

    eventHandler.offAll(this);

    _notifyDisponsed();
  }

  void _validateInstanceBinded() {
    if (dependencyInjection.isActive(boundInstance)) return;

    logger.log(
      "The instance binded($boundInstance) to $this is not in Reactter's context and cannot be disposed automatically.\n"
      "You can solve this problem in two ways:\n"
      "1. Call the 'dispose' method manually when $this is no longer needed.\n"
      "2. Create $boundInstance using the dependency injection methods.\n"
      "**Ignore this message if you are sure that it will be disposed.**",
      level: LogLevel.warning,
    );
  }

  /// When the instance is destroyed, this object is dispose.
  void _onInstanceDeleted(_, __) => dispose();

  /// Notifies the listeners about the specified [event].
  /// If [Rt._isUntrackedRunning] is true, the notification is skipped.
  /// If [Rt._isBatchRunning] is true, the notification is deferred until the batch is completed.
  /// The [event] is emitted using [Rt.emit] for the current instance and [_boundInstance].
  void _notify(Enum event) {
    if (stateManagment._isUntrackedRunning) return;

    final emit = stateManagment._isBatchRunning
        ? stateManagment._emitDefferred
        : eventHandler.emit;

    emit(this, event, this);

    if (_boundInstance != null) {
      emit(_boundInstance!, event, this);
    }
  }

  void _notifyCreated() {
    for (final observer in StateObserver._observers) {
      observer.onStateCreated(this);
    }
  }

  void _notifyBound(Object instance) {
    for (final observer in StateObserver._observers) {
      observer.onStateBound(this, instance);
    }
  }

  void _notifyUnbound() {
    for (final observer in StateObserver._observers) {
      observer.onStateUnbound(this, _boundInstance!);
    }
  }

  void _notifyUpdated() {
    for (final observer in StateObserver._observers) {
      observer.onStateUpdated(this);
    }

    if (boundInstance is State) {
      for (final observer in StateObserver._observers) {
        observer.onStateUpdated(boundInstance as State);
      }
    }
  }

  void _notifyDisponsed() {
    for (final observer in StateObserver._observers) {
      observer.onStateDisposed(this);
    }
  }
}
