part of '../framework.dart';

/// A class callable that is used for memoizing values([T])
/// returned by a calcutate function([calculateValue]).
///
/// This is an factorial example:
///
/// ```dart
/// late final factorial = ReactterMemo(calculateFactorial);
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
/// * [Args], a class which represents the arguments received by
/// the function([calculateValue]), and also used as a cache value binding.
class ReactterMemo<T, A extends Args?> {
  // Stores memoized values, where the keys are hashCode
  //and the values are of type [T].
  final _cache = HashMap<int, T>();

  /// This variable is used to store the function that will be memoized.
  final FunctionArgs<T, A> calculateValue;

  ReactterMemo(this.calculateValue);

  /// Invokes the [calculateValue] with the given [arg],
  /// then stores and returns the resolved value.
  ///
  /// The provided [arg] represent the dependencies that bind the cached value,
  /// so if it has already been resolved,
  /// the value is immediately returned from the cache.
  ///
  /// Set [overrideCache] to true to ignore the cached value
  /// and re-call the [calculateValue].
  T call(A arg, {bool overrideCache = false}) {
    final hashCode = _getHashCode(arg);

    if (!overrideCache && _cache.containsKey(hashCode)) {
      return _cache[hashCode] as T;
    }

    final futureOrValueReturned = calculateValue.call(arg);

    _cache[hashCode] = futureOrValueReturned;

    return futureOrValueReturned;
  }

  /// Removes the cached value by arg
  T? remove(A arg) {
    final hashCode = _getHashCode(arg);

    return _cache.remove(hashCode);
  }

  /// Removes all cached data.
  void clear() => _cache.clear();

  int _getHashCode(A arg) {
    return arg == null ? null.hashCode : Object.hashAll(arg.arguments);
  }
}

extension ReactterMemoShortcuts on ReactterInterface {
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
  /// * [Args], a class which represents the arguments received by
  /// the function([calculateValue]), and also used as a cache value binding.
  MemoFunction<T, A> memo<T, A extends Args?>(
    FunctionArgs<T, A> calculateValue,
  ) {
    return ReactterMemo<T, A>(calculateValue).call;
  }
}
