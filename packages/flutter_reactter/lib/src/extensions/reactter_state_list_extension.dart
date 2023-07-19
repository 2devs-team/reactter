part of '../extensions.dart';

extension ReactterStateListExtension<E extends ReactterState> on List<E> {
  /// Takes multiple conditions as arguments and returns a list of
  /// [UseCompute] objects based on those conditions.
  ///
  /// Generally, it's used to listen for conditional states using [context.watch]:
  ///
  /// ```dart
  /// context.watch<AppController>(
  ///   (inst) => [inst.stateA, inst.stateB].when(
  ///     () => inst.stateA.value == inst.stateB.value, // condition
  ///     // The following condition functions as `or` like:
  ///     // condition || condition2 || condition3
  ///     () => inst.stateA.value == 'X', // condition2
  ///     () => inst.stateB.value == 'Y', // condition3
  ///   ),
  /// );
  /// ```
  List<UseCompute> when(
    dynamic Function() condition, [
    dynamic Function()? condition2,
    dynamic Function()? condition3,
    dynamic Function()? condition4,
    dynamic Function()? condition5,
  ]) {
    return [condition, condition2, condition3, condition4, condition5]
        .whereType<dynamic Function()>()
        .map((condition) => UseCompute(condition, this))
        .toList();
  }
}
