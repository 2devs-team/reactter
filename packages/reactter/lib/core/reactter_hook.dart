part of '../core.dart';

/// Provides the functionality of [ReactterHookManager].
///
/// Depends on a [ReactterHookManager] to listen this hook
///
/// This is an example of how to create a custom hook:
///
///```dart
/// class UseToggle extends ReactterHook {
///   late final _state = UseState(false, this);
///
///   bool get value => _state.value;
///
///   UseToggle(
///     bool initial,
///     [ReactterContext? context],
///   ): super(context) {
///     _state.value = initial;
///   }
///
///   void toggle() => _state.value = !_state.value;
/// }
/// ```
///
/// and use it like this:
///
///```dart
/// class AppContext extends ReactterContext {
///   late final state = UseToggle(false, this);
///
///   UserContext() {
///     print('initial value: ${state.value}');
///
///     state.toggle();
///
///     print('toggle value: ${state.value}');
///   }
/// }
/// ```
///
/// See also:
/// - [ReactterHookManager]
abstract class ReactterHook
    with ReactterHookManager, ReactterNotifyManager, ReactterState {
  ReactterHook(ReactterHookManager? context) {
    context?.listenHooks([this]);
  }

  @mustCallSuper
  FutureOr<void> update([Function? callback]) async {
    if (_instance is ReactterContext &&
        (_instance as ReactterContext)._isUpdating) {
      return await updateAsync(() => callback?.call());
    }

    super.update(() => callback?.call());
  }
}
