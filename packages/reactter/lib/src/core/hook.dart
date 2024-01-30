part of 'core.dart';

/// An abstract class that provides the base functionality for creating
/// custom hooks in the Reactter library.
abstract class Hook with State implements StateBase {
  /// This variable is used to register [Hook]
  /// and attach the [StateBase] that are defined here.
  ///
  /// It must be defined as a final variable
  /// and set with [Hook.$register].
  /// Like so:
  ///
  /// `final $ = ReactterHookBase.$register;`
  @protected
  HookRegister get $;

  /// Initializes a new instance of the [Hook] class.
  ///
  /// This constructor calls the `end` method of the [HookRegister] instance
  /// to register the hook and attach the collected states.
  Hook() {
    $.end(this);
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
