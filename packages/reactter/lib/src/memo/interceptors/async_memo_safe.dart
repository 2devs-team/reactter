part of '../../memo.dart';

/// It's a memoization interceptor that prevents saving in cache
/// if the `Future` calculation function throws an error when executed.
class AsyncMemoSafe<T, A> extends MemoInterceptor<T, A> {
  const AsyncMemoSafe();

  @override
  void onValue(Memo<T, A> memo, A arg, T value, bool fromCache) {
    if (!fromCache && value is Future) {
      value.catchError((_) {
        memo.remove(arg);
      });
    }
  }
}
