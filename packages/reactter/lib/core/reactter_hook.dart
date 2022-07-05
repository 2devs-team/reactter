part of '../core.dart';

/// Provides the functionality of [ReactterHookManager].
///
/// Depends on a [ReactterHookManager] for a listen this hook
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
abstract class ReactterHook extends ReactterHookManager {
  ReactterHook(ReactterHookManager? context) {
    context?.listenHooks([this]);
  }

  /// First, invokes the subscribers callbacks of the willUpdate event.
  ///
  /// Second, invokes the callback given by parameter.
  ///
  /// And finally, invokes the subscribers callbacks of the didUpdate event.
  void update([Function? callback]) {
    _event.trigger(LifeCycle.willUpdate, this);

    callback?.call();

    _event.trigger(LifeCycle.didUpdate, this);
  }
}
