part of '../core.dart';

/// An abstract-class that provides the functionality of [ReactterNotifyManager]
/// and [ReactterState].
///
/// This is an example of how to create a custom hook:
///
///```dart
/// class UseToggle extends ReactterHook {
///   final _state = UseState(false);
///
///   bool get value => _state.value;
///
///   UseToggle(bool initial) {
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
/// class AppController {
///   final state = UseToggle(false);
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
/// * [ReactterNotifyManager], provides methods that notify listeners
/// about [ReactterHook] changes.
/// * [ReactterState], adds state management features to [ReactterHook].
abstract class ReactterHook with ReactterState {
  ReactterHook() {
    createState();
  }

  /// Executes [callback], and notify the listeners about to update.
  @mustCallSuper
  void update([Function? callback]) {
    return super.update(callback ?? () {});
  }

  /// Executes [callback], and notify the listeners about to update as async way.
  @mustCallSuper
  Future<void> updateAsync([Function? callback]) async {
    return super.updateAsync(callback ?? () {});
  }
}
