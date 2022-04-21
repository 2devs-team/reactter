import 'package:flutter/material.dart';
import '../../reactter.dart';

typedef UpdateCallback<T> = void Function(T newValue, T oldValue);

typedef FutureVoidCallback = Future<void> Function();

typedef UseEffectCallback = void Function()? Function();

typedef Create<T> = T Function();

typedef BuilderContext<T> = T Function();

typedef InstanceBuilder<T> = T Function();

typedef Selector<T> = List<UseState> Function(T instance);

typedef SelectorAspect<T> = bool Function(InheritedElement inheritedElement);

typedef BuildWithChild = Widget Function(BuildContext context, Widget? child);

typedef WidgetCreator = Widget Function();

typedef WidgetCreatorValue<T> = Widget Function(T value);

typedef WidgetCreatorErrorHandler = Widget Function(Object? error);
