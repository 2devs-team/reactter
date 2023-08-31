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

  final UseState<T> _value;
  final _error = UseState<Object?>(null);
  final _status = UseState(UseAsyncStateStatus.standby);

  T get value => _value.value;
  Object? get error => _error.value;
  UseAsyncStateStatus get status => _status.value;

  /// Works as a the [value] initializer.
  /// Need to call [resolve] to execute.
  final Function asyncFunction;

  _UseAsyncStateAbstract(T initial, this.asyncFunction)
      : _value = UseState(initial);

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
/// [UseAsyncState] has two types [T] and [A](`UseAsyncState<T, A>`).
///
/// [T] is use to define the type of [value]
/// and [A] is use to define the type of [resolve] argument.
///
/// These types can be deferred depending on
/// the initial [value] and [resolve] method defined.
///
/// This example produces one simple [UseAsyncState]:
///
/// ```dart
/// class AppController {
///   // It's same that: late final asyncState = UseAsyncState<String, String?>(
///   final asyncState = UseAsyncState("Initial value", _resolveState);
///
///   Future<String> _resolveState([String? value = "Default value"]) async {
///     return Future.delayed(
///       const Duration(seconds: 1),
///       () => value,
///     );
///   }
/// }
/// ```
///
/// Use [resolve] method to resolve state
/// and use [value] getter to get state:
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
/// It also has [when] method that returns a new value
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
class UseAsyncState<T> extends _UseAsyncStateAbstract {
  /// Works as a the [value] initializer.
  /// Need to call [resolve] to execute.
  final AsyncFunction<T> asyncFunction;

  UseAsyncState(
    T initial,
    this.asyncFunction,
  ) : super(initial, asyncFunction);

  static UseAsyncStateArg<T, A> withArg<T, A extends Arg?>(
    T initial,
    AsyncFunctionArg<T, A> asyncFunction,
  ) {
    return UseAsyncStateArg<T, A>(initial, asyncFunction);
  }

  /// Execute [asyncFunction] to resolve [value].
  Future<T?> resolve() async {
    _status.value = UseAsyncStateStatus.loading;

    try {
      _value.value = await asyncFunction();
      _status.value = UseAsyncStateStatus.done;

      return _value.value;
    } catch (e) {
      _error.value = e;
      _status.value = UseAsyncStateStatus.error;

      return null;
    }
  }
}

/// The class `UseAsyncStateArg` is a generic class in Dart that extends `_UseAsyncStateAbstract` and
/// takes two type parameters `T` and `A`, where `A` must be a subtype of `Arg`.
class UseAsyncStateArg<T, A extends Arg?> extends _UseAsyncStateAbstract<T> {
  final AsyncFunctionArg<T, A> asyncFunction;

  UseAsyncStateArg(initial, this.asyncFunction) : super(initial, asyncFunction);

  FutureOr<T?> resolve(A arg) async {
    _status.value = UseAsyncStateStatus.loading;

    try {
      _value.value = await asyncFunction(arg);
      _status.value = UseAsyncStateStatus.done;

      return _value.value;
    } catch (e) {
      _error.value = e;
      _status.value = UseAsyncStateStatus.error;

      return null;
    }
  }
}
