library reactter;

import 'package:flutter/material.dart';
import '../core/reactter_context.dart';
import '../core/reactter_types.dart';
import 'reactter_use_state.dart';

/// Has the same functionality of [UseState] but providing a [asyncValue]
/// which sets [value] when [resolve] method is called
///
/// This example produces one simple [UseAsyncState] :
///
/// ```dart
/// late final userName = UseAsyncState<String>(
///   "My username",
///   () async => await api.getUserName(),
///   this,
/// );
/// ```
///
/// It also has [when] method that returns a widget depending on the state of the hook.
/// for example:
///
/// ```dart
/// userName.when(
///   standby: (value) => Text("Standby: ${value}"),
///   loading: () => const CircularProgressIndicator(),
///   done: (value) => Text(value),
///   error: (error) => const Text("Unhandled exception: ${error}"),
/// );
/// ```
class UseAsyncState<T> extends UseState<T> {
  UseAsyncState(
    initial,
    this.asyncValue, [
    ReactterContext? context,
  ]) : super(initial, context) {
    context?.listenHooks([this]);
  }

  /// Works as a the [value] initializer.
  /// Need to call [resolve] to execute.
  final AsyncFunction<T> asyncValue;

  bool get isDone => _isDone;
  bool _isDone = false;

  bool get isLoading => _loading;
  bool _loading = false;
  set _isLoading(bool value) {
    _loading = value;
    if (!value) return;
    update();
  }

  bool get hasError => _hasError;
  Object? get error => _errorObject;
  bool _hasError = false;
  Object? _errorObject;
  set _error(Object value) {
    _errorObject = value;
    _hasError = true;
  }

  /// Execute [asyncValue] to resolve [value].
  Future<T?> resolve() async {
    _clear();
    _isLoading = true;

    try {
      final value = await asyncValue();
      _isDone = true;
      this.value = value;

      return value;
    } catch (e) {
      _error = e;

      return null;
    } finally {
      _isLoading = false;
    }
  }

  /// Clear all state values for correct handling.
  _clear() {
    _isDone = false;
    _loading = false;
    _hasError = false;
    _errorObject = null;
  }

  /// Reset [value] to his initial value.
  @override
  void reset() {
    _clear();
    update();
    super.reset();
  }

  /// React when the [value] change and re-render the widget depending of the state.
  ///
  /// `standby`: When the state has the initial value.
  /// `loading`: When the request for the state is retrieving the value.
  /// `done`: When the request is done.
  /// `error`: If any errors happens in the request.
  ///
  /// For example:
  ///
  /// ```dart
  /// userContext.userName.when(
  ///   standby: (value) => Text("Standby: ${value}"),
  ///   loading: () => const CircularProgressIndicator(),
  ///   done: (value) => Text(value),
  ///   error: (error) => const Text("Unhandled exception: ${error}"),
  /// )
  /// ```
  Widget when({
    WidgetCreatorValue<T>? standby,
    WidgetCreator? loading,
    WidgetCreatorValue<T>? done,
    WidgetCreatorErrorHandler? error,
  }) {
    if (hasError) {
      return error?.call(_errorObject) ?? const SizedBox.shrink();
    }

    if (isLoading) {
      return loading?.call() ?? const SizedBox.shrink();
    }

    if (!isLoading && _isDone) {
      return done?.call(value) ?? const SizedBox.shrink();
    }

    return standby?.call(value) ?? const SizedBox.shrink();
  }
}
