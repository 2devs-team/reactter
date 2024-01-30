part of 'core.dart';

@internal
class HookRegister extends Zone {
  /// Attaches the [hook] instance to the current [HookRegister] instance.
  /// Recollects the state of the [hook] in the [Zone].
  void end(Hook hook) {
    this.attachInstance(hook);
    Zone.recollectState(hook);
  }
}
