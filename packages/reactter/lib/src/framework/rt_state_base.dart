part of '../internals.dart';

/// {@template reactter.rt_state_base}
/// A base class that implements the [IState] interface.
///
/// This class provides the basic functionality for managing the state.
/// {@endtemplate}
abstract class RtStateBase<E extends RtStateBase<E>> implements RtState {
  /// Debug assertion for registering a state object.
  ///
  /// This method is used to assert that a state object is being created within
  /// a binding zone. If the assertion fails, an [AssertionError] is thrown.
  static bool debugAssertRegistering<E>() {
    assert(() {
      final currentZone = BindingZone.currentZone;
      final isRegistering = currentZone != null &&
          (currentZone is BindingZone<E> || currentZone is BindingZone<E?>) &&
          !currentZone.isVerified;

      if (!isRegistering) {
        throw AssertionError(
          "The state($E) must be create within the BindingZone.\n"
          "You can use the 'Rt.createState' method or register as dependency "
          "using the dependency injection to ensure that the state is registered.",
        );
      }
      return true;
    }());

    return true;
  }

  // ignore: unused_field
  final _debugAssertRegistering = debugAssertRegistering<E>();

  bool _isRegistered = false;
  bool _isUpdating = false;

  /// A label used for debugging purposes.
  @override
  String? get debugLabel => null;

  /// A map containing information about state for debugging purposes.
  @override
  Map<String, dynamic> get debugInfo => {};

  /// The reference instance to the current state.
  @override
  Object? get boundInstance => _boundInstance;
  Object? _boundInstance;

  /// Returns `true` if the state has been disposed.
  @override
  bool get isDisposed => _isDisposed;
  bool _isDisposed = false;

  bool get _hasListeners =>
      eventHandler._hasListeners(this) ||
      (_boundInstance != null && eventHandler._hasListeners(_boundInstance));

  @override
  @protected
  @mustCallSuper
  void _register() {
    BindingZone.recollectState(this);

    if (_isRegistered) return;

    _notifyCreated();
    _isRegistered = true;
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

  /// {@macro reactter.istate.update}
  ///
  /// The [fnUpdate] must be a function without arguments(Function()).
  void update(covariant Function? fnUpdate) {
    assert(!_isDisposed, "Can't update when it's been disposed");
    assert(
      fnUpdate is Function(),
      "The fnUpdate must be a function without arguments",
    );

    if (!_hasListeners || _isUpdating) {
      fnUpdate?.call();
      _notifyUpdated();
      return;
    }

    _isUpdating = true;
    _notify(Lifecycle.willUpdate);
    fnUpdate?.call();
    _notify(Lifecycle.didUpdate);
    _notifyUpdated();
    _isUpdating = false;
  }

  @override
  @mustCallSuper
  void notify() {
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
    assert(!_isDisposed, "Can't dispose when it's been disposed");

    if (_boundInstance != null) {
      unbind();
    }

    eventHandler.emit(this, Lifecycle.deleted);
    eventHandler.offAll(this);

    if (_isDisposed) return;

    _notifyDisponsed();
    _isDisposed = true;
  }

  /// When the instance is destroyed, this object is dispose.
  void _onInstanceDeleted(_, __) => dispose();

  /// Notifies the listeners about the specified [event].
  /// If [Rt._isUntrackedRunning] is true, the notification is skipped.
  /// If [Rt._isBatchRunning] is true, the notification is deferred until the batch is completed.
  /// The [event] is emitted using [Rt.emit] for the current instance and [_boundInstance].
  void _notify(Enum event, [dynamic param]) {
    if (stateManagement._isUntrackedRunning) return;

    final emit = stateManagement._isBatchRunning
        ? stateManagement._emitDefferred
        : eventHandler.emit;

    final finalParam = param ?? this;

    emit(this, event, finalParam);

    if (_boundInstance == null) return;

    if (_boundInstance is RtStateBase &&
        !(_boundInstance as RtStateBase)._isDisposed) {
      return (_boundInstance as RtStateBase)._notify(event, finalParam);
    }

    emit(_boundInstance!, event, finalParam);
  }

  void _notifyCreated() {
    for (final observer in RtStateObserver._observers.toList(growable: false)) {
      observer.onStateCreated(this);
    }
  }

  void _notifyBound(Object instance) {
    for (final observer in RtStateObserver._observers.toList(growable: false)) {
      observer.onStateBound(this, instance);
    }
  }

  void _notifyUnbound() {
    for (final observer in RtStateObserver._observers.toList(growable: false)) {
      observer.onStateUnbound(this, _boundInstance!);
    }
  }

  void _notifyUpdated() {
    for (final observer in RtStateObserver._observers.toList(growable: false)) {
      observer.onStateUpdated(this);

      if (boundInstance is RtState) {
        observer.onStateUpdated(boundInstance as RtState);
      }
    }
  }

  void _notifyDisponsed() {
    for (final observer in RtStateObserver._observers.toList(growable: false)) {
      observer.onStateDisposed(this);
    }
  }
}
