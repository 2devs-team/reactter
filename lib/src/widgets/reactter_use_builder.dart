library reactter;

import 'package:flutter/material.dart';
import '../core/reactter_context.dart';
import '../widgets/reactter_use_provider.dart';

/// Creates a new context to provide the instances of [T] to [builder] method.
///
/// Helps to encapsulate and control re-renders.
///
/// This example produces one [UseBuilder] with an [AppContext] as [T] :
///
/// ```dart
/// UseBuilder<AppContext>(
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
class UseBuilder<T extends ReactterContext> extends StatelessWidget {
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

  const UseBuilder({
    Key? key,
    required this.builder,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return builder(
      context,
      UseProvider.contextOf<T>(context),
      child,
    );
  }
}
