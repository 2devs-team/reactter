part of '../core.dart';

typedef SelectorAspect<T> = bool Function(InheritedElement inheritedElement);

@Deprecated("Use `ListenStates` instead.")
typedef ListenHooks<T> = List<ReactterHook> Function(T instance);

typedef ListenStates<T> = List<ReactterState> Function(T instance);

typedef InstanceBuilder<T> = Widget Function(
  T inst,
  BuildContext context,
  Widget? child,
);
