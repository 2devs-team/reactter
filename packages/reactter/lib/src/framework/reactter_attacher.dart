part of '../framework.dart';

@internal
abstract class ReactterAttacher {
  /// It's used to store instances of [ReactterState]
  /// that are collected during the recollection process.
  List<ReactterState> _statesRecollected = [];

  /// It's used to keep track of whether the
  /// recollection process is turned on or off.
  bool _isRecollectOn = false;
  @internal
  bool get isRecollectOn => _isRecollectOn;

  /// Recollects previous states, attaches a new instance,
  /// and returns the instance.
  T _recollectStatesAndAttachInstance<T extends Object?>(
    T Function() getInstance,
  ) {
    final _statesRecollectedPrev = _statesRecollected;
    final _isRecollectOnPrev = _isRecollectOn;

    _isRecollectOn = true;
    _statesRecollected = [];

    final instance = getInstance();

    if (instance != null) _attachInstance(instance);

    _statesRecollected = _statesRecollectedPrev;
    _isRecollectOn = _isRecollectOnPrev;

    return instance;
  }

  void _recollectState(ReactterState state) {
    if (!_isRecollectOn) return;

    _statesRecollected.add(state);
  }

  void _attachInstance(Object instance) {
    for (final state in [..._statesRecollected]) {
      state.attachTo(instance);
    }
  }
}
