library reactter;

import 'reactter_hook.dart';
import 'mixins/reactter_publish_suscription.dart';

/// It's provides [publish] and [subscribe] methods,
/// and manages the [ReactterHook] witch add from [listenHooks] method.
///
/// You can use it as a mixin for [ReactterContext] or [ReactterHook] class,
/// for example:
///
///```dart
/// mixin LoadingMixin on ReactterHookManager {
///   final loading = UseState(false, context: this);
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
  /// Store all the hooks given.
  final Set<ReactterHook> _hooks = {};

  /// Suscribe to all [hooks] given.
  void listenHooks(List<ReactterHook> hooks) {
    for (final _hook in hooks) {
      if (_hooks.contains(_hook)) {
        return;
      }

      _hooks.add(_hook);

      _hook.subscribe(publish);
    }
  }
}
