part of '../memo.dart';

/// A class callable that is used for memoizing values([T])
/// returned by a calcutate function([calculateValue]).
///
/// This is a factorial example:
///
/// ```dart
/// late final factorial = Memo(calculateFactorial);
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
class Memo<T, A extends Args?> {
  // Stores memoized values, where the keys are hashCode
  // and the values are of type [T].
  final _cache = HashMap<int, T>();

  /// It's used to store the function that will be memoized.
  final FunctionArgs<T, A> _calculateValue;

  /// It allows you to provide a custom interceptor object that can intercept
  /// and handle various events during the memoization process.
  final MemoInterceptor<T, A>? _interceptor;

  Memo(
    FunctionArgs<T, A> calculateValue, [
    MemoInterceptor<T, A>? interceptor,
  ])  : _calculateValue = calculateValue,
        _interceptor = interceptor;

  /// Creates a memoized function version. It´s used for memoizing values([T])
  /// returned by a calcutate function([calculateValue]).
  ///
  /// This is a factorial example:
  ///
  /// ```dart
  /// late final factorial = Memo.inline(calculateFactorial);
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
  static FunctionMemo<T, A> inline<T, A extends Args?>(
    FunctionArgs<T, A> calculateValue, [
    MemoInterceptor<T, A>? interceptor,
  ]) =>
      Memo<T, A>(calculateValue, interceptor).call;

  /// Invokes the [calculateValue] with the given [args],
  /// then stores and returns the resolved value.
  ///
  /// The provided [args] represent the dependencies that bind the cached value,
  /// so if it has already been resolved,
  /// the value is immediately returned from the cache.
  ///
  /// Set [overrideCache] to `true` to ignore the cached value
  /// and re-call the [calculateValue].
  T call(A args, {bool overrideCache = false}) {
    _interceptor?.onInit(this, args);

    final hashCode = _getHashCode(args);

    if (!overrideCache && _cache.containsKey(hashCode)) {
      final valueCached = _cache[hashCode] as T;

      _interceptor?.onValue(this, args, valueCached, true);
      _interceptor?.onFinish(this, args);

      return valueCached;
    }

    try {
      final valueCalculated = _calculateValue(args);

      _cache[hashCode] = valueCalculated;

      _interceptor?.onValue(this, args, valueCalculated, false);
      _interceptor?.onFinish(this, args);

      return valueCalculated;
    } catch (error) {
      _interceptor?.onError(this, args, error);
      _interceptor?.onFinish(this, args);

      rethrow;
    }
  }

  /// Returns the cached value by [args].
  T? get(A args) => _cache[_getHashCode(args)];

  /// Removes the cached value by [args].
  T? remove(A args) => _cache.remove(_getHashCode(args));

  /// Removes all cached data.
  void clear() => _cache.clear();

  int _getHashCode(A args) {
    return args == null ? null.hashCode : Object.hashAll(args.arguments);
  }
}
