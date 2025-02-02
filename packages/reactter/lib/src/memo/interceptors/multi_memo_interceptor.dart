part of '../memo.dart';

/// {@template reactter.memo_multi_interceptor}
/// It allows multiple memoization interceptors to be used together.
/// {@endtemplate}
class MultiMemoInterceptor<T, A> extends MemoInterceptor<T, A> {
  final List<MemoInterceptor<T, A>> interceptors;

  /// {@macro reactter.memo_multi_interceptor}
  const MultiMemoInterceptor(this.interceptors);

  @override
  void onInit(Memo<T, A> memo, A arg) {
    for (final interceptor in interceptors) {
      interceptor.onInit(memo, arg);
    }
  }

  @override
  void onValue(Memo<T, A> memo, A arg, T value, bool fromCache) {
    for (final interceptor in interceptors) {
      interceptor.onValue(memo, arg, value, fromCache);
    }
  }

  @override
  void onError(Memo<T, A> memo, A arg, Object error) {
    for (final interceptor in interceptors) {
      interceptor.onError(memo, arg, error);
    }
  }

  @override
  void onFinish(Memo<T, A> memo, A arg) {
    for (final interceptor in interceptors) {
      interceptor.onFinish(memo, arg);
    }
  }
}
