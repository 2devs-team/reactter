import 'dart:async';

import 'package:reactter/src/hooks.dart';

import 'framework.dart';

/// A function to generate the instance of [T]
typedef InstanceBuilder<T> = T Function();

/// Reactter.log type
typedef LogWriterCallback = void Function(String text, {bool isError});

/// UseAsyncState.when's parameter type for representing a value
typedef WhenValueReturn<T, R> = R Function(T value);

/// UseAsyncState.when's parameter type for representing a error
typedef WhenErrorReturn<R> = R Function(Object? value);

/// to represent an event callback
typedef CallbackEvent<T extends Object?, P> = void Function(T? inst, P param);

/// to represent a reducer method
typedef Reducer<T> = T Function(T state, ReactterAction action);

/// to represent an async function without arguments
typedef AsyncFunction<T> = FutureOr<T> Function();

/// to represent an async function with arguments
typedef AsyncFunctionArgs<T, A extends Args?> = FutureOr<T> Function(A arg);

/// to represent a function with arguments
typedef FunctionArgs<T, A extends Args?> = T Function(A arg);

// to represent two arguments of the same type
typedef ArgsX2<T> = Args2<T, T>;

// to represent three arguments of the same type
typedef ArgsX3<T> = Args3<T, T, T>;

// function memo type
typedef MemoFunction<T, A extends Args?> = T Function(A, {bool overrideCache});
