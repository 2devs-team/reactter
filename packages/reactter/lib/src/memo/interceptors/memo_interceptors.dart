part of '../../memo.dart';

/// It allows multiple memoization interceptors to be used together.
class MemoInterceptors<T, A extends Args?> extends MemoInterceptor<T, A> {
  final List<MemoInterceptor<T, A>> interceptors;

  /// It allows multiple memoization interceptors to be used together.
  const MemoInterceptors(this.interceptors);

  @override
  void onInit(Memo<T, A> memo, A args) {
    for (final interceptor in interceptors) {
      interceptor.onInit(memo, args);
    }
  }

  @override
  void onValue(Memo<T, A> memo, A args, T value, bool fromCache) {
    for (final interceptor in interceptors) {
      interceptor.onValue(memo, args, value, fromCache);
    }
  }

  @override
  void onError(Memo<T, A> memo, A args, Object error) {
    for (final interceptor in interceptors) {
      interceptor.onError(memo, args, error);
    }
  }

  @override
  void onFinish(Memo<T, A> memo, A args) {
    for (final interceptor in interceptors) {
      interceptor.onFinish(memo, args);
    }
  }
}
