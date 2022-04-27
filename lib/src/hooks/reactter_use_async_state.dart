library reactter;

import 'package:flutter/material.dart';
import '../core/reactter_context.dart';
import '../core/reactter_types.dart';
import 'reactter_use_state.dart';

/// This class extends from [UseState].
/// Has the same capabilities but receive [asyncValue] which works as a the [value] initializer.
///
/// This example produces one simple [UseAsyncState]:
/// ```dart
///late final userName =
///       UseAsyncState<String>("My username", () async {
///           return await api.getUserName();
///       });
///
/// ```
class UseAsyncState<T> extends UseState<T> {
  UseAsyncState(
    initial,
    this.asyncValue, {
    ReactterContext? context,
  }) : super(
          initial,
          alwaysUpdate: true,
          context: context,
        ) {
    context?.listenHooks([this]);
  }

  /// Works as a the [value] initializer.
  /// Need to call [resolve()] to execute.
  final Future<T> Function() asyncValue;

  bool _isRequestDone = false;
  bool _error = false;
  Object? errorObject;

  // Set result from the request, clear the states and set [value].
  set result(T _value) {
    _clear();
    _isRequestDone = true;
    value = _value;
  }

  bool isLoading = false;
  set _isLoading(bool _value) {
    isLoading = _value;
    if (!_value) return;
    publish();
  }

  /// Resolve [asyncValue] to fill [value].
  ///
  /// This example produces the use we recommend:
  /// ```dart
  /// onClick(){
  ///   state.resolve();
  /// }
  /// ```
  ///
  /// You able to call wherever you want, in the constructor or in any [lifecycle] method.
  resolve() async {
    _clear();
    _isLoading = true;

    try {
      result = await asyncValue();
    } catch (e) {
      setError(e);
    } finally {
      _isLoading = false;
    }
  }

  /// Clear all state values for correct handling.
  _clear() {
    _isRequestDone = false;
    errorObject = null;
    _error = false;
    _isLoading = false;
  }

  setError(Object error) {
    errorObject = error;
    _error = true;
  }

  /// Reset [value] to his initial value.
  @override
  void reset() {
    _clear();
    publish();
    super.reset();
  }

  /// React when the [value] change and re-render the widget depending of the state.
  ///
  /// `standby`: When the state has the initial value.
  /// `loading`: When the request for the state is retrieving the value.
  /// `done`: When the request is done.
  /// `error`: If any errors happens in the request.
  ///
  /// Example:
  ///
  /// ```dart
  /// userContext.userName.when(
  ///
  ///   standby: (value) => Text("Standby: ${value}"),
  ///
  ///   loading: () => const CircularProgressIndicator(),
  ///
  ///   done: (value) => Text(value),
  ///
  ///   error: (error) => const Text("Unhandled exception: ${error}"),
  /// )
  /// ```
  Widget when({
    WidgetCreatorValue<T>? standby,
    WidgetCreator? loading,
    WidgetCreatorValue<T>? done,
    WidgetCreatorErrorHandler? error,
  }) {
    if (_error) {
      return error?.call(errorObject) ?? const SizedBox.shrink();
    }

    if (isLoading) {
      return loading?.call() ?? const SizedBox.shrink();
    }

    if (!isLoading && _isRequestDone) {
      return done?.call(value) ?? const SizedBox.shrink();
    }

    return standby?.call(value) ?? const SizedBox.shrink();
  }
}
