library reactter;

typedef UpdateCallback<T> = void Function(T newValue, T oldValue);
typedef FutureVoidCallback = Future<void> Function();
