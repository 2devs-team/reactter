part of 'hooks.dart';

/// {@template use_effect}
/// A [ReactterHook] that manages side-effect.
///
/// The side-effect logic into the [callback] function is executed
/// when [dependencies] of [ReactterState] argument has changes
/// or [instance] trigger [LifeCycle.didMount] event.
///
/// ```dart
/// UseEffect(() {
///   print("Execute by state changed or 'didMount' event");
/// }, [state], this);
/// ```
///
/// If the [callback] returns a function,
/// then [UseEffect] considers this as an `effect cleanup`.
///
/// The `effect cleanup` callback is executed, before [callback] is called
/// or [context] trigger [LifeCycle.willUnmount] event:
///
/// ```dart
/// UseEffect(() {
///   print("Execute by 'didMount' event");
///
///   return () {
///     print("Execute by 'willUnmount' event");
///   };
/// }, [], this);
/// ```
///
/// **RECOMMENDED**: Use it on Object constructor:
///
/// ```dart
/// class AppController {
///   late final state = UseState(false);
///
///   AppController() {
///     UseEffect(() {
///       print('state: ${state.value}');
///     }, [state], this);
///
///     Future.delayed(
///       const Duration(seconds: 1),
///       () {
///         state.value = !state.value;
///       },
///     );
///   }
/// }
/// ```
///
/// If you need to execute the UseEffect's [callback] inmediately created,
/// use [dispatchEffect] on [context] parameter:
///
///
/// ```dart
/// UseEffect(
///   () => print("Prompt execution or state changed"),
///   [state],
///   UseEffect.dispatchEffect,
/// );
/// ```
/// or use mixin [DispatchEffect]:
///
/// ```dart
/// class AppController with DispatchEffect {
///   AppController() {
///     UseEffect(
///       () => print("Prompt execution or state changed"),
///       [state],
///       this,
///     );
///   }
/// }
/// ```
///
/// If you not put instance on the [context] parameter,
/// should to call [dispose] method to clear any UseEffect's events.
///
/// See also:
///
/// * [ReactterState], it receives as dependencies.
/// {@endtemplate}
class UseEffect extends ReactterHook {
  @protected
  @override
  final $ = ReactterHook.$register;

  Function? _cleanupCallback;
  bool _isUpdating = false;
  bool _initialized = false;

  static DispatchEffect get dispatchEffect => _DispatchEffect();

  /// Function to control side-effect and effect cleanup.
  final Function callback;

  /// It's used to store the states as dependencies of [UseEffect].
  final List<ReactterState> dependencies;

  /// It's used to specify the context in which the [UseEffect] hook is being used.
  /// If a context is provided, the [UseEffect] hook will listen
  /// for the `LifeCycle.didMount` and `LifeCycle.willUnmount` events of the [context]
  /// and execute the [callback] method accordingly. If no context is provided,
  /// the hook will simply watch for changes in the specified `dependencies`.
  final Object? context;

  /// {@macro use_effect}
  UseEffect(
    this.callback,
    this.dependencies, [
    this.context,
  ]) {
    _initialized = true;

    if (context == null) {
      _watchDependencies();
      return;
    }

    if (context is DispatchEffect) {
      _runCallbackAndWatchDependencies();
      return;
    }

    if (Zone.currentZone != null) return;

    final instance = _getInstance(context);

    if (instance != null) {
      bind(instance);
      return;
    }

    _watchDependencies();
  }

  @override
  void bind(Object instance) {
    if (context == null) return;

    super.bind(instance);

    if (!_initialized) return;

    _analyzeInstanceAttached();
  }

  @override
  void unbind() {
    _unwatchInstanceAttached();

    super.unbind();
  }

  @override
  void dispose() {
    _cleanupCallback = null;

    _unwatchInstanceAttached();
    _unwatchDependencies();

    super.dispose();
  }

  void _analyzeInstanceAttached() {
    if (bindedTo == null) return;

    if (bindedTo is DispatchEffect) {
      _runCallbackAndWatchDependencies();
      return;
    }

    _watchInstanceAttached();
  }

  void _watchInstanceAttached() {
    Reactter.on(
      bindedTo!,
      Lifecycle.didMount,
      _runCallbackAndWatchDependencies,
    );
    Reactter.on(
      bindedTo!,
      Lifecycle.willUnmount,
      _runCleanupAndUnwatchDependencies,
    );
  }

  void _unwatchInstanceAttached() {
    Reactter.off(
      bindedTo!,
      Lifecycle.didMount,
      _runCallbackAndWatchDependencies,
    );
    Reactter.off(
      bindedTo!,
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

    final cleanupCallback = callback();

    if (cleanupCallback is Function) {
      _cleanupCallback = cleanupCallback;
    }
  }

  void _runCleanup(_, __) {
    if (!_isUpdating) return;

    _isUpdating = false;
    _cleanupCallback?.call();
    _cleanupCallback = null;
  }

  Object? _getInstance(Object? instance) {
    return instance is ReactterState && !Reactter.isRegistered(instance)
        ? _getInstance(instance.bindedTo)
        : instance;
  }
}

abstract class DispatchEffect {}

class _DispatchEffect with DispatchEffect {
  static final inst = _DispatchEffect._();

  factory _DispatchEffect() {
    return inst;
  }

  _DispatchEffect._();
}
