part of '../framework.dart';

/// An abstract-class that provides the functionality of [ReactterNotifyManager]
/// and [ReactterState].
///
/// This is an example of how to create a custom hook:
///
///```dart
/// class UseToggle extends ReactterHook {
///   final $ = ReactterHook.$register;
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
/// > **IMPORTANT**: All [ReactterHook] must be registered using the final [$] variable.:
///
/// and use it, like so:
///
/// >```dart
/// > class AppController {
/// >   final state = UseToggle(false);
/// >
/// >   UserContext() {
/// >     print('initial value: ${state.value}');
/// >
/// >     state.toggle();
/// >
/// >     print('toggle value: ${state.value}');
/// >   }
/// > }
/// > ```
///
/// See also:
///
/// * [ReactterNotifyManager], provides methods that notify listeners
/// about [ReactterHook] changes.
/// * [ReactterState], adds state management features to [ReactterHook].
abstract class ReactterHook with ReactterStateBase implements ReactterState {
  /// This variable is used to register [ReactterHook]
  /// and attach the [ReactterState] that are defined here.
  ///
  /// It must be defined as a final variable
  /// and set with [ReactterHook.$register].
  /// Like so:
  ///
  /// `final $ = ReactterHook.$register;`
  @protected
  _ReactterHookRegister get $;

  /// This getter allows access to the [_ReactterHookRegister] instance
  /// which is responsible for registering a [ReactterHook]
  /// and attaching previously collected states to it.
  static _ReactterHookRegister get $register => _ReactterHookRegister();

  ReactterHook() {
    $._end(this);
  }

  /// Executes [callback], and notify the listeners about to update.
  @override
  @mustCallSuper
  void update([Function? callback]) {
    return super.update(callback ?? () {});
  }
}

class _ReactterHookRegister extends ReactterZone {
  void _end(ReactterHook reactterHook) {
    this.attachInstance(reactterHook);
    ReactterZone.recollectState(reactterHook);
  }
}
