part of '../widgets.dart';

/// A [StatelessWidget] that helps to control re-builder of widget tree.
///
/// **NOTE:** The [builder] callback will be rebuild, when the [ReactterContext] changes.
/// For this to happen, the [ReactterContext] should put it on listens
/// for [BuildContext]'s [watch]ers.
///
/// ```dart
/// ReactterScope(
///   build: (context, child) {
///     final appContext = context.watch<AppContext>();
///
///     return Text("AppContext's state: ${appContext.stateHook.state}");
///   }
/// )
/// ```
///
/// **CONSIDER** Use [child] property to pass a [Widget] that
/// you want to build it once. The [ReactterScope] pass it through
/// the [builder] callback, so you can incorporate it into your build:
///
/// ```dart
/// ReactterScope(
///   child: Text("This widget build only once"),
///   builder: (context, child) {
///     final appContext = context.watch<AppContext>();
///
///     return Column(
///       children: [
///         Text("state: ${appContext.stateHook.value}"),
///         child,
///       ],
///     );
///   },
/// )
/// ```
///
/// See also:
///
/// * [ReactterContext], a base-class that allows to manages the [ReactterHook]s.
@Deprecated(
    "Use any Widget that exposes the `ContextBuilder` like `Build`, `StatelessWidget` or `StatefulWidget` instead.")
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
