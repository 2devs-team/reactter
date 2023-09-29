part of '../framework.dart';

/// A class callable that is used for memoizing values([T])
/// returned by a calcutate function([calculateValue]).
///
/// This is a factorial example:
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
  // and the values are of type [T].
  final _cache = HashMap<int, T>();

  /// It's used to store the function that will be memoized.
  final FunctionArgs<T, A> calculateValue;

  /// It's called when the memoized function is invoked
  /// for the first time with a new set of arguments.
  /// It allows you to perform any initialization logic
  /// or side effects before the calculation is performed.
  ///
  /// It takes the arguments:
  //
  /// - [args]: the arguments passed to the memoized function.
  final void Function(A args)? onInit;

  /// It's called when an error occurs during
  /// the execution of the memoized function.
  ///
  /// It takes two arguments:
  ///
  /// - [args]: the arguments passed to the memoized function.
  /// - [error]: the error that occurred.
  final void Function(A args, Object error)? onError;

  /// It's called after the memoized function has completed its execution.
  ///
  /// It takes three arguments:
  ///
  /// - [args]: the arguments passed to the memoized function.
  /// - [value]: the value returned by the memoized function.
  /// - [fromCache]: indicates whether the value returned
  /// is taken from the cache.
  final void Function(A args, T value, bool fromCache)? onComplete;

  /// It's called after the memoized function has completed its execution,
  /// regardless of whether it was successful or encountered an error.
  ///
  /// It takes the arguments:
  ///
  /// - [args]: the arguments passed to the memoized function.
  final void Function(A args)? onFinish;

  /// It's a function that determines whether the cache should be removed when
  /// an error occurs during the execution of a memoized function that returns a
  /// `Future`.
  ///
  /// It takes two arguments:
  ///
  /// - [args]: the arguments passed to the memoized function.
  /// - [error]: the error that occurred.
  ///
  /// If not defined, the cached value will be removed whenever an error occurs.
  final bool Function(A args, Object error)? futureErrorShouldRemoveCache;

  ReactterMemo(
    this.calculateValue, {
    this.onInit,
    this.onError,
    this.onComplete,
    this.onFinish,
    this.futureErrorShouldRemoveCache,
  });

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
    onInit?.call(args);

    final hashCode = _getHashCode(args);

    if (!overrideCache && _cache.containsKey(hashCode)) {
      final valueCached = _cache[hashCode] as T;

      onComplete?.call(args, valueCached, true);
      onFinish?.call(args);

      return valueCached;
    }

    try {
      final valueCalculated = calculateValue.call(args);

      _cache[hashCode] = valueCalculated;

      if (valueCalculated is Future) {
        valueCalculated.catchError((error) {
          if (futureErrorShouldRemoveCache?.call(args, error) ?? true) {
            remove(args);
          }
        });
      }

      onComplete?.call(args, valueCalculated, false);
      onFinish?.call(args);

      return valueCalculated;
    } catch (error) {
      onError?.call(args, error);
      onFinish?.call(args);

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

extension ReactterMemoShortcuts on ReactterInterface {
  /// It is used for memoizing values([T])
  /// returned by a calcutate function([calculateValue]).
  ///
  /// This is a factorial example:
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
    FunctionArgs<T, A> calculateValue, {
    void Function(A args)? onInit,
    void Function(A args, Object error)? onError,
    void Function(A args, T value, bool fromCache)? onComplete,
    void Function(A args)? onFinish,
    bool Function(A args, Object error)? futureErrorShouldRemoveCache,
  }) {
    return ReactterMemo<T, A>(
      calculateValue,
      onInit: onInit,
      onError: onError,
      onComplete: onComplete,
      onFinish: onFinish,
      futureErrorShouldRemoveCache: futureErrorShouldRemoveCache,
    ).call;
  }
}
