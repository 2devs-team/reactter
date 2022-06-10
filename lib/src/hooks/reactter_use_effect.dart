library reactter;

import 'package:flutter/widgets.dart';

import '../core/reactter_context.dart';
import '../core/reactter_hook.dart';

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
  @protected
  final Function callback;

  /// Hooks dependencies
  @protected
  final List<ReactterHook> dependencies;

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
      _onSubscribe();
    }

    if (context is DispatchEffect || context == null) {
      unsubscribeWillUpdate = onWillUpdate(_onUnsubscribe);
      unsubscribeDidUpdate = onDidUpdate(_onSubscribe);
    }

    context?.onDidMount(() {
      unsubscribeWillUpdate = onWillUpdate(_onUnsubscribe);
      unsubscribeDidUpdate = onDidUpdate(_onSubscribe);
    });

    context?.onWillUnmount(() {
      _onUnsubscribe.call();
      unsubscribeWillUpdate?.call();
      unsubscribeDidUpdate?.call();
    });
  }

  void _onSubscribe() {
    final returnCallback = callback();

    if (returnCallback is Function) {
      _unsubscribeCallback = returnCallback;
    }
  }

  void _onUnsubscribe() => _unsubscribeCallback?.call();

  static DispatchEffect get dispatchEffect => DispatchEffect();
}

class DispatchEffect extends ReactterContext {
  static final DispatchEffect inst = DispatchEffect._();

  factory DispatchEffect() {
    return inst;
  }

  DispatchEffect._();
}
