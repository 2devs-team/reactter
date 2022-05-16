library reactter;

import 'reactter_hook.dart';
import 'mixins/reactter_publish_suscription.dart';

/// Provides the functionlatiy of [ReactterPubSub],
/// and manages the [ReactterHook] witch add from [listenHooks] method.
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
class ReactterHookManager with ReactterPubSub {
  /// Stores all the hooks given.
  final Set<ReactterHook> _hooks = {};

  /// Suscribes to all [hooks] given.
  void listenHooks(List<ReactterHook> hooks) {
    for (final hook in hooks) {
      if (_hooks.contains(hook)) {
        return;
      }

      _hooks.add(hook);

      hook.subscribe(
        PubSubEvent.willUpdate,
        () => publish(PubSubEvent.willUpdate),
      );

      hook.subscribe(
        PubSubEvent.didUpdate,
        () => publish(PubSubEvent.didUpdate),
      );
    }
  }
}
