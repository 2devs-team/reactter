part of 'core.dart';

final x = MapEntry(0, 0);

abstract class StateManager {
  bool _isUntrackedRunning = false;
  bool _isBatchRunning = false;
  final HashMap<EventNotifier, Object?> _deferredEvents = HashMap();

  /// Lazily initializes a state of type [ReactterState] and attaches it to the given [instance].
  ///
  /// This method is recommended to use when initializing state inside a class
  /// using the `late` keyword.
  /// It ensures that the state is used properly within the context of [instance]
  /// for tracking state changes and triggering side effects.
  /// Additionally, the state will be disposed when [instance] is disposed.
  ///
  /// Example usage:
  /// ```dart
  /// class AppController {
  ///   final stateA = Signal(0);
  ///   final stateB = UseState(0);
  ///
  ///   // This is a lazy state, it will only be loaded when it is accessed.
  ///   late final computed = Reactter.lazyState(
  ///     () => UseCompute(
  ///       () => stateA.value + stateB.value,
  ///       [stateA, stateB],
  ///     ),
  ///     this,
  ///   );
  /// }
  ///
  T lazyState<T extends ReactterState>(T buildState(), Object instance) {
    final zone = ReactterZone();

    try {
      return buildState();
    } finally {
      zone.attachInstance(instance);
    }
  }

  /// Executes the given [callback] function without tracking any state changes.
  /// This means that any state changes that occur inside the [callback] function
  /// will not trigger any side effects.
  ///
  /// The [callback] function should return a value of type [T].
  ///
  /// The returned value will be the result of the untracked operation.
  ///
  /// Example usage:
  /// ```dart
  /// final state = UseState(0);
  /// final computed = UseCompute(() => state.value + 1, [state]);
  ///
  /// Reactter.untracked(() {
  ///   state.value = 2;
  ///
  ///   print(computed.value); // 1 -> because the state change is not tracked
  /// });
  ///
  /// print(computed.value); // 1 -> because the state change is not tracked
  /// ```
  T untracked<T>(T callback()) {
    if (_isUntrackedRunning) {
      return callback();
    }

    try {
      _isUntrackedRunning = true;
      return callback();
    } finally {
      _isUntrackedRunning = false;
    }
  }

  /// Executes the given [callback] function within a batch operation.
  ///
  /// A batch operation allows multiple state changes to be grouped together,
  /// ensuring that any associated side effects are only triggered once,
  /// improving performance and reducing unnecessary re-renders.
  ///
  /// The [callback] function should return a value of type [T].
  /// The returned value will be the result of the batch operation.
  ///
  /// Example usage:
  /// ```dart
  /// final stateA = Signal(0);
  /// final stateB = UseState(0);
  /// final computed = UseCompute(
  ///   () => stateA.value + stateB.value,
  ///   [stateA, stateB],
  /// );
  ///
  /// Reactter.batch(() {
  ///   stateA.value = 1;
  ///   stateB.value = 2;
  ///
  ///   print(computed.value); // 0 -> because the batch operation is not completed yet.
  /// });
  ///
  /// print(computed.value); // 3 -> because the batch operation is completed.
  /// ```
  T batch<T>(T callback()) {
    if (_isBatchRunning) {
      return callback();
    }

    try {
      _isBatchRunning = true;
      return callback();
    } finally {
      _isBatchRunning = false;
      _endBatch();
    }
  }

  void _endBatch() {
    try {
      for (final event in _deferredEvents.entries) {
        final notifier = event.key;
        final param = event.value;
        notifier.notifyListeners(param);
      }
    } finally {
      _deferredEvents.clear();
    }
  }

  void _emitDefferred(Object? instance, Enum eventName, [dynamic param]) {
    _deferredEvents.putIfAbsent(
      Reactter._getEventNotifier(instance, eventName),
      () => param,
    );
  }
}
