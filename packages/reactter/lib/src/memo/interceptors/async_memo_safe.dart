part of '../../memo.dart';

/// It's a memoization interceptor that removes memoized values
/// if its futures that throw an error when executed.
class AsyncMemoSafe<T, A extends Args?> extends MemoInterceptor<T, A> {
  const AsyncMemoSafe();

  @override
  void onValue(Memo<T, A> memo, A args, T value, bool fromCache) {
    if (!fromCache && value is Future) {
      value.catchError((_) {
        memo.remove(args);
      });
    }
  }
}
