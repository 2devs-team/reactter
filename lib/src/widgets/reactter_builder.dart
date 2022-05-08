library reactter;

import 'package:flutter/material.dart';
import '../core/reactter_context.dart';
import 'reactter_provider.dart';

/// Creates a new context to provide the instances of [T] to [builder] method.
///
/// Helps to encapsulate and control re-renders.
///
/// This example produces one [ReactterBuilder] with an [AppContext] as [T] :
///
/// ```dart
/// ReactterBuilder<AppContext>(
///  child: Icon(Icons.person),
///  builder: (context, ctx, child){
///     return Row(
///       children: [
///         Text(appContext.name.value),
///         child,
///       ],
///     );
///   }
/// )
/// ```
class ReactterBuilder<T extends ReactterContext> extends StatelessWidget {
  /// Provides a widget witch render one time.
  ///
  /// It's expose on [builder] method as third parameter.
  @protected
  final Widget? child;

  /// Method which has the render logic
  ///
  /// Exposes [BuilderContext], instance of [T] and [child] widget as parameters.
  /// and returns a widget.
  @protected
  final Widget Function(BuildContext context, T instance, Widget? child)
      builder;

  const ReactterBuilder({
    Key? key,
    required this.builder,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return builder(
      context,
      ReactterProvider.contextOf<T>(context),
      child,
    );
  }
}
