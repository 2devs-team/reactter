import 'package:reactter/src/hooks.dart';

import 'internals.dart';

/// A function to generate the instance of [T]
typedef ContextBuilder<T> = T Function();

/// Reactter.log type
typedef LogWriterCallback = void Function(String text, {bool isError});

/// UseAsyncState.when's parameter type for representing a value
typedef WhenValueReturn<T, R> = R Function(T value);

/// UseAsyncState.when's parameter type for representing a error
typedef WhenErrorReturn<R> = R Function(Object? value);
typedef CallbackEvent<T extends Object?, P> = void Function(T? inst, P param);
typedef Reducer<T> = T Function(T state, ReactterAction action);
typedef EventEmit<T> = void Function(Enum eventName, [dynamic param]);
typedef AsyncFunction<T> = Future<T> Function();
typedef AsyncFunctionArg<T, A extends Arg?> = Future<T> Function(A arg);
typedef ArgsX2<T> = Args2<T, T>;
typedef ArgsX3<T> = Args3<T, T, T>;
