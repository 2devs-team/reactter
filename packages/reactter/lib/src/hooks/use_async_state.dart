part of 'hooks.dart';

enum UseAsyncStateStatus {
  idle,
  loading,
  done,
  error,
}

@internal
abstract class UseAsyncStateBase<T> extends RtHook {
  @protected
  @override
  final $ = RtHook.$register;

  final String? _debugLabel;
  @override
  String? get debugLabel => _debugLabel ?? super.debugLabel;
  @override
  Map<String, dynamic> get debugInfo => {
        'value': value,
        'error': error,
        'status': status,
      };

  /// Stores the initial value.
  final T _initialValue;

  /// Works as a the [value] initializer.
  /// Need to call [resolve] to execute.
  final Function _asyncFunction;

  final UseState<T> _uValue;
  late final uValue = Rt.lazyState(
    () => UseCompute(() => _uValue.value, [_uValue]),
    this,
  );
  T get value => _uValue.value;

  final _uError = UseState<Object?>(null);
  late final uError = Rt.lazyState(
    () => UseCompute(() => _uError.value, [_uError]),
    this,
  );
  Object? get error => _uError.value;

  final _uStatus = UseState(UseAsyncStateStatus.idle);
  late final uStatus = Rt.lazyState(
    () => UseCompute(() => _uStatus.value, [_uStatus]),
    this,
  );
  UseAsyncStateStatus get status => _uStatus.value;

  late final uIsLoading = Rt.lazyState(
    () => UseCompute(() => status == UseAsyncStateStatus.loading, [uStatus]),
    this,
  );
  bool get isLoading => uIsLoading.value;

  late final uIsDone = Rt.lazyState(
    () => UseCompute(() => status == UseAsyncStateStatus.done, [uStatus]),
    this,
  );
  bool get isDone => uIsDone.value;

  late final uIsError = Rt.lazyState(
    () => UseCompute(() => status == UseAsyncStateStatus.error, [uStatus]),
    this,
  );
  bool get isError => uIsError.value;

  Future<T> _future = Completer<T>().future;
  Future<T> get future => _future;

  bool _isCanceled = false;

  UseAsyncStateBase(
    Function asyncFunction,
    T initialValue, {
    String? debugLabel,
  })  : _initialValue = initialValue,
        _asyncFunction = asyncFunction,
        _debugLabel = debugLabel,
        _uValue = UseState(initialValue);

  /// Execute [asyncFunction] to resolve [value].
  FutureOr<T?> _resolve<A>([A? arg]) async {
    try {
      _uStatus.value = UseAsyncStateStatus.loading;

      final asyncFunctionExecuting =
          arg == null ? _asyncFunction() : _asyncFunction(arg);

      _future = asyncFunctionExecuting is Future<T>
          ? asyncFunctionExecuting
          : Future.value(asyncFunctionExecuting);

      final response = await _future;

      if (_isCanceled) return null;

      Rt.batch(() {
        _uValue.value = response;
        _uStatus.value = UseAsyncStateStatus.done;
      });

      return _uValue.value;
    } catch (e) {
      Rt.batch(() {
        _uError.value = e;
        _uStatus.value = UseAsyncStateStatus.error;
      });

      return null;
    } finally {
      if (_isCanceled) {
        _uStatus.value = UseAsyncStateStatus.done;
        _isCanceled = false;
      }
    }
  }

  /// Cancels the async function execution.
  void cancel() {
    if (status == UseAsyncStateStatus.loading) _isCanceled = true;
  }

  /// Returns a new value of [R] depending on the state of the hook:
  ///
  /// `idle`: When the state has the initial value.
  /// `loading`: When the request for the state is retrieving the value.
  /// `done`: When the request is done.
  /// `error`: If any errors happens in the request.
  ///
  /// For example:
  ///
  /// ```dart
  /// final valueComputed = appController.asyncState.when<String>(
  ///   idle: (value) => "⚓️ Idle: ${value}",
  ///   loading: (value) => "⏳ Loading...",
  ///   done: (value) => "✅ Resolved: ${value}",
  ///   error: (error) => "❌ Error: ${error}",
  /// )
  /// ```
  R? when<R>({
    WhenValueReturn<T, R>? idle,
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

    return idle?.call(value);
  }

  /// Reset [value], [status] and [error] to its [initial] state.
  void reset() {
    Rt.batch(() {
      _uValue.value = _initialValue;
      _uError.value = null;
      _uStatus.value = UseAsyncStateStatus.idle;
    });
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
///   idle: (value) => "⚓️ Standby: $value",
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
///   idle: (value) => "⚓️ Standby: $value",
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
