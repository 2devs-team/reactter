part of 'framework.dart';

/// {@template reactter.rt_hook}
/// An abstract-class that provides the functionality of [RtState].
///
/// This is an example of how to create a custom hook:
///
///```dart
/// class UseToggle extends RtHook {
///   final $ = RtHook.$register;
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
/// > **IMPORTANT**: All [RtHook] must be registered using the final [$] variable.:
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
/// * [RtState], adds state management features to [RtHook].
/// {@endtemplate}
abstract class RtHook extends Hook implements RtState {
  @override
  @internal
  DependencyInjection get dependencyInjection => Rt;
  @override
  @internal
  StateManagement get stateManagment => Rt;
  @override
  @internal
  EventHandler get eventHandler => Rt;
  @override
  @internal
  Logger get logger => Rt;

  /// This getter allows access to the [HookRegister] instance
  /// which is responsible for registering a [Hook]
  /// and attaching previously collected states to it.
  static HookRegister get $register => HookRegister();
}

/// {@macro reactter.rt_hook}
@Deprecated(
  'Use `RtHook` instead. '
  'This feature was deprecated after v7.3.0.',
)
typedef ReactterHook = RtHook;
