part of '../core.dart';

/// An abstract-class to provides the functionality of [ReactterHookManager]
/// and is added as a dependency of another [ReactterHookManager]
/// behaving as a state.
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
///
/// * [ReactterHookManager], a abstract-class to manager hooks([ReactterHook]).
abstract class ReactterHook extends ReactterHookManager with ReactterState {
  ReactterHook(ReactterHookManager? context) {
    context?.listenHooks([this]);
  }

  @mustCallSuper
  void update([Function? callback]) {
    return super.update(callback ?? () {});
  }

  @mustCallSuper
  Future<void> updateAsync([Function? callback]) async {
    return super.updateAsync(callback ?? () {});
  }
}
