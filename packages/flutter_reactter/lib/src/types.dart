import 'package:flutter/widgets.dart';

import 'internals.dart';

/// This function type can be used as a callback to determine
/// whether a specific aspect of an inherited widget should be selected or not.
typedef SelectorAspect<T> = bool Function(InheritedElement inheritedElement);

/// This function type can be used as a callback to listen to the states of an
/// instance of type `T` and return a list of `ReactterState` objects
/// associated with that instance.
typedef ListenStates<T> = List<ReactterState> Function(T instance);

typedef InstanceContextBuilder<T> = Widget Function(
  T inst,
  BuildContext context,
  Widget? child,
);
