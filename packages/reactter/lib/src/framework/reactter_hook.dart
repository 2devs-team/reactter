part of 'framework.dart';

/// An abstract-class that provides the functionality of [ReactterState].
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
/// * [ReactterState], adds state management features to [ReactterHook].
abstract class ReactterHook extends Hook implements ReactterState {
  @override
  @internal
  DependencyInjection get instanceInjection => Reactter;
  @override
  @internal
  StateManagement get stateManagment => Reactter;
  @override
  @internal
  EventHandler get eventHandler => Reactter;
  @override
  @internal
  Logger get logger => Reactter;

  /// This getter allows access to the [HookRegister] instance
  /// which is responsible for registering a [Hook]
  /// and attaching previously collected states to it.
  static HookRegister get $register => HookRegister();
}
