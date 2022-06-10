library reactter;

import 'reactter_hook.dart';
import 'reactter_subscribers_manager.dart';

enum ReactterHookManagerEvent { willUpdate, didUpdate }

/// Manages the [ReactterHook] witch add from [listenHooks] method.
///
/// This is an example of how to create a custom hook with mixin:
///
///```dart
/// mixin LoadingMixin on ReactterHookManager {
///   final loading = UseState(false, this);
///
///   void loadingToggle() {
///     loading.value = !loading.value;
///   }
/// }
///
/// class AppContext extends ReactterContext with LoadingMixin {
///   AppContext(){
///     loadingToggle();
///     print('loading: ${loading.value}');
///   }
/// }
///
/// class UseUser extends ReactterHook with LoadingMixin {
///   UseUser(){
///     loadingToggle();
///     print('loading: ${loading.value}');
///   }
/// }
///```
///
class ReactterHookManager {
  /// Stores all the hooks given.
  final Set<ReactterHook> _hooks = {};
  final _subscribersManager =
      ReactterSubscribersManager<ReactterHookManagerEvent>();

  /// Suscribes to all [hooks] given.
  void listenHooks(List<ReactterHook> hooks) {
    for (final hook in hooks) {
      if (_hooks.contains(hook)) {
        return;
      }

      _hooks.add(hook);

      hook.onWillUpdate(
        () => _subscribersManager.publish(ReactterHookManagerEvent.willUpdate),
      );

      hook.onDidUpdate(
        () => _subscribersManager.publish(ReactterHookManagerEvent.didUpdate),
      );
    }
  }

  /// First, invokes the subscribers callbacks of the willUpdate event.
  /// Second, invokes the callback given by parameter.
  /// And finally, invokes the subscribers callbacks of the didUpdate event.
  void update([Function? callback]) {
    _subscribersManager.publish(ReactterHookManagerEvent.willUpdate);

    callback?.call();

    _subscribersManager.publish(ReactterHookManagerEvent.didUpdate);
  }

  /// Register a callback that will be executed when the instance will update
  Function onWillUpdate(Function callback) {
    _subscribersManager.subscribe(
        ReactterHookManagerEvent.willUpdate, callback);
    return () => _subscribersManager.unsubscribe(
        ReactterHookManagerEvent.willUpdate, callback);
  }

  /// Register a callback that will be executed when the instance did update
  Function onDidUpdate(Function callback) {
    _subscribersManager.subscribe(ReactterHookManagerEvent.didUpdate, callback);
    return () => _subscribersManager.unsubscribe(
        ReactterHookManagerEvent.didUpdate, callback);
  }
}
