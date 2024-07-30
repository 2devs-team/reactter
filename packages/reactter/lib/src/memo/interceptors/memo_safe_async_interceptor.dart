part of '../memo.dart';

/// {@template reactter.memo_safe_async_interceptor}
/// It's a memoization interceptor that prevents saving in cache
/// if the `Future` calculation function throws an error when executed.
/// {@endtemplate}
class MemoSafeAsyncInterceptor<T, A> extends MemoInterceptor<T, A> {
  /// {@macro reactter.memo_safe_async_interceptor}
  const MemoSafeAsyncInterceptor();

  @override
  void onValue(Memo<T, A> memo, A arg, T value, bool fromCache) {
    if (!fromCache && value is Future) {
      value.catchError((_) {
        memo.remove(arg);
      });
    }
  }
}

/// {@macro reactter.memo_safe_async_interceptor}
@Deprecated('Use `MemoSafeAsyncInterceptor` instead.')
typedef AsyncMemoSafe<T, A> = MemoSafeAsyncInterceptor<T, A>;
