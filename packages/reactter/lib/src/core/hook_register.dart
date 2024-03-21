part of 'core.dart';

@internal
class HookRegister extends BindingZone {
  /// Stores the instance of the [Hook] and attaches the previously collected states to it.
  void end(Hook hook) {
    bindInstanceToStates(hook);
    BindingZone.recollectState(hook);
  }
}
