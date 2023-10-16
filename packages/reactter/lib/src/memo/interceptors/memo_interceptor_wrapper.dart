part of '../../memo.dart';

/// It´s a wrapper for a memoized function that allows you to define
/// callbacks for initialization, successful completion,
/// error handling, and finishing.
class MemoInterceptorWrapper<T, A extends Args?> extends MemoInterceptor<T, A> {
  /// It's called when the memoized function is invoked
  /// for the first time with a new set of arguments.
  /// It allows you to perform any initialization logic
  /// or side effects before the calculation is performed.
  final FunctionArgsMemo<T, A>? _onInit;

  /// It's called after the memoized function has completed its execution.
  final FunctionValueMemo<T, A>? _onValue;

  /// It's called when an error occurs during
  /// the execution of the memoized function.
  final FunctionErrorMemo<T, A>? _onError;

  /// It's called after the memoized function has completed its execution,
  /// regardless of whether it was successful or encountered an error.
  final FunctionArgsMemo<T, A>? _onFinish;

  const MemoInterceptorWrapper({
    FunctionArgsMemo<T, A>? onInit,
    FunctionValueMemo<T, A>? onValue,
    FunctionErrorMemo<T, A>? onError,
    FunctionArgsMemo<T, A>? onFinish,
  })  : _onInit = onInit,
        _onValue = onValue,
        _onError = onError,
        _onFinish = onFinish;

  @override
  void onInit(Memo<T, A> memo, A args) {
    _onInit?.call(memo, args);
  }

  @override
  void onValue(Memo<T, A> memo, A args, T value, bool fromCache) {
    _onValue?.call(memo, args, value, fromCache);
  }

  @override
  void onError(Memo<T, A> memo, A args, Object error) {
    _onError?.call(memo, args, error);
  }

  @override
  void onFinish(Memo<T, A> memo, A args) {
    _onFinish?.call(memo, args);
  }
}
