part of '../hooks.dart';

/// A hook that side-effect manager.
///
/// The side-effect logic into the [callback] function is executed
/// when [dependencies] of [ReactterHook] argument has changes
/// or [context] of [ReactterContext] trigger [didMount] event.
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
/// or [context] trigger [willUnmount] event:
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
/// **RECOMMENDED**: Use it on [ReactterContext] constructor:
///
/// ```dart
/// class AppContext extends ReactterContext {
///   late final state = UseState(false);
///
///   AppContext() {
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
/// If you need to execute the UseEffect's [callback] inmediately created,
/// use [DispatchEffect] on [context] parameter:
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
/// class AppContext extends ReactterContext with DispatchEffect {
///   AppContext() {
///     UseEffect(
///       () => print("Prompt execution or state changed"),
///       [state], this
///     );
///   }
/// }
/// ```
///
/// If you not put [ReactterContext] on the [context] parameter,
/// should to call [dispose] method for clear any UseEffect's events.
///
/// See also:
/// - [ReactterContext], is used to react to its [didMount] and [willUnmount] events.
/// - [ReactterHook], it receives as dependencies.
class UseEffect extends ReactterHook {
  /// Function to control side-effect and effect cleanup.
  final Function callback;

  /// Hooks dependencies
  final List<ReactterHook> dependencies;

  final ReactterContext? context;

  static DispatchEffect get dispatchEffect => _DispatchEffect._();

  late final _dependenciesEvent = UseEvent.withInstance(this);
  Function? _cleanupCallback;

  UseEffect(
    this.callback,
    this.dependencies, [
    this.context,
  ]) : super(context) {
    listenHooks(dependencies);

    if (context == null) {
      _watchDependencies();
      return;
    }

    if (context is DispatchEffect) {
      _runCallbackAndWatchDependencies(null, null);
    }

    UseEvent.withInstance(context)
      ..on(LifeCycle.didMount, _runCallbackAndWatchDependencies)
      ..on(LifeCycle.willUnmount, _runCleanupAndUnwatchDependencies)
      ..one(LifeCycle.destroyed, (_, __) => dispose());
  }

  void dispose() {
    _cleanupCallback = null;
    UseEvent.withInstance(context)
      ..off(LifeCycle.didMount, _runCallbackAndWatchDependencies)
      ..off(LifeCycle.willUnmount, _runCleanupAndUnwatchDependencies);
    _dependenciesEvent.dispose();
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
    _dependenciesEvent.on(LifeCycle.willUpdate, _runCleanup);
    _dependenciesEvent.on(LifeCycle.didUpdate, _runCallback);
  }

  void _unwatchDependencies() {
    _dependenciesEvent.off(LifeCycle.willUpdate, _runCleanup);
    _dependenciesEvent.off(LifeCycle.didUpdate, _runCallback);
  }

  void _runCallback(_, __) {
    final cleanupCallback = callback();

    if (cleanupCallback is Function) {
      _cleanupCallback = cleanupCallback;
    }
  }

  void _runCleanup(_, __) {
    _cleanupCallback?.call();
    _cleanupCallback = null;
  }
}

mixin DispatchEffect on ReactterContext {}

class _DispatchEffect extends ReactterContext with DispatchEffect {
  static final _DispatchEffect inst = _DispatchEffect._();

  factory _DispatchEffect() {
    return inst;
  }

  _DispatchEffect._();
}
