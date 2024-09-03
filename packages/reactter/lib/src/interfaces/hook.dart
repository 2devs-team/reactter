part of '../internals.dart';

/// An abstract class that represents a hook in Reactter.
abstract class IHook {
  /// This variable is used to register [IHook]
  /// and attach the [IState] that are defined here.
  @protected
  HookBindingZone get $;

  /// Executes [callback], and notifies the listeners about the update.
  ///
  /// If [callback] is provided, it will be executed before notifying the listeners.
  /// If [callback] is not provided, an empty function will be executed.
  @mustCallSuper
  void update([Function? callback]);
}

@internal
class HookBindingZone<T extends IHook> extends BindingZone<T> {}
