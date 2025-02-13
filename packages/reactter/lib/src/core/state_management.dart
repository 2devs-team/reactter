part of '../internals.dart';

@internal
abstract class StateManagement<S extends IState> implements IContext {
  int _batchRunningCount = 0;
  bool get _isBatchRunning => _batchRunningCount > 0;

  int _untrackedRunningCount = 0;
  bool get _isUntrackedRunning => _untrackedRunningCount > 0;

  final LinkedHashMap<EventNotifier, Object?> _deferredEvents = LinkedHashMap();

  /// Creates a new state by invoking the provided `buildState` function.
  ///
  /// The `buildState` function should return an instance of a class that extends [IState].
  /// The created state is automatically bound to the current binding zone using `BindingZone.autoBinding`.
  ///
  /// Example usage:
  /// ```dart
  /// class MyState extends RtState<MyState> {
  ///   int _value = 0;
  ///   int get value => value;
  ///   set value(int n) {
  ///     if (n == _value) return;
  ///     update(() => _value = n);
  ///   }
  /// }
  ///
  /// final state = Rt.createState<MyState>(() => MyState());
  /// ```
  ///
  /// Returns the created state.
  T createState<T extends S>(T Function() buildState) {
    return BindingZone.autoBinding(buildState);
  }

  /// {@template reactter.lazy_state}
  /// Lazily initializes a state of type [IState] and attaches it to the given [instance].
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
  ///   late final computed = Rt.lazyState(
  ///     () => UseCompute(
  ///       () => stateA.value + stateB.value,
  ///       [stateA, stateB],
  ///     ),
  ///     this,
  ///   );
  /// }
  /// ```
  /// {@endtemplate}
  T lazyState<T extends S>(T Function() buildState, Object instance) {
    return BindingZone.autoBinding(buildState, instance);
  }

  /// {@template reactter.untracked}
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
  /// Rt.untracked(() {
  ///   state.value = 2;
  ///
  ///   print(computed.value); // 1 -> because the state change is not tracked
  /// });
  ///
  /// print(computed.value); // 1 -> because the state change is not tracked
  /// ```
  /// {@endtemplate}
  FutureOr<T> untracked<T>(FutureOr<T> Function() callback) async {
    try {
      _untrackedRunningCount++;

      return callback is Future Function() ? await callback() : callback();
    } finally {
      _untrackedRunningCount--;
    }
  }

  /// {@template reactter.batch}
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
  /// Rt.batch(() {
  ///   stateA.value = 1;
  ///   stateB.value = 2;
  ///
  ///   print(computed.value); // 0 -> because the batch operation is not completed yet.
  /// });
  ///
  /// print(computed.value); // 3 -> because the batch operation is completed.
  /// ```
  /// {@endtemplate}
  FutureOr<T> batch<T>(FutureOr<T> Function() callback) async {
    try {
      _batchRunningCount++;

      return callback is Future Function() ? await callback() : callback();
    } finally {
      _batchRunningCount--;

      if (_batchRunningCount == 0) {
        _endBatch();
      }
    }
  }

  void _endBatch() {
    for (final event in _deferredEvents.entries.toList(growable: false)) {
      final notifier = event.key;
      final param = event.value;

      if (_deferredEvents.isEmpty) {
        break;
      }

      if (_deferredEvents.containsKey(notifier)) {
        _deferredEvents.remove(notifier);

        if (!notifier._debugDisposed) {
          notifier.notifyListeners(param);
        }
      }
    }
  }

  void _emitDefferred(Object? instance, Enum eventName, [dynamic param]) {
    _deferredEvents.putIfAbsent(
      eventHandler._getEventNotifierFallback(instance, eventName),
      () => param,
    );
  }
}
