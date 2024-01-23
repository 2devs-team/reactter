part of 'core.dart';

@internal
class HookRegister extends ReactterZone {
  /// Attaches the [hook] instance to the current [HookRegister] instance.
  /// Recollects the state of the [hook] in the [ReactterZone].
  void end(ReactterHookInternal hook) {
    this.attachInstance(hook);
    ReactterZone.recollectState(hook);
  }
}
