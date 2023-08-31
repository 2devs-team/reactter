// ignore_for_file: non_constant_identifier_names
part of '../framework.dart';

class _ReactterInterface with ReactterInstanceManager, ReactterEventManager {
  static final _reactterInterface = _ReactterInterface._();
  factory _ReactterInterface() => _reactterInterface;
  _ReactterInterface._();

  bool isInstancesBuilding = false;
  final _statesRecollected = <ReactterState>[];

  bool isLogEnable = true; //kDebugMode;
  LogWriterCallback log = defaultLogWriterCallback;

  /// It is used to create a new instance of a [ReactterState] class
  /// and attach it to a specific instance.
  T lazy<T extends ReactterState>(T Function() stateFn, Object instance) {
    ReactterState._instanceToAttach = instance;
    final state = stateFn();
    ReactterState._instanceToAttach = null;

    return state;
  }

  /// It is used for memoizing values([T])
  /// returned by a calcutate function([calculateValue]).
  ///
  /// This is an factorial example:
  ///
  /// ```dart
  /// late final factorial = Reactter.memo(calculateFactorial);
  ///
  /// BigInt calculateFactorial(Arg<int> args) {
  ///   final numero = args.arg;
  ///   if (numero == 0) return BigInt.one;
  ///   return BigInt.from(numero) * factorial(Arg(numero - 1));
  /// }
  ///
  /// void main() {
  ///   // Returns the result of multiplication of 1 to 50.
  ///   final f50 = factorial(const Arg(50));
  ///   // Returns the result immediately from cache
  ///   // because it was resolved in the previous line.
  ///   final f10 = factorial(const Arg(10));
  ///   // Returns the result of the multiplication of 51 to 100
  ///   // and 50! which is obtained from the cache.
  ///   final f100 = factorial(const Arg(100));
  ///
  ///   print(
  ///     'Results:\n'
  ///     '\t10!: $f10\n'
  ///     '\t50!: $f50\n'
  ///     '\t100!: $f100\n'
  ///   );
  /// }
  /// ```
  ///
  /// See also:
  ///
  /// * [Arg], a class which represents the arguments received by
  /// the function([calculateValue]), and also used as a cache value binding.
  T Function(A) memo<T, A extends Arg?>(T Function(A) calculateValue) {
    return ReactterMemo<T, A>(calculateValue).call;
  }
}

final Reactter = _ReactterInterface();
