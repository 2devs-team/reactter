library reactter;

import 'package:flutter/material.dart';
import '../core/reactter_types.dart';
import '../hooks/reactter_hook.dart';

import '../../reactter.dart';

class UseAsyncState<T> extends UseState<T> {
  UseAsyncState(
    initial,
    this.asyncValue, {
    ReactterHook? context,
  }) : super(
          initial,
          alwaysUpdate: true,
          context: context,
        ) {
    context?.listenHooks([this]);
  }

  final Future<T> Function() asyncValue;

  bool _isRequestDone = false;
  bool _error = false;
  Object? errorObject;

  set result(T _value) {
    clear();
    _isRequestDone = true;
    value = _value;
  }

  bool isLoading = false;
  set _isLoading(bool _value) {
    isLoading = _value;
    if (!_value) return;
    publish();
  }

  resolve() async {
    clear();
    _isLoading = true;

    try {
      result = await asyncValue();
    } catch (e) {
      setError(e);
    } finally {
      _isLoading = false;
    }
  }

  clear() {
    _isRequestDone = false;
    errorObject = null;
    _error = false;
    _isLoading = false;
  }

  setError(Object error) {
    errorObject = error;
    _error = true;
  }

  @override
  void reset() {
    clear();
    publish();
    super.reset();
  }

  // @override
  // void update() {
  //   print("Rebuild async update");
  // }

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
