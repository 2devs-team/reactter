library reactter;

import 'package:flutter/material.dart';
import 'package:reactter/core/reactter_types.dart';
import 'package:reactter/hooks/reactter_hook.dart';

import '../reactter.dart';

class UseAsyncState<T> extends UseState<T> {
  UseAsyncState(
    initial,
    this.asyncValue, {
    UpdateCallback<T>? willUpdate,
    UpdateCallback<T>? didUpdate,
    ReactterHook? context,
  }) : super(
          initial,
          alwaysUpdate: true,
          willUpdate: willUpdate,
          didUpdate: didUpdate,
          context: context,
        ) {
    context?.listenHooks([this]);
  }

  final Future<T> Function() asyncValue;

  bool isRequestDone = false;
  T? result;

  set _result(T _value) {
    isRequestDone = true;
    value = _value;
  }

  bool isLoading = false;
  set _isLoading(bool _value) {
    isLoading = _value;
    if (!_value) return;
    publish();
  }

  resolve() async {
    _isLoading = true;
    _result = await asyncValue();
    _isLoading = false;
  }

  @override
  void update() {
    print("Rebuild async update");
  }

  Widget when({
    WidgetCreator? standby,
    WidgetCreator? loading,
    WidgetCreatorValue<T>? done,
  }) {
    if (!isLoading && isRequestDone) {
      return done?.call(value) ?? const SizedBox.shrink();
    }

    if (!isLoading) {
      return standby?.call() ?? const SizedBox.shrink();
    }

    if (isLoading) {
      return loading?.call() ?? const SizedBox.shrink();
    }

    return Container();
  }
}
