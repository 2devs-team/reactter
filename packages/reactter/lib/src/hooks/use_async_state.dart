part of 'hooks.dart';

enum UseAsyncStateStatus {
  standby,
  loading,
  done,
  error,
}

@internal
abstract class UseAsyncStateBase<T> extends RtHook {
  @protected
  @override
  final $ = RtHook.$register;

  /// Stores the initial value.
  final T _initialValue;

  /// Works as a the [value] initializer.
  /// Need to call [resolve] to execute.
  final Function _asyncFunction;

  final UseState<T> _value;
  final _error = UseState<Object?>(null);
  final _status = UseState(UseAsyncStateStatus.standby);

  T get value => _value.value;
  Object? get error => _error.value;
  UseAsyncStateStatus get status => _status.value;

  Future<T> _future = Completer<T>().future;
  Future<T> get future => _future;

  final String? _debugLabel;
  @override
  String? get debugLabel => _debugLabel ?? super.debugLabel;
  @override
  Map<String, dynamic> get debugInfo => {
        'value': value,
        'error': error,
        'status': status,
      };

  UseAsyncStateBase(
    Function asyncFunction,
    T initialValue, {
    String? debugLabel,
  })  : _initialValue = initialValue,
        _asyncFunction = asyncFunction,
        _debugLabel = debugLabel,
        _value = UseState(initialValue);

  /// Execute [asyncFunction] to resolve [value].
  FutureOr<T?> _resolve<A>([A? arg]) async {
    try {
      _status.value = UseAsyncStateStatus.loading;

      final asyncFunctionExecuting =
          arg == null ? _asyncFunction() : _asyncFunction(arg);

      _future = Future.value(asyncFunctionExecuting);

      _value.value = await _future;

      _status.value = UseAsyncStateStatus.done;

      return _value.value;
    } catch (e) {
      _error.value = e;
      _status.value = UseAsyncStateStatus.error;
      return null;
    } finally {}
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
    _value.value = _initialValue;
    _error.value = null;
    _status.value = UseAsyncStateStatus.standby;
  }
}

/// {@template reactter.use_async_state}
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
/// * [UseAsyncStateArg], the same as it, but with arguments.
/// {@endtemplate}
class UseAsyncState<T> extends UseAsyncStateBase<T> {
  /// {@macro reactter.use_async_state}
  UseAsyncState(
    AsyncFunction<T> asyncFunction,
    T initialValue, {
    String? debugLabel,
  }) : super(
          asyncFunction,
          initialValue,
          debugLabel: debugLabel,
        );

  /// {@macro reactter.use_async_state_arg}
  static UseAsyncStateArg<T, A> withArg<T, A>(
    AsyncFunctionArg<T, A> asyncFunction,
    T initialValue, {
    String? debugLabel,
  }) {
    return UseAsyncStateArg<T, A>(
      asyncFunction,
      initialValue,
      debugLabel: debugLabel,
    );
  }

  /// Execute [asyncFunction] to resolve [value].
  FutureOr<T?> resolve() async {
    return _resolve();
  }
}

/// {@template reactter.use_async_state_arg}
/// A [ReactteHook] that manages the state as async way.
///
/// [T] is use to define the type of [value]
/// and [A] is use to define the type of [resolve] argument.
///
/// This example produces one simple [UseAsyncStateArg]:
///
/// ```dart
/// class AppController {
///   // It's same that: UseAsyncStateArg<String, Args1<String>>
///   final asyncState = UseAsyncStateArg(
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
/// {@endtemplate}
class UseAsyncStateArg<T, A> extends UseAsyncStateBase<T> {
  /// {@macro reactter.use_async_state_arg}
  UseAsyncStateArg(
    AsyncFunctionArg<T, A> asyncFunction,
    T initialValue, {
    String? debugLabel,
  }) : super(
          asyncFunction,
          initialValue,
          debugLabel: debugLabel,
        );

  /// Execute [asyncFunction] to resolve [value].
  FutureOr<T?> resolve(A arg) async {
    return _resolve(arg);
  }
}
