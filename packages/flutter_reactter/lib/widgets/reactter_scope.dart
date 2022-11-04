part of '../widgets.dart';

/// A wrapper [StatelessWidget] that helps to control re-rendered of widget tree.
///
/// **NOTE:** The [builder] callback will be rebuild, when the [ReactterContext] changes.
/// For this to happen, the [ReactterContext] should put it on listens
/// for [BuildContext]'s [watch]ers.
///
/// ```dart
/// ReactterScope(
///   build: (context, child) {
///     final appContext = context.watch<AppContext>();
///     return Text("AppContext's state: ${appContext.stateHook.state}");
///   }
/// )
/// ```
///
/// If you don't want to rebuild a part of [builder] callback, use the [child]
/// property, it's more efficient to build that subtree once instead of
/// rebuilding it on every [ReactterContext] changes.
///
/// ```dart
/// ReactterScope(
///   child: Text("This widget build only once"),
///   builder: (context, child) {
///     final appContext = context.watch<AppContext>();
///     return Column(
///       children: [
///         Text("state: ${appContext.stateHook.value}"),
///         child,
///       ],
///     );
///   },
/// )
/// ```
class ReactterScope extends StatelessWidget {
  /// Provides a widget , which render one time.
  ///
  /// It's expose on [builder] method as second parameter.
  final Widget? child;

  /// Method which has the render logic
  ///
  /// Exposes [BuilderContext] and [child] widget as parameters.
  /// and returns a widget.
  final TransitionBuilder? builder;

  const ReactterScope({
    Key? key,
    this.child,
    this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return builder?.call(context, child) ?? child!;
  }
}
