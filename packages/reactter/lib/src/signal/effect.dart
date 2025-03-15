part of 'signal.dart';

class Effect with RtState, StateSubscriber {
  final Function() fn;

  Effect(this.fn) {
    performDepedencyUpdate();
  }

  @override
  void performDepedencyUpdate() => linkDependencies(fn);
}
