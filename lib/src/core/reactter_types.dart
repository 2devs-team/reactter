import 'package:flutter/material.dart';
import 'reactter_hook.dart';

typedef UpdateCallback<T> = void Function(T newValue, T oldValue);

typedef FutureVoidCallback = Future<void> Function();

typedef FunctionCallback = void Function()? Function();

typedef ContextBuilder<T> = T Function();

typedef ListenHooks<T> = List<ReactterHook> Function(T instance);

typedef SelectorAspect<T> = bool Function(InheritedElement inheritedElement);

typedef InstanceBuilder<T> = Widget Function(
    T inst, BuildContext context, Widget? child);

typedef WidgetCreator = Widget Function();

typedef WidgetCreatorValue<T> = Widget Function(T value);

typedef WidgetCreatorErrorHandler = Widget Function(Object? error);

typedef LogWriterCallback = void Function(String text, {bool isError});

typedef AsyncFunction<T, A> = Future<T> Function([A args]);

typedef OnInitContext<T> = void Function(T instance);
