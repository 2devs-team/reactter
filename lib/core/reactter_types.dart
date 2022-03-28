import 'package:flutter/material.dart';

typedef UpdateCallback<T> = void Function(T newValue, T oldValue);
typedef FutureVoidCallback = Future<void> Function();
typedef Create<T> = T Function();
typedef SelectorAspect<T> = bool Function(InheritedElement inheritedElement);
typedef BuildWithChild = Widget Function(BuildContext context, Widget? child);
