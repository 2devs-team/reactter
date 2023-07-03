part of '../hooks.dart';

/// A [ReactterHook] that allows to compute a value
/// using a predetermined [compute] function and a list of state [dependencies],
/// and which automatically updates the computed [value] if a dependency changes.
///
/// This example produces one simple [UseCompute]:
/// ```dart
/// class AppController {
///   final numA = UseState(1);
///   final numB = UseState(7);
///   final numClamp = UseCompute(
///     () => (numA + numB).clamp(10, 15),
///     [numA, numB],
///   );
///
///   AppController() {
///     print(numClamp.value); // 10;
///
///     UseEffect((){
///       print(numClamp.value);
///       // will print: 11, 15, 11
///     }, [numClamp]);
///
///     numA.value += 1; // numClamp doesn't change, its value is 10
///     numB.value += 2; // numClamp changes, its value is 11
///     numA.value += 4; // numClamp changes, its value is 15
///     numB.value += 8; // numClamp doesn't change, its value is 15
///     numA.value -= 8; // numClamp doesn't change, its value is 15
///     numB.value -= 4; // numClamp changes, its value is 11
///   }
/// }
/// ```
///
class UseCompute<T> extends ReactterHook {
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
