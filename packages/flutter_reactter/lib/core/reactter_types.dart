part of '../core.dart';

typedef SelectorAspect<T> = bool Function(InheritedElement inheritedElement);

typedef ListenHooks<T> = List<ReactterState> Function(T instance);

typedef InstanceBuilder<T> = Widget Function(
  T inst,
  BuildContext context,
  Widget? child,
);

