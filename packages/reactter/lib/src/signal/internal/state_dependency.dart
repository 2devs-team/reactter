part of '../../internals.dart';

mixin StateDependency on RtState {
  final Set<StateSubscriber> _subs = {};
  final Set<Effect> _effects = {};
  bool shouldNotify = false;

  @override
  void update(Function fnUpdate) {
    super.update(fnUpdate);
    SignalRuntime.propagate(this);
  }

  @override
  void notify() {
    super.notify();
    SignalRuntime.propagate(this);
  }
}
