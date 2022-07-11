part of '../hooks.dart';

enum UseAsyncStateStatus {
  standby,
  loading,
  done,
  error,
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
/// class AppContext extends ReactterContext {
///   // It's same that: late final asyncState = UseAsyncState<String, String?>(
///   late final asyncState = UseAsyncState(
///     "Initial value",
///     _resolveState,
///     this,
///   );
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
///   print('Before changed value: "${appContext.asyncState.value}"');
///   // Resolve state
///   await appContext.asyncState.resolve("Resolved value");
///   // After changed value: "Resolved value"
///   print('After changed value: "${appContext.asyncState.value}"');
/// ```
///
/// It also has [when] method that returns a new value
/// depending of it's state:
///
/// ```dart
/// final valueComputed = appContext.asyncState.when<String>(
///   standby: (value) => "⚓️ Standby: $value",
///   loading: (value) => "⏳ Loading...",
///   done: (value) => "✅ Resolved: $value",
///   error: (error) => "❌ Error: $error",
/// );
/// ```
///
/// You can use the getters [state] and [error] for more detail
/// and you could reset the state using [reset] method.
class UseAsyncState<T, A> extends ReactterHook {
  ReactterHookManager? context;

  /// Works as a the [value] initializer.
  /// Need to call [resolve] to execute.
  final AsyncFunction<T, A> asyncValue;

  T get value => _value.value;
  Object? get error => _error.value;
  UseAsyncStateStatus get status => _status.value;

  final T _initial;
  late final _value = UseState<T>(_initial, this);
  late final _error = UseState<Object?>(null, this);
  late final _status = UseState(UseAsyncStateStatus.standby, this);

  UseAsyncState(
    initial,
    this.asyncValue, [
    this.context,
  ])  : _initial = initial,
        super(context) {
    UseEffect(() {
      _status.value = UseAsyncStateStatus.done;
    }, [_value]);

    UseEffect(() {
      if (_error.value != null) {
        _status.value = UseAsyncStateStatus.error;
      }
    }, [_error]);
  }

  /// Execute [asyncValue] to resolve [value].
  Future<T?> resolve([A? arg]) async {
    _status.value = UseAsyncStateStatus.loading;

    try {
      if (arg == null && null is! A) {
        return _value.value = await asyncValue();
      }

      return _value.value = await asyncValue(arg as A);
    } catch (e) {
      _error.value = e;

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
  /// final valueComputed = appContext.asyncState.when<String>(
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

  /// Reset [value], [status] and [error] to its initial state.
  void reset() {
    _value.reset();
    _error.reset();
    _status.reset();
  }
}
