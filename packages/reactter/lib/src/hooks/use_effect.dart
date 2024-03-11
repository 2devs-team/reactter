part of 'hooks.dart';

/// {@template use_effect}
/// A [ReactterHook] that manages `side-effect`.
///
///
/// The `side-effect` logic into the [callback] function is executed
/// when [dependencies] of [ReactterState] argument has changes
/// or [instance] trigger [LifeCycle.didMount] event:
///
/// ```dart
/// UseEffect(
///   () {
///     print("Executed by state changed or 'didMount' event");
///   },
///   [state],
/// );
/// ```
///
/// The [callback] function can return a cleanup function to manage the `effect
/// cleanup`.
/// The cleanup function is executed before the [dependencies] of
/// [ReactterState] argument has changes or [instance] trigger
/// [LifeCycle.willUnmount] event:
///
/// ```dart
/// UseEffect(
///   () {
///     print("Executed by state changed or 'didMount' event");
///
///     return () {
///       print("Executed before state changed or 'willUnmount' event");
///     };
///   },
///   [state],
/// );
/// ```
///
/// **RECOMMENDED**: Use it on class constructor:
///
/// ```dart
/// class AppController {
///   final state = UseState(0);
///
///   AppController() {
///     UseEffect(
///       () {
///         print("Executed by state changed or 'didMount' event");
///
///         return () {
///           print("Executed before state changed or 'willUnmount' event");
///         };
///       },
///       [state],
///     );
///
///     Timer.periodic(Duration(seconds: 1), (_) => state.value++);
///   }
/// }
/// ```
///
/// If you want to execute the effect on initialization,
/// you can use [UseEffect.runOnInit]:
///
/// ```dart
/// UseEffect.runOnInit(
///   () {
///     print("Executed on initialization and 'didMount' event");
///   },
///   [],
/// );
/// ```
///
/// You can also use the [DispatchEffect] mixin to execute the effect
/// on initialization:
///
/// ```dart
/// class AppController with DispatchEffect {
///   AppController() {
///     UseEffect(
///       () {
///         print("Executed on initialization and 'didMount' event");
///       },
///       [],
///     );
///   }
/// }
/// ```
///
/// Use [bind] method to bind the instance, if you want to execute the effect
/// within the instance context:
///
/// ```dart
/// UseEffect(
///   () {
///     print("Executed by `didMount` event of 'useController' instance");
///   },
///   [],
/// ).bind(useController);
/// ```
///
/// **NOTE**: A [UseEffect] instance can only be binded to one instance at a time.
/// When create a new instance of [UseEffect] on the instance that is created
/// by instance manager, this instance will be binded to it automatically.
///
/// **NOTE**: The [UseEffect] instance will be disposed automatically when
/// the instance binded is destroyed by instance manager.
///
/// If the [UseEffect] instance didn't have an instance binded or
/// the instance binded is not created by instance manager,
/// you must dispose it manually, using the [dispose] method:
///
/// ```dart
/// final useEffect = UseEffect(
///   () {
///     print("Executed by state changed");
///   },
///   [state],
/// );
///
/// [...]
///
/// useEffect.dispose();
/// ```
///
/// See also:
///
/// * [ReactterState], it receives as dependencies.
/// {@endtemplate}
class UseEffect extends ReactterHook {
  @protected
  @override
  final $ = ReactterHook.$register;

  bool _isDispatched = false;
  Function? _cleanupCallback;
  bool _isUpdating = false;

  /// Function to control side-effect and effect cleanup.
  final Function callback;

  /// It's used to store the states as dependencies of [UseEffect].
  final List<ReactterState> dependencies;

  /// {@macro use_effect}
  UseEffect(this.callback, this.dependencies) {
    if (BindingZone.currentZone != null) return;

    _watchDependencies();
  }

  /// {@macro use_effect}
  UseEffect.runOnInit(this.callback, this.dependencies) : super() {
    _runCallback(this, this);
    _isUpdating = false;
    _isDispatched = true;

    if (BindingZone.currentZone != null) return;

    _watchDependencies();
  }

  @override
  void bind(Object instance) {
    final shouldListen = instanceBinded == null;

    super.bind(instance);

    if (!shouldListen) return;

    _watchInstanceAttached();

    if (!_isDispatched && instanceBinded is DispatchEffect) {
      _runCleanupAndUnwatchDependencies(instanceBinded);
      _runCallbackAndWatchDependencies(instanceBinded);
      return;
    }

    _unwatchDependencies();
    _watchDependencies();
  }

  @override
  void unbind() {
    _unwatchInstanceAttached();
    _unwatchDependencies();

    super.unbind();
  }

  @override
  void dispose() {
    _cleanupCallback = null;

    _unwatchInstanceAttached();
    _unwatchDependencies();

    super.dispose();
  }

  void _watchInstanceAttached() {
    Reactter.on(
      instanceBinded!,
      Lifecycle.didMount,
      _runCallbackAndWatchDependencies,
    );
    Reactter.on(
      instanceBinded!,
      Lifecycle.willUnmount,
      _runCleanupAndUnwatchDependencies,
    );
  }

  void _unwatchInstanceAttached() {
    Reactter.off(
      instanceBinded!,
      Lifecycle.didMount,
      _runCallbackAndWatchDependencies,
    );
    Reactter.off(
      instanceBinded!,
      Lifecycle.willUnmount,
      _runCleanupAndUnwatchDependencies,
    );
  }

  void _runCallbackAndWatchDependencies([_, __]) {
    _runCallback(_, __);
    _watchDependencies();
  }

  void _runCleanupAndUnwatchDependencies([_, __]) {
    _runCleanup(_, __);
    _unwatchDependencies();
  }

  void _watchDependencies() {
    for (final dependency in dependencies) {
      Reactter.on(dependency, Lifecycle.willUpdate, _runCleanup);
      Reactter.on(dependency, Lifecycle.didUpdate, _runCallback);
    }
  }

  void _unwatchDependencies() {
    for (final dependency in dependencies) {
      Reactter.off(dependency, Lifecycle.willUpdate, _runCleanup);
      Reactter.off(dependency, Lifecycle.didUpdate, _runCallback);
    }
  }

  void _runCallback(_, __) {
    if (_isUpdating) return;

    _isUpdating = true;

    try {
      _cleanupCallback?.call();
    } finally {
      _cleanupCallback = null;
    }

    final cleanupCallback = callback();

    if (cleanupCallback is Function) {
      _cleanupCallback = cleanupCallback;
    }
  }

  void _runCleanup(_, __) {
    if (!_isUpdating) return;

    _isUpdating = false;

    try {
      _cleanupCallback?.call();
    } finally {
      _cleanupCallback = null;
    }
  }
}

abstract class DispatchEffect {}
