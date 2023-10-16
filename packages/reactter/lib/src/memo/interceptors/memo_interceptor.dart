part of '../../memo.dart';

/// It allows for intercepting and memoizing function calls.
abstract class MemoInterceptor<T, A extends Args?> {
  const MemoInterceptor();

  /// It's called when the memoized function is invoked
  /// for the first time with a new set of arguments.
  /// It allows you to perform any initialization logic
  /// or side effects before the calculation is performed.
  void onInit(Memo<T, A> memo, A args) {}

  /// It's called after the memoized function has completed its execution.
  void onValue(Memo<T, A> memo, A args, T value, bool fromCache) {}

  /// It's called when an error occurs during
  /// the execution of the memoized function.
  void onError(Memo<T, A> memo, A args, Object error) {}

  /// It's called after the memoized function has completed its execution,
  /// regardless of whether it was successful or encountered an error.
  void onFinish(Memo<T, A> memo, A args) {}
}