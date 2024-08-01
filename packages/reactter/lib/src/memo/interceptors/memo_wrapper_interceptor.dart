part of '../memo.dart';

/// {@template reactter.memo_wrapper_interceptor}
/// It´s a wrapper for a memoized function that allows you to define
/// callbacks for initialization, successful completion,
/// error handling, and finishing.
/// {@endtemplate}
class MemoWrapperInterceptor<T, A> extends MemoInterceptor<T, A> {
  /// It's called when the memoized function is invoked
  /// for the first time with a new set of arguments.
  /// It allows you to perform any initialization logic
  /// or side effects before the calculation is performed.
  final FunctionArgMemo<T, A>? _onInit;

  /// It's called after the memoized function has completed its execution.
  final FunctionValueMemo<T, A>? _onValue;

  /// It's called when an error occurs during
  /// the execution of the memoized function.
  final FunctionErrorMemo<T, A>? _onError;

  /// It's called after the memoized function has completed its execution,
  /// regardless of whether it was successful or encountered an error.
  final FunctionArgMemo<T, A>? _onFinish;

  /// {@macro reactter.memo_wrapper_interceptor}
  const MemoWrapperInterceptor({
    FunctionArgMemo<T, A>? onInit,
    FunctionValueMemo<T, A>? onValue,
    FunctionErrorMemo<T, A>? onError,
    FunctionArgMemo<T, A>? onFinish,
  })  : _onInit = onInit,
        _onValue = onValue,
        _onError = onError,
        _onFinish = onFinish;

  @override
  void onInit(Memo<T, A> memo, A arg) {
    _onInit?.call(memo, arg);
  }

  @override
  void onValue(Memo<T, A> memo, A arg, T value, bool fromCache) {
    _onValue?.call(memo, arg, value, fromCache);
  }

  @override
  void onError(Memo<T, A> memo, A arg, Object error) {
    _onError?.call(memo, arg, error);
  }

  @override
  void onFinish(Memo<T, A> memo, A arg) {
    _onFinish?.call(memo, arg);
  }
}

/// {@macro reactter.memo_wrapper_interceptor}
@Deprecated(
  'Use `MemoWrapperInterceptor` instead. '
  'This feature was deprecated after v7.3.0.',
)
typedef MemoInterceptorWrapper<T, A> = MemoWrapperInterceptor<T, A>;
