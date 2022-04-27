import 'reactter_hook_manager.dart';

/// Provide the functionlatiy of a hook to a class.
///
/// You can create a hook like this:
///
///```dart
/// class UseToggle on ReactterHook {
///   late final _state = UseState(false, context: this);
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
class ReactterHook extends ReactterHookManager {
  ReactterHookManager? context;

  ReactterHook(this.context) {
    context?.listenHooks([this]);
  }
}
