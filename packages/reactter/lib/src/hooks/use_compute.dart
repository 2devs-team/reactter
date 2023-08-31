part of '../hooks.dart';

/// A [ReactterHook] that allows to compute a value
/// using a predetermined [compute] function and a list of state [dependencies],
/// and which automatically updates the computed [value] if a dependency changes.
///
/// This example produces one simple [UseCompute]:
/// ```dart
/// class AppController {
///   final stateA = UseState(1);
///   final stateB = UseState(7);
///   late final computeState = UseCompute(
///     () => (stateA + stateB).clamp(10, 15),
///     [stateA, stateB],
///   );
///
///   AppController() {
///     print(computeState.value); // 10;
///
///     UseEffect((){
///       print(computeState.value);
///       // will print: 11, 15, 11
///     }, [computeState]);
///
///     stateA.value += 1; // numClamp doesn't change, its value is 10
///     stateB.value += 2; // numClamp changes, its value is 11
///     stateA.value += 4; // numClamp changes, its value is 15
///     stateB.value += 8; // numClamp doesn't change, its value is 15
///     stateA.value -= 8; // numClamp doesn't change, its value is 15
///     stateB.value -= 4; // numClamp changes, its value is 11
///   }
/// }
/// ```
///
class UseCompute<T> extends ReactterHook {
  @protected
  @override
  final $ = ReactterHook.$register;

  late T _valueComputed;
  final T Function() compute;
  final List<ReactterState> dependencies;

  T get value => _valueComputed;

  UseCompute(
    this.compute,
    this.dependencies,
  ) {
    _valueComputed = compute();

    for (var dependency in dependencies) {
      Reactter.on(dependency, Lifecycle.didUpdate, _onDependencyChanged);
    }
  }

  @override
  void dispose() {
    for (var dependency in dependencies) {
      Reactter.off(dependency, Lifecycle.didUpdate, _onDependencyChanged);
    }

    super.dispose();
  }

  void _onDependencyChanged(_, __) {
    final valueComputed = compute();

    if (valueComputed != _valueComputed) {
      update(() => _valueComputed = valueComputed);
    }
  }
}
