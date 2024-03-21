part of 'memo.dart';

/// {@template memo}
/// A class callable that is used for memoizing values([T])
/// returned by a calcutate function([calculateValue]).
///
/// This is a factorial example:
///
/// ```dart
/// late final factorial = Memo(calculateFactorial);
///
/// BigInt calculateFactorial(Args<int> args) {
///   final numero = args.arg;
///   if (numero == 0) return BigInt.one;
///   return BigInt.from(numero) * factorial(Args(numero - 1));
/// }
///
/// void main() {
///   // Returns the result of multiplication of 1 to 50.
///   final f50 = factorial(const Args(50));
///   // Returns the result immediately from cache
///   // because it was resolved in the previous line.
///   final f10 = factorial(const Args(10));
///   // Returns the result of the multiplication of 51 to 100
///   // and 50! which is obtained from the cache.
///   final f100 = factorial(const Args(100));
///
///   print(
///     'Results:\n'
///     '\t10!: $f10\n'
///     '\t50!: $f50\n'
///     '\t100!: $f100\n'
///   );
/// }
/// ```
/// {@endtemplate}
class Memo<T, A> {
  // Stores memoized values, where the keys are hashCode
  // and the values are of type [T].
  final _cache = HashMap<int, T>();

  /// It's used to store the function that will be memoized.
  final FunctionArg<T, A> _computeValue;

  /// It allows you to provide a custom interceptor object that can intercept
  /// and handle various events during the memoization process.
  final MemoInterceptor<T, A>? _interceptor;

  /// {@macro memo}
  Memo(
    FunctionArg<T, A> computeValue, [
    MemoInterceptor<T, A>? interceptor,
  ])  : _computeValue = computeValue,
        _interceptor = interceptor;

  /// Creates a memoized function version. It´s used for memoizing values([T])
  /// returned by a calcutate function([computeValue]).
  ///
  /// This is a factorial example:
  ///
  /// ```dart
  /// late final factorial = Memo.inline(calculateFactorial);
  ///
  /// BigInt calculateFactorial(Args<int> args) {
  ///   final numero = args.arg;
  ///   if (numero == 0) return BigInt.one;
  ///   return BigInt.from(numero) * factorial(Args(numero - 1));
  /// }
  ///
  /// void main() {
  ///   // Returns the result of multiplication of 1 to 50.
  ///   final f50 = factorial(const Args(50));
  ///   // Returns the result immediately from cache
  ///   // because it was resolved in the previous line.
  ///   final f10 = factorial(const Args(10));
  ///   // Returns the result of the multiplication of 51 to 100
  ///   // and 50! which is obtained from the cache.
  ///   final f100 = factorial(const Args(100));
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
  /// the function([computeValue]), and also used as a cache value binding.
  static FunctionMemo<T, A> inline<T, A>(
    FunctionArg<T, A> computeValue, [
    MemoInterceptor<T, A>? interceptor,
  ]) =>
      Memo<T, A>(computeValue, interceptor).call;

  /// Invokes the [calculateValue] with the given [arg],
  /// then stores and returns the resolved value.
  ///
  /// The provided [arg] represent the dependencies that bind the cached value,
  /// so if it has already been resolved,
  /// the value is immediately returned from the cache.
  ///
  /// Set [overrideCache] to `true` to ignore the cached value
  /// and re-call the [calculateValue].
  T call(A arg, {bool overrideCache = false}) {
    _interceptor?.onInit(this, arg);

    if (!overrideCache && _cache.containsKey(arg.hashCode)) {
      final valueCached = _cache[arg.hashCode] as T;

      _interceptor?.onValue(this, arg, valueCached, true);
      _interceptor?.onFinish(this, arg);

      return valueCached;
    }

    try {
      final valueCalculated = _computeValue(arg);

      _cache[arg.hashCode] = valueCalculated;

      _interceptor?.onValue(this, arg, valueCalculated, false);
      _interceptor?.onFinish(this, arg);

      return valueCalculated;
    } catch (error) {
      _interceptor?.onError(this, arg, error);
      _interceptor?.onFinish(this, arg);

      rethrow;
    }
  }

  /// Returns the cached value by [arg].
  T? get(A arg) => _cache[arg.hashCode];

  /// Removes the cached value by [arg].
  T? remove(A arg) => _cache.remove(arg.hashCode);

  /// Removes all cached data.
  void clear() => _cache.clear();
}
