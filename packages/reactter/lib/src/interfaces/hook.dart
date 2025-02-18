part of '../internals.dart';

/// An abstract class that represents a hook in Reactter.
abstract class IHook implements IState {
  /// This variable is used to register [IHook]
  /// and attach the [IState] that are defined here.
  @protected
  HookBindingZone get $;

  /// Initializes a new instance of the [IHook] class.
  ///
  /// This constructor calls the `end` method of the [BindingHookZone] instance
  /// to register the hook and attach the collected states.
  IHook() {
    initHook();
    $._bindInstanceToStates(this);
  }

  /// Initializes the hook.
  /// This method is called when the hook is created.
  /// You can override this method to ensure that the hook is properly
  /// initialized and to bind the instance to the states.
  /// This is particularly useful for setting up state dependencies or
  /// performing side effects when the hook is first created.
  ///
  /// For example, you can use the [UseEffect] hook to execute a side effect when a state changes:
  ///
  /// ```dart
  /// @override
  /// void initHook() {
  ///   UseEffect(
  ///     () {
  ///       print("Executed by state changed");
  ///     },
  ///     [state],
  ///   );
  /// }
  void initHook() {}
}

@internal
class HookBindingZone<T extends IHook> extends BindingZone<T> {}
