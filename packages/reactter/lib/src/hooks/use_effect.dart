part of 'hooks.dart';

/// {@template reactter.use_effect}
/// A [RtHook] that manages `side-effect`.
///
///
/// The `side-effect` logic into the [callback] function is executed
/// when [dependencies] of [RtState] argument has changes
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
/// [RtState] argument has changes or [instance] trigger
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
/// You can also use the [AutoDispatchEffect] mixin to execute the effect
/// on initialization:
///
/// ```dart
/// class AppController with AutoDispatchEffect {
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
/// by dependency injection, this instance will be binded to it automatically.
///
/// **NOTE**: The [UseEffect] instance will be disposed automatically when
/// the instance binded is destroyed by dependency injection.
///
/// If the [UseEffect] instance didn't have an instance binded or
/// the instance binded is not created by dependency injection,
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
/// * [RtState], it receives as dependencies.
/// {@endtemplate}
class UseEffect extends RtHook {
  @protected
  @override
  final $ = RtHook.$register;

  bool _isDispatched = false;
  Function? _cleanupCallback;
  bool _isUpdating = false;

  /// Function to control side-effect and effect cleanup.
  final Function callback;

  /// It's used to store the states as dependencies of [UseEffect].
  final List<RtState> dependencies;

  final String? _debugLabel;
  @override
  String? get debugLabel => _debugLabel ?? super.debugLabel;
  @override
  Map<String, dynamic> get debugInfo => {
        'dependencies': dependencies,
      };

  /// {@macro reactter.use_effect}
  UseEffect(
    this.callback,
    this.dependencies, {
    String? debugLabel,
  }) : _debugLabel = debugLabel {
    if (BindingZone.currentZone != null) return;

    _watchDependencies();
  }

  /// {@macro reactter.use_effect}
  UseEffect.runOnInit(
    this.callback,
    this.dependencies, {
    String? debugLabel,
  }) : _debugLabel = debugLabel {
    _runCallback(this, this);
    _isUpdating = false;
    _isDispatched = true;

    if (BindingZone.currentZone != null) return;

    _watchDependencies();
  }

  @override
  void bind(Object instance) {
    final shouldListen = boundInstance == null;

    super.bind(instance);

    if (!shouldListen) return;

    _watchInstanceAttached();

    if (!_isDispatched && boundInstance is AutoDispatchEffect) {
      _runCleanupAndUnwatchDependencies(boundInstance);
      _runCallbackAndWatchDependencies(boundInstance);
      return;
    }

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
    Rt.on(
      boundInstance!,
      Lifecycle.didMount,
      _runCallbackAndWatchDependencies,
    );
    Rt.on(
      boundInstance!,
      Lifecycle.willUnmount,
      _runCleanupAndUnwatchDependencies,
    );
  }

  void _unwatchInstanceAttached() {
    if (boundInstance == null) return;

    Rt.off(
      boundInstance!,
      Lifecycle.didMount,
      _runCallbackAndWatchDependencies,
    );
    Rt.off(
      boundInstance!,
      Lifecycle.willUnmount,
      _runCleanupAndUnwatchDependencies,
    );
  }

  void _runCallbackAndWatchDependencies([inst, param]) {
    _runCallback(inst, param);
    _watchDependencies();
  }

  void _runCleanupAndUnwatchDependencies([inst, param]) {
    _runCleanup(inst, param);
    _unwatchDependencies();
  }

  void _watchDependencies() {
    _unwatchDependencies();

    for (final dependency in dependencies.toList(growable: false)) {
      Rt.on(dependency, Lifecycle.willUpdate, _runCleanup);
      Rt.on(dependency, Lifecycle.didUpdate, _runCallback);
    }
  }

  void _unwatchDependencies() {
    for (final dependency in dependencies.toList(growable: false)) {
      Rt.off(dependency, Lifecycle.willUpdate, _runCleanup);
      Rt.off(dependency, Lifecycle.didUpdate, _runCallback);
    }
  }

  void _runCallback(inst, param) {
    if (_isUpdating) return;

    _isUpdating = true;

    _runCleanup(inst, param);

    try {
      final cleanupCallback = callback();

      if (cleanupCallback is Function) {
        _cleanupCallback = cleanupCallback;
      }
    } catch (error) {
      assert(() {
        throw AssertionError(
          'An error occurred while executing the effect in $this${debugLabel != null ? '($debugLabel)' : ''}.\n'
          'The error thrown was:\n'
          '  $error\n',
        );
      }());

      rethrow;
    } finally {
      _isUpdating = false;
    }
  }

  void _runCleanup(inst, param) {
    try {
      _cleanupCallback?.call();
    } catch (error) {
      assert(() {
        throw AssertionError(
          'An error occurred while executing the cleanup effect in $this${debugLabel != null ? '($debugLabel)' : ''}.\n'
          'The error thrown was:\n'
          '  $error\n',
        );
      }());

      rethrow;
    } finally {
      _cleanupCallback = null;
    }
  }
}

/// A mixin to execute the effect on initialization.
abstract class AutoDispatchEffect {}
