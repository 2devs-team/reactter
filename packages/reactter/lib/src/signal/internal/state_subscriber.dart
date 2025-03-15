part of '../../internals.dart';

mixin StateSubscriber on RtState {
  StateSubscriber? _prevSub;
  final Set<StateDependency> _deps = {};

  void performDepedencyUpdate();

  @override
  void dispose() {
    _deps.clear();
    _prevSub = null;

    super.dispose();
  }

  T linkDependencies<T>(T Function() fn) {
    try {
      _prevSub = SignalRuntime._currentSub;
      SignalRuntime._currentSub = this;
      return fn();
    } finally {
      SignalRuntime._currentSub = _prevSub;
    }
  }
}
