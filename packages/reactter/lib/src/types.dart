import 'dart:async';

import 'args.dart';
import 'hooks/hooks.dart';
import 'memo/memo.dart' show Memo;

/// {@template log_output}
/// An function to specify the log output destination.
///
///   - [message]: The log message.
///   - [name]: The name of the logger.
///   - [level]: The integer value of the [LogLevel].
///   - [stackTrace]: The stack trace of the log message.
/// {@endtemplate}
typedef LogOutput = void Function(
  String message, {
  String name,
  int level,
  StackTrace? stackTrace,
});

/// A function to generate the instance of [T] dependency.
typedef InstanceBuilder<T> = T Function();

/// UseAsyncState.when's parameter type for representing a value
typedef WhenValueReturn<T, R> = R Function(T value);

/// UseAsyncState.when's parameter type for representing a error
typedef WhenErrorReturn<R> = R Function(Object? value);

/// to represent an event callback
typedef CallbackEvent<T extends Object?, P> = Function(T? inst, P param);

/// to represent a reducer method
typedef Reducer<T> = T Function(T state, RtAction action);

/// to represent an async function without arguments
typedef AsyncFunction<T> = FutureOr<T> Function();

/// to represent an async function with arguments
typedef AsyncFunctionArg<T, A> = Future<T> Function(A arg);

/// to represent a function with arguments
typedef FunctionArg<T, A> = T Function(A arg);

// to represent two arguments of the same type
typedef ArgsX2<T> = Args2<T, T>;

// to represent three arguments of the same type
typedef ArgsX3<T> = Args3<T, T, T>;

// function memo type
typedef FunctionMemo<T, A> = T Function(A, {bool overrideCache});

typedef FunctionArgMemo<T, A> = void Function(Memo<T, A> memo, A arg);

typedef FunctionValueMemo<T, A> = void Function(
  Memo<T, A> memo,
  A arg,
  T value,
  bool fromCache,
);

typedef FunctionErrorMemo<T, A> = void Function(
  Memo<T, A> memo,
  A arg,
  Object error,
);
