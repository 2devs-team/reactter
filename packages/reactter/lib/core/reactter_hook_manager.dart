part of '../core.dart';

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
  late final _hookManagerEvent = UseEvent.withInstance(this);

  /// Stores all the hooks given.
  final Set<ReactterHook> _hooks = {};

  /// Suscribes to all [hooks] given.
  void listenHooks(List<ReactterHook> hooks) {
    for (final hook in hooks) {
      if (_hooks.contains(hook)) {
        return;
      }

      _hooks.add(hook);

      hook.onWillUpdate(
        (_, hook) => _hookManagerEvent.trigger(
            ReactterHookManagerEvent.willUpdate, hook),
      );

      hook.onDidUpdate(
        (_, hook) =>
            _hookManagerEvent.trigger(ReactterHookManagerEvent.didUpdate, hook),
      );
    }
  }

  /// Register a callback that will be executed when the instance will update
  Function onWillUpdate(
      CallbackEvent<ReactterHookManager, ReactterHook> callback) {
    _hookManagerEvent.on(ReactterHookManagerEvent.willUpdate, callback);
    return () =>
        _hookManagerEvent.off(ReactterHookManagerEvent.willUpdate, callback);
  }

  /// Register a callback that will be executed when the instance did update
  Function onDidUpdate(
      CallbackEvent<ReactterHookManager, ReactterHook> callback) {
    _hookManagerEvent.on(ReactterHookManagerEvent.didUpdate, callback);
    return () =>
        _hookManagerEvent.off(ReactterHookManagerEvent.didUpdate, callback);
  }
}
