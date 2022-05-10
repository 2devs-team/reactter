library reactter;

import 'package:flutter/widgets.dart';

import '../core/mixins/reactter_publish_suscription.dart';
import '../core/reactter_context.dart';
import '../core/reactter_hook.dart';

/// It's a hook that manages side-effect on [ReactterContext]
///
/// The side-effect logic into the [callback] function is executed
/// when [dependencies] of [ReactterHook] argument has changes
/// or [context] of [ReactterContext] trigger lifecycle [didMount].
///
/// If the [callback] returns a function,
/// then [UseEffect] considers this as an `effect cleanup`.
///
/// The `effect cleanup` callback is execute when before [callback] is called
/// or [context] trigger lifecycle [willUnmount]
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

    if (context == null) {
      subscribe(PubSubEvent.willUpdate, _onUnsubscribe);
      subscribe(PubSubEvent.didUpdate, _onSubscribe);
    }

    context?.onDidMount(() {
      _onSubscribe();

      subscribe(PubSubEvent.willUpdate, _onUnsubscribe);
      subscribe(PubSubEvent.didUpdate, _onSubscribe);
    });

    context?.onWillUnmount(() {
      _onUnsubscribe.call();

      unsubscribe(PubSubEvent.willUpdate, _onUnsubscribe);
      unsubscribe(PubSubEvent.didUpdate, _onSubscribe);
    });
  }

  void _onSubscribe() {
    final _returnCallback = callback();

    if (_returnCallback is Function) {
      _unsubscribeCallback = _returnCallback;
    }
  }

  void _onUnsubscribe() {
    _unsubscribeCallback?.call();
  }
}
