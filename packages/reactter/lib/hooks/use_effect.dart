part of '../hooks.dart';

/// It's a hook that manages side-effect on [ReactterContext]
///
/// The side-effect logic into the [callback] function is executed
/// when [dependencies] of [ReactterHook] argument has changes
/// or [context] of [ReactterContext] trigger [didMount] event.
///
/// If the [callback] returns a function,
/// then [UseEffect] considers this as an `effect cleanup`.
///
/// The `effect cleanup` callback is execute when before [callback] is called
/// or [context] trigger  [willUnmount] event.
///
/// This example produces a [UseEffect], it must be called on [ReactterContext]
/// constructor:
///
/// ```dart
/// class AppContext extends ReactterContext {
///   late final name = UseState<String?>(null, this);
///   late final firstName = UseState("Carlos", this);
///   late final lastName = UseState("Leon", this);
///
///   AppContext() {
///     UseEffect(() {
///       // name.value = "Carlos Leon" on first time
///       // name.value = "Leo Cast" after 2 seconds pass
///       name.value = "${firstName.value} ${lastName.value}";
///     }, [firstName, lastName], this);
///
///     Future.delayed(Duration(seconds: 1), () {
///       firstName.value = "Leo";
///       lastName.value = "Cast";
///     });
///   }
/// }
/// ```
class UseEffect extends ReactterHook {
  /// Function to control side-effect and effect cleanup.
  final Function callback;

  /// Hooks dependencies
  final List<ReactterHook> dependencies;

  late final _event = UseEvent.withInstance(this);
  Function? _unsubscribeCallback;

  UseEffect(
    this.callback,
    this.dependencies, [
    ReactterContext? context,
  ]) : super(context) {
    listenHooks(dependencies);

    _addListeners(context);
  }

  void _addListeners(ReactterContext? context) {
    Function? unsubscribeWillUpdate;
    Function? unsubscribeDidUpdate;

    if (context != null) {
      _onSubscribe(this, null);
    }

    if (context is DispatchEffect || context == null) {
      unsubscribeWillUpdate = _onWillUpdate(_onUnsubscribe);
      unsubscribeDidUpdate = _onDidUpdate(_onSubscribe);
    }

    if (context == null) {
      return;
    }

    UseEvent.withInstance(context)
      ..on(LifeCycle.willUpdate, (_, __) {
        unsubscribeWillUpdate = _onWillUpdate(_onUnsubscribe);
        unsubscribeDidUpdate = _onDidUpdate(_onSubscribe);
      })
      ..on(LifeCycle.didMount, (_, __) {
        unsubscribeWillUpdate = _onWillUpdate(_onUnsubscribe);
        unsubscribeDidUpdate = _onDidUpdate(_onSubscribe);
      })
      ..on(LifeCycle.willUnmount, (_, __) {
        _onUnsubscribe.call(_, __);
        unsubscribeWillUpdate?.call();
        unsubscribeDidUpdate?.call();
      });
  }

  void _onSubscribe(_, __) {
    final returnCallback = callback();

    if (returnCallback is Function) {
      _unsubscribeCallback = returnCallback;
    }
  }

  void _onUnsubscribe(_, __) => _unsubscribeCallback?.call();

  Function _onWillUpdate(
    CallbackEvent callback,
  ) {
    _event.on<ReactterHook>(LifeCycle.willUpdate, callback);

    return () => _event.off<ReactterHook>(LifeCycle.willUpdate, callback);
  }

  Function _onDidUpdate(
    CallbackEvent callback,
  ) {
    _event.on<ReactterHook>(LifeCycle.didUpdate, callback);

    return () => _event.off<ReactterHook>(LifeCycle.didUpdate, callback);
  }

  static DispatchEffect get dispatchEffect => DispatchEffect();
}

class DispatchEffect extends ReactterContext {
  static final DispatchEffect inst = DispatchEffect._();

  factory DispatchEffect() {
    return inst;
  }

  DispatchEffect._();
}
