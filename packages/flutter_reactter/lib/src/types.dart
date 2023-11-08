// ignore_for_file: prefer_void_to_null

import 'package:flutter/widgets.dart';
import 'package:reactter/reactter.dart' hide Reactter;

/// This function type can be used as a callback to determine
/// whether a specific aspect of an inherited widget should be selected or not.
typedef SelectorAspect<T> = bool Function(InheritedElement inheritedElement);

/// This function type can be used as a callback to listen to the states of an
/// instance of [T] type and return a list of [ReactterState] objects
/// associated with that instance.
typedef ListenStates<T> = List<ReactterState> Function(T instance);

/// This function type can be used as a callback to build a widget tree
/// based on an instance of [T] type.
typedef InstanceContextBuilder<T> = Widget Function(
  T inst,
  BuildContext context,
  Widget? child,
);

/// Identifies a [ReactterProvider] with id.
typedef WithId = String;

/// Identifies a [ReactterProvider] without id.
typedef WithoutId = Null;

/// This function type can be used to watch a state.
typedef WatchState = S Function<S extends ReactterState>(S state);

/// This function type takes an argument of [T] type and a [WatchState] function, and returns a value of [R] type.
/// This function type can be used to compute a value based on the provided arguments.
typedef SelectComputeValue<T, R> = R Function(T, WatchState);

/// Returns the type of the generic parameter [T].
Type getType<T>() => T;
