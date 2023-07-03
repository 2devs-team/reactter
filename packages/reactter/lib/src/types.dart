import 'package:reactter/src/hooks.dart';

/// A function to generate the instance of [T]
typedef ContextBuilder<T> = T Function();

typedef LogWriterCallback = void Function(String text, {bool isError});

typedef AsyncFunction<T, A> = Future<T> Function([A arg]);

typedef WhenValueReturn<T, R> = R Function(T value);

typedef WhenErrorReturn<R> = R Function(Object? value);

typedef CallbackEvent<T extends Object?, P> = void Function(T? inst, P param);

typedef Reducer<T> = T Function(T state, ReactterAction action);

typedef EventEmit<T> = void Function(Enum eventName, [dynamic param]);
