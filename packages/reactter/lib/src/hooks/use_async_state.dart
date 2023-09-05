part of '../hooks.dart';

enum UseAsyncStateStatus {
  standby,
  loading,
  done,
  error,
}

abstract class _UseAsyncStateAbstract<T> extends ReactterHook {
  @protected
  @override
  final $ = ReactterHook.$register;

  /// Works as a the [value] initializer.
  /// Need to call [resolve] to execute.
  @protected
  final Function _asyncFunction;

  final UseState<T> _value;
  final _error = UseState<Object?>(null);
  final _status = UseState(UseAsyncStateStatus.standby);

  T get value => _value.value;
  Object? get error => _error.value;
  UseAsyncStateStatus get status => _status.value;

  _UseAsyncStateAbstract(T initialValue, Function asyncFunction)
      : _asyncFunction = asyncFunction,
        _value = UseState(initialValue);

  /// Execute [asyncFunction] to resolve [value].
  FutureOr<T?> _resolve([args]) async {
    try {
      _status.value = UseAsyncStateStatus.loading;

      final asyncFunctionExecuting =
          args == null ? _asyncFunction() : _asyncFunction(args);

      _value.value = await asyncFunctionExecuting;
      _status.value = UseAsyncStateStatus.done;

      return _value.value;
    } catch (e) {
      _error.value = e;
      _status.value = UseAsyncStateStatus.error;

      return null;
    }
  }

  /// Returns a new value of [R] depending on the state of the hook:
  ///
  /// `standby`: When the state has the initial value.
  /// `loading`: When the request for the state is retrieving the value.
  /// `done`: When the request is done.
  /// `error`: If any errors happens in the request.
  ///
  /// For example:
  ///
  /// ```dart
  /// final valueComputed = appController.asyncState.when<String>(
  ///   standby: (value) => "⚓️ Standby: ${value}",
  ///   loading: (value) => "⏳ Loading...",
  ///   done: (value) => "✅ Resolved: ${value}",
  ///   error: (error) => "❌ Error: ${error}",
  /// )
  /// ```
  R? when<R>({
    WhenValueReturn<T, R>? standby,
    WhenValueReturn<T, R>? loading,
    WhenValueReturn<T, R>? done,
    WhenErrorReturn<R>? error,
  }) {
    if (status == UseAsyncStateStatus.error) {
      return error?.call(this.error);
    }

    if (status == UseAsyncStateStatus.loading) {
      return loading?.call(value);
    }

    if (status == UseAsyncStateStatus.done) {
      return done?.call(value);
    }

    return standby?.call(value);
  }

  /// Reset [value], [status] and [error] to its [initial] state.
  void reset() {
    _value.reset();
    _error.reset();
    _status.reset();
  }
}

/// A [ReactteHook] that manages the state as async way.
///
/// [T] is use to define the type of [value].
///
/// This example produces one simple [UseAsyncState]:
///
/// ```dart
/// class AppController {
///   // It's same that: UseAsyncState<String>
///   final asyncState = UseAsyncState(
///     "Initial value",
///     () => Future.delayed(
///       const Duration(seconds: 1),
///       () => "Resolved value"
///     );
///   }
/// }
/// ```
///
/// Use the [resolve] method to resolve state
/// and use the [value] getter to get state:
///
/// ```dart
///   // Before changed value: "Initial value"
///   print('Before changed value: "${appController.asyncState.value}"');
///   // Resolve state
///   await appController.asyncState.resolve();
///   // After changed value: "Resolved value"
///   print('After changed value: "${appController.asyncState.value}"');
/// ```
///
/// It also has the [when] method that returns a new value
/// depending on it's state:
///
/// ```dart
/// final valueComputed = appController.asyncState.when<String>(
///   standby: (value) => "⚓️ Standby: $value",
///   loading: (value) => "⏳ Loading...",
///   done: (value) => "✅ Resolved: $value",
///   error: (error) => "❌ Error: $error",
/// );
/// ```
///
/// Its status may be obtained using the getters [value] and [error],
/// and restore it to its [initial] state using the [reset] method.
///
/// See also:
///
/// * [UseAsyncStateArgs], the same as it, but with arguments.
class UseAsyncState<T> extends _UseAsyncStateAbstract<T> {
  UseAsyncState(
    T initialValue,
    AsyncFunction<T> asyncFunction,
  ) : super(initialValue, asyncFunction);

  static UseAsyncStateArgs<T, A> withArgs<T, A extends Args?>(
    T initialValue,
    AsyncFunctionArgs<T, A> asyncFunction,
  ) {
    return UseAsyncStateArgs<T, A>(initialValue, asyncFunction);
  }

  /// Execute [asyncFunction] to resolve [value].
  FutureOr<T?> resolve() async {
    return _resolve();
  }
}

/// A [ReactteHook] that manages the state as async way.
///
/// [T] is use to define the type of [value]
/// and [A] is use to define the type of [resolve] argument.
///
/// This example produces one simple [UseAsyncStateArgs]:
///
/// ```dart
/// class AppController {
///   // It's same that: UseAsyncStateArgs<String, Args1<String>>
///   final asyncState = UseAsyncStateArgs(
///     "Initial value",
///     (Args1<String> args) => Future.delayed(
///       const Duration(seconds: 1),
///       () => args.arg,
///     ),
///   });
/// ```
///
/// Use the [resolve] method to resolve state
/// and use the [value] getter to get state:
///
/// ```dart
///   // Before changed value: "Initial value"
///   print('Before changed value: "${appController.asyncState.value}"');
///   // Resolve state
///   await appController.asyncState.resolve("Resolved value");
///   // After changed value: "Resolved value"
///   print('After changed value: "${appController.asyncState.value}"');
/// ```
///
/// It also has the [when] method that returns a new value
/// depending on it's state:
///
/// ```dart
/// final valueComputed = appController.asyncState.when<String>(
///   standby: (value) => "⚓️ Standby: $value",
///   loading: (value) => "⏳ Loading...",
///   done: (value) => "✅ Resolved: $value",
///   error: (error) => "❌ Error: $error",
/// );
/// ```
///
/// Its status may be obtained using the getters [value] and [error],
/// and restore it to its [initialValue] state using the [reset] method.
///
/// See also:
///
/// * [UseAsyncState], the same as it, but without arguments.
/// * [Args], a generic arguments.
class UseAsyncStateArgs<T, A extends Args?> extends _UseAsyncStateAbstract<T> {
  UseAsyncStateArgs(
    T initialValue,
    AsyncFunctionArgs<T, A> asyncFunction,
  ) : super(initialValue, asyncFunction);

  /// Execute [asyncFunction] to resolve [value].
  FutureOr<T?> resolve(A args) async {
    return _resolve(args);
  }
}
