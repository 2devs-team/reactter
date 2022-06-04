library reactter;

import 'package:flutter/material.dart';
import '../engine/reactter_inherit_provider.dart';
import '../core/reactter_types.dart';
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
class ReactterBuilder<T extends ReactterContext?>
    extends ReactterInheritedProvider {
  /// Id of [T].
  final String? id;

  /// Watchs specific hooks for re-render
  final ListenHooks<T>? listenHooks;

  /// Provides a widget witch render one time.
  ///
  /// It's expose on [builder] method as third parameter.
  @override
  @protected
  final Widget? child;

  ReactterBuilder({
    Key? key,
    this.id,
    this.listenHooks,
    this.child,

    /// Method which has the render logic
    ///
    /// Exposes instance of [T], [BuildContext] and [child] widget as parameters.
    /// and returns a widget.
    required InstanceBuilder<T> builder,
  }) : super(
          key: key,
          child: child,
          builder: (context, child) => builder(
            ReactterProvider.contextOf<T>(
              context,
              id: id,
              listenHooks: listenHooks,
            ),
            context,
            child,
          ),
        );
}
