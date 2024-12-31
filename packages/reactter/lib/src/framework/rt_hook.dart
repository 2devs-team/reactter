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
abstract class RtHook
    with RtContextMixin, RtStateBase<RtHook>
    implements IHook {
  /// {@template reactter.rt_hook.register}
  /// This getter allows access to the [HookBindingZone] instance
  /// which is responsible for registering a [RtHook]
  /// and attaching previously collected states to it.
  /// {@endtemplate}
  static get $register => HookBindingZone<RtHook>();

  /// This variable is used to register [RtHook]
  /// and attach the [RtState] that are defined here.
  @override
  @protected
  HookBindingZone<RtHook> get $;

  /// Initializes a new instance of the [RtHook] class.
  ///
  /// This constructor calls the `end` method of the [BindingHookZone] instance
  /// to register the hook and attach the collected states.
  RtHook() {
    $.bindInstanceToStates(this);
  }

  @override
  @mustCallSuper
  void update([Function()? fnUpdate]) {
    return super.update(fnUpdate ?? () {});
  }
}
