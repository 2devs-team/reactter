import 'reactter_hook_manager.dart';
import 'reactter_subscribers_manager.dart';

enum LifeCycleEvent { willMount, didMount, willUpdate, didUpdate, willUnmount }

/// Provides a life cycle manager
mixin ReactterLifeCycle on ReactterHookManager {
  final _subscribersManager = ReactterSubscribersManager<LifeCycleEvent>();

  /// Fires the event of type and executes the callbacks
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
