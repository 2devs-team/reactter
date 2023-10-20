part of '../../memo.dart';

/// It's a memoization interceptor that removes memoized values from the
/// cache after a specified duration.
class TemporaryCacheMemo<T, A> extends MemoInterceptor<T, A> {
  /// It's used to store the duration for which the memoized values
  /// should be kept in the cache before being removed.
  final Duration duration;

  const TemporaryCacheMemo(this.duration);

  void onValue(Memo<T, A> memo, A arg, T value, bool fromCache) {
    if (!fromCache) {
      Future.delayed(duration, () => memo.remove(arg));
    }
  }
}
