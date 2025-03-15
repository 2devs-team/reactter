part of 'signal.dart';

class Computed<T> with RtState, StateSubscriber, StateDependency {
  final T Function() compute;
  bool _isComputed = false;

  @override
  final String? debugLabel;

  late T _valueComputed;

  T get value {
    if (!_isComputed) performDepedencyUpdate();

    SignalRuntime.link(this);

    return _valueComputed;
  }

  Computed(this.compute, [this.debugLabel]);

  @override
  void performDepedencyUpdate() {
    final value = linkDependencies(compute);

    if (!_isComputed || _valueComputed != value) {
      _valueComputed = value;
      _isComputed = true;
      notify();
    }
  }
}
