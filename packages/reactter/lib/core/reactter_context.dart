part of '../core.dart';

/// A context that contains any logic and allowed react
/// when any change the [ReactterHook].
///
/// **RECOMMENDED:**
/// Name class with `Context` suffix, for easy locatily:
///
/// ```dart
/// class AppContext extends ReactterContext {}
/// ```
///
/// For access to instance anywhere, you need to register
/// the instance in Reactter using [ReactterFactory]:
///
/// ```dart
/// Reactter.factory.register<AppContext>(() => AppContex());
/// ```
///
/// and get instance:
///
/// ```dart
/// final instance = Reactter.factory.getInstance<AppContext>();
/// ```
///
/// or using [UseContext] hook:
///
/// ```dart
/// final instance = UseContext<AppContext>().instance;
/// ```
///
/// If you use flutter, add [`flutter_reactter`](https://pub.dev/packages/flutter_reactter)
/// package on your dependencies and use its Widgets.
///
/// See also:
/// - [ReactterHook], a abstract hook that [ReactterContext] listen it.
/// - [ReactterFactory], a instances manager
/// - [UseContext], a hook that allowed access to instance of [ReactterContext].
abstract class ReactterContext extends ReactterHookManager {
  /// Save a callback on [LifeCycleEvent.willMount] event.
  ///
  /// This event will trigger when the instance [ReactterContext]
  /// will be mount in the widget tree (only it use with flutter)
  Function onWillMount(CallbackEvent<ReactterHookManager, dynamic> callback) {
    _event.on(LifeCycleEvent.willMount, callback);
    return () => _event.off(LifeCycleEvent.willMount, callback);
  }

  /// Save a callback on [LifeCycleEvent.didMount] event.
  ///
  /// This event will trigger when the instance [ReactterContext]
  /// did be mount in the widget tree (only it use with flutter)
  Function onDidMount(CallbackEvent<ReactterHookManager, Null> callback) {
    _event.on(LifeCycleEvent.didMount, callback);
    return () => _event.off(LifeCycleEvent.didMount, callback);
  }

  /// Save a callback on [LifeCycleEvent.willUnmount] event.
  ///
  /// This event will trigger when the instance [ReactterContext]
  /// will be unmount in the widget tree (only it use with flutter)
  Function onWillUnmount(CallbackEvent<ReactterHookManager, Null> callback) {
    _event.on(LifeCycleEvent.willUnmount, callback);
    return () => _event.off(LifeCycleEvent.willUnmount, callback);
  }
}
