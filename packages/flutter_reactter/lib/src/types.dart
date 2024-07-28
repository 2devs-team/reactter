// ignore_for_file: prefer_void_to_null

import 'package:flutter/widgets.dart';

import '../reactter.dart';

/// This function can be used as a callback to determine
/// whether a specific aspect of an inherited widget should be selected or not.
typedef SelectorAspect<T> = bool Function(InheritedElement inheritedElement);

/// This function can be used as a callback to listen to the states of an
/// instance of [T] dependency and return a list of [RtState] objects
/// associated with the dependency.
typedef ListenStates<T> = List<RtState> Function(T instance);

/// Identifies a [RtProvider] with id.
typedef WithId = String;

/// Identifies a [RtProvider] without id.
typedef WithoutId = Null;

/// This function can be used to watch a state.
typedef Select = S Function<S extends RtState>(S state);

/// This function takes an argument of [T] type and a [Select] function, and returns a value of [R] type.
/// This function can be used to compute a value based on the provided arguments.
typedef Selector<T, V> = V Function(
  T inst,
  Select select,
);

/// A builder that builds a widget given a child.
///
/// The child should typically be part of the returned widget tree.
typedef ChildBuilder = Widget Function(
  BuildContext context,
  Widget? child,
);

/// This function can be used as a callback to build a widget tree
/// based on an instance of [T] dependency.
typedef InstanceChildBuilder<T> = Widget Function(
  BuildContext context,
  T inst,
  Widget? child,
);

/// This function can be used as a callback to build a widget tree
/// based on an instance of [T] dependency and a value of [V] type.
typedef InstanceValueChildBuilder<T, V> = Widget Function(
  BuildContext context,
  T inst,
  V value,
  Widget? child,
);

/// {@template flutter_reactter.watch_builder}
/// This function can be used as a callback to build a widget tree.
///
/// The [watch] function is used to watch the state of the widget.
/// {@endtemplate}
typedef WatchBuilder = Widget Function(
  BuildContext context,
  T Function<T extends RtState>(T state) watch,
);

/// {@template flutter_reactter.watch_child_builder}
/// This function can be used as a callback to build a widget tree.
///
/// The [watch] function is used to watch the state of the widget.
/// The [child] widget is used to build the widget tree.
/// {@endtemplate}
typedef WatchChildBuilder = Widget Function(
  BuildContext context,
  T Function<T extends RtState>(T state) watch,
  Widget? child,
);

/// Returns the type of the generic parameter [T].
Type getType<T>() => T;
