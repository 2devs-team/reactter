part of '../core.dart';

enum LifeCycleEvent {
  /// Event when the intance has registered by ReactterFactory.
  registered,

  /// Event when the intance has unregistered by ReactterFactory.
  unregistered,

  /// Event when the intance has inicialized.
  initialized,

  /// Event when the instance will be mount in the widget tree (only it use with flutter)
  willMount,

  /// Event when the instance did be mount in the widget tree (only it use with flutter).
  didMount,

  /// Event when any instance's hooks will be update. Event param is a [ReactterHook]
  willUpdate,

  /// Event when any instance's hooks did be update. Event param is a [ReactterHook]
  didUpdate,

  /// Event when the instance will be unmount in the widget tree (only it use with flutter).
  willUnmount,

  /// Event when the instance did be destroyed.
  destroyed,
}

/// A context that contains any logic and allowed react
/// when any change the [ReactterHook].
///
/// **RECOMMENDED:**
/// Name class with `Context` suffix, for easy locatily:
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
  late final _contextEvent = UseEvent<ReactterContext>.withInstance(this);

  /// Save a callback on [LifeCycleEvent.willMount] event.
  ///
  /// This event will trigger when the instance [ReactterContext]
  /// will be mount in the widget tree (only it use with flutter)
  Function onWillMount(CallbackEvent<ReactterContext, dynamic> callback) {
    _contextEvent.on(LifeCycleEvent.willMount, callback);
    return () => _contextEvent.off(LifeCycleEvent.willMount, callback);
  }

  /// Save a callback on [LifeCycleEvent.didMount] event.
  ///
  /// This event will trigger when the instance [ReactterContext]
  /// did be mount in the widget tree (only it use with flutter)
  Function onDidMount(CallbackEvent<ReactterContext, Null> callback) {
    _contextEvent.on(LifeCycleEvent.didMount, callback);
    return () => _contextEvent.off(LifeCycleEvent.didMount, callback);
  }

  /// Save a callback on [LifeCycleEvent.willUpdate] event.
  ///
  /// This event will trigger when any hooks of instance [ReactterContext] will be update.
  ///
  /// Receives a [ReactterHook] parameter which trigger this event.
  @override
  Function onWillUpdate(
      CallbackEvent<ReactterHookManager, ReactterHook> callback) {
    final unsubscribe = super.onWillUpdate((inst, param) {
      _contextEvent.trigger(LifeCycleEvent.willUpdate, param);
      callback(inst, param);
    });

    _contextEvent.on<ReactterHook>(LifeCycleEvent.willUpdate, callback);

    return () {
      unsubscribe();
      _contextEvent.off<ReactterHook>(LifeCycleEvent.willUpdate, callback);
    };
  }

  /// Save a callback on [LifeCycleEvent.didUpdate] event.
  ///
  /// This event will trigger when any hooks of instance [ReactterContext] did be update.
  ///
  /// Receives a [ReactterHook] parameter which trigger this event.
  @override
  Function onDidUpdate(
      CallbackEvent<ReactterHookManager, ReactterHook> callback) {
    final unsubscribe = super.onDidUpdate((inst, param) {
      _contextEvent.trigger(LifeCycleEvent.didUpdate, param);
      callback(inst, param);
    });
    _contextEvent.on(LifeCycleEvent.didUpdate, callback);

    return () {
      unsubscribe();
      _contextEvent.off(LifeCycleEvent.didUpdate, callback);
    };
  }

  /// Save a callback on [LifeCycleEvent.willUnmount] event.
  ///
  /// This event will trigger when the instance [ReactterContext]
  /// will be unmount in the widget tree (only it use with flutter)
  Function onWillUnmount(CallbackEvent<ReactterContext, Null> callback) {
    _contextEvent.on(LifeCycleEvent.willUnmount, callback);
    return () => _contextEvent.off(LifeCycleEvent.willUnmount, callback);
  }
}
