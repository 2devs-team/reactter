part of '../hooks.dart';

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
/// use [DispatchEffect] on [context] parameter:
///
///
/// ```dart
/// UseEffect(
///   () => print("Prompt execution or state changed"),
///   [state],
///   UseEffect.DispatchEffect,
/// );
/// ```
/// or use mixin [DispatchEffect]:
///
/// ```dart
/// class AppController with DispatchEffect {
///   AppController() {
///     UseEffect(
///       () => print("Prompt execution or state changed"),
///       [state], this
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
class UseEffect extends ReactterHook {
  /// Function to control side-effect and effect cleanup.
  final Function callback;

  /// It's used to store the states as dependencies of [UseEffect].
  final List<ReactterState> dependencies;

  /// It's used to specify the context in which the [UseEffect] hook is being used.
  /// If a context is provided, the [UseEffect] hook will listen
  /// for the `LifeCycle.didMount` and `LifeCycle.willUnmount` events of the [context]
  /// and execute the [callback] function accordingly. If no context is provided,
  /// the hook will simply watch for changes in the specified `dependencies`.
  final Object? context;

  static DispatchEffect get dispatchEffect => _DispatchEffect();

  Function? _cleanupCallback;

  bool _isUpdating = false;

  UseEffect(
    this.callback,
    this.dependencies, [
    this.context,
  ]) : super() {
    if (context == null) {
      _watchDependencies();
      return;
    }

    if (context is DispatchEffect) {
      _runCallbackAndWatchDependencies(null, null);
    }

    Reactter.on(
      context,
      Lifecycle.didMount,
      _runCallbackAndWatchDependencies,
    );
    Reactter.on(
      context,
      Lifecycle.willUnmount,
      _runCleanupAndUnwatchDependencies,
    );
    Reactter.one(context, Lifecycle.destroyed, (_, __) => dispose());
  }

  /// Used to clean up resources and memory used by an object before it is
  /// removed from memory.
  void dispose() {
    _cleanupCallback = null;

    Reactter.off(
      context,
      Lifecycle.didMount,
      _runCallbackAndWatchDependencies,
    );
    Reactter.off(
      context,
      Lifecycle.willUnmount,
      _runCleanupAndUnwatchDependencies,
    );

    super.dispose();
  }

  void _runCallbackAndWatchDependencies(_, __) {
    _runCallback(_, __);
    _watchDependencies();
  }

  void _runCleanupAndUnwatchDependencies(_, __) {
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
}

mixin DispatchEffect {}

class _DispatchEffect with DispatchEffect {
  static final _DispatchEffect inst = _DispatchEffect._();

  factory _DispatchEffect() {
    return inst;
  }

  _DispatchEffect._();
}
