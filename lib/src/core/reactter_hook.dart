import 'package:flutter/widgets.dart';

import 'reactter_hook_manager.dart';

/// Provides the functionality of [ReactterHookManager].
///
/// Depends on a [ReactterContext] for a listen this hook
///
/// This is an example of how to create a custom hook:
///
///```dart
/// class UseToggle extends ReactterHook {
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
  @protected
  ReactterHookManager? context;

  ReactterHook(this.context) {
    context?.listenHooks([this]);
  }
}
