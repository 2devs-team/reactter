part of '../internals.dart';

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
abstract class RtHook with RtContext, RtStateBase<RtHook> implements IHook {
  /// {@template reactter.rt_hook.register}
  /// This getter allows access to the [HookRegister] instance
  /// which is responsible for registering a [RtHook]
  /// and attaching previously collected states to it.
  /// {@endtemplate}
  static get $register => HookRegister<RtHook>();

  /// This variable is used to register [RtHook]
  /// and attach the [RtState] that are defined here.
  @override
  @protected
  HookRegister<RtHook> get $;

  /// Initializes a new instance of the [RtHook] class.
  ///
  /// This constructor calls the `end` method of the [BindingHookZone] instance
  /// to register the hook and attach the collected states.
  RtHook() {
    $.bindInstanceToStates(this);
  }

  /// Executes [callback], and notifies the listeners about the update.
  ///
  /// If [callback] is provided, it will be executed before notifying the listeners.
  /// If [callback] is not provided, an empty function will be executed.
  @override
  @mustCallSuper
  void update([Function? callback]) {
    return super.update(callback ?? () {});
  }
}

/// {@macro reactter.rt_hook}
@Deprecated(
  'Use `RtHook` instead. '
  'This feature was deprecated after v7.3.0.',
)
typedef ReactterHook = RtHook;
