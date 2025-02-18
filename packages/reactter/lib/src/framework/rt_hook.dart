part of '../framework.dart';

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
/// > **RECOMMENDED**: All [RtHook] must be registered using the final [$] variable.:
///
/// and use it, like so:
///
/// >```dart
/// > class AppController {
/// >   final uToggle = UseToggle(false);
/// >
/// >   UserContext() {
/// >     print('initial value: ${uToggle.value}');
/// >
/// >     uToggle.toggle();
/// >
/// >     print('toggle value: ${uToggle.value}');
/// >   }
/// > }
/// > ```
///
/// See also:
/// * [RtState], adds state management features to [RtHook].
/// {@endtemplate}
abstract class RtHook extends IHook with RtState {
  /// {@template reactter.rt_hook.register}
  /// This getter allows access to the [HookBindingZone] instance
  /// which is responsible for registering a [RtHook]
  /// and attaching previously collected states to it.
  /// {@endtemplate}
  static get $register => HookBindingZone<RtHook>();

  @override
  @mustCallSuper
  void update([Function()? fnUpdate]) {
    return super.update(fnUpdate ?? () {});
  }
}
