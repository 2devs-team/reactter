import 'package:flutter/foundation.dart';

import 'reactter_hook_manager.dart';
import 'reactter_subscribers_manager.dart';

enum LifeCycleEvent { willMount, didMount, willUpdate, didUpdate, willUnmount }

/// Provides the functionlatiy of [ReactterHookManager] and [ReactterLifeCycle] to any class.
///
/// It's recommended to name you class with `Context` suffix to improve readability:
///
///```dart
/// class AppContext extends ReactterContext {
///   late final name = UseState<String>('Leo León', this);
/// }
/// ```
///
/// To use it, you should provide it within [ReactterProvider] with an [UseContext],
/// you can access to the property values with [ReactterBuildContextExtension].
///
/// This example contain a [ReactterProvider] with an [UseContext]
/// of type [AppContext], and read all the states in builder:
///
/// ```dart
/// ReactterProvider(
///  contexts: [
///    UseContext(
///      () => AppContext()
///    )
///  ],
///  builder: (context) {
///     appContext = context.watch<AppContext>();
///
///     return Text(appContext.name.value);
///   }
/// )
/// ```
abstract class ReactterContext extends ReactterHookManager {
  final _subscribersManager = ReactterSubscribersManager<LifeCycleEvent>();

  /// Fires the event of type and executes the callbacks
  @protected
  void executeEvent(LifeCycleEvent event) {
    _subscribersManager.publish(event);
  }

  /// Save a callback on [willMount] event.
  ///
  /// This event will trigger before the [ReactterContext] instance will mount in the tree by [ReactterProvider].
  Function onWillMount(Function callback) {
    _subscribersManager.subscribe(LifeCycleEvent.willMount, callback);
    return () =>
        _subscribersManager.unsubscribe(LifeCycleEvent.willMount, callback);
  }

  /// Save a callback on [didMount] event.
  ///
  /// This event will trigger after the [ReactterContext] instance did mount in the tree by [ReactterProvider].
  Function onDidMount(Function callback) {
    _subscribersManager.subscribe(LifeCycleEvent.didMount, callback);
    return () =>
        _subscribersManager.unsubscribe(LifeCycleEvent.didMount, callback);
  }

  /// Save a callback on [willUpdate] event.
  ///
  /// This event will trigger before the [ReactterContext] instance will update in the tree by any [ReactterHook].
  @override
  Function onWillUpdate(Function callback) {
    final unsubscribe = super.onWillUpdate(callback);
    _subscribersManager.subscribe(LifeCycleEvent.willUpdate, callback);

    return () {
      unsubscribe();
      _subscribersManager.unsubscribe(LifeCycleEvent.willUpdate, callback);
    };
  }

  /// Save a callback on [didMount] event.
  ///
  /// This event will trigger after the [ReactterContext] instance did update in the tree by any [ReactterHook].
  @override
  Function onDidUpdate(Function callback) {
    final unsubscribe = super.onDidUpdate(callback);
    _subscribersManager.subscribe(LifeCycleEvent.didUpdate, callback);

    return () {
      unsubscribe();
      _subscribersManager.unsubscribe(LifeCycleEvent.didUpdate, callback);
    };
  }

  /// Save a callback on [willUnmount] event.
  ///
  /// This event will trigger before the [ReactterContext] instance will unmount in the tree by [ReactterProvider].
  Function onWillUnmount(Function callback) {
    _subscribersManager.subscribe(LifeCycleEvent.willUnmount, callback);
    return () =>
        _subscribersManager.unsubscribe(LifeCycleEvent.willUnmount, callback);
  }
}
