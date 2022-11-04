part of '../widgets.dart';

/// A wrapper [StatelessWidget] that gets the [ReactterContext]'s instance of [T]
/// from the closest ancestor of [ReactterProvider]
/// and exposes it through the first parameter of [builder] callback.
///
/// ```dart
/// ReactterBuilder<AppContext>(
///   builder: (appContext, context, child) {
///     return Text("state: ${appContext.stateHook.value}");
///   },
/// )
/// ```
///
/// **NOTE**: [ReactterBuilder] is read-only by default, this means it only renders once.
///
/// **NOTE:** [ReactterBuilder] is a "scoped". So it contains a [ReactterScope]
/// which the [builder] callback will be rebuild, when the `ReactterContext` changes.
/// For this to happen, the [ReactterContext] should put it on listens
/// for [BuildContext]'s [watch]ers.
///
/// If you want to listen for all [ReactterContext]'s changes
/// to re-render [builder] callback, use [listenAllHooks] property as `true`.
///
/// If you want to listen for some [ReactterContext]'s [ReactterHook]
/// to re-render [builder] callback, use [listenHooks].
///
/// If you don't want to rebuild a part of [builder] callback, use the [child]
/// property, it's more efficient to build that subtree once instead of
/// rebuilding it on every [ReactterContext] changes.
///
/// ```dart
/// ReactterBuilder<AppContext>(
///   listenAllHooks: true,
///   child: Text("This widget build only once"),
///   builder: (appContext, context, child) {
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
class ReactterBuilder<T extends ReactterContext?> extends StatelessWidget {
  /// Provides a widget , which render only once.
  ///
  /// It's exposes on [builder] callback's second parameter.
  final Widget? child;

  /// Exposes the [BuilderContext] along with the [child].
  ///
  /// It should build a Widget based on the current [ReactterContext] changes
  /// and incorporate the [child] into it, if it is non-null.
  final InstanceBuilder<T>? builder;

  /// Id of [T].
  final String? id;

  /// Watchs all hooks to re-render
  final bool listenAllHooks;

  /// Watchs specific hooks to re-render
  final ListenHooks<T>? listenHooks;

  const ReactterBuilder({
    Key? key,
    this.id,
    this.listenHooks,
    this.listenAllHooks = false,
    this.child,
    this.builder,
  })  : assert(child != null || builder != null),
        assert(
          (listenAllHooks && listenHooks == null) || !listenAllHooks,
          "Can't use `listenAllHooks` with `listenHooks`",
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctx = ReactterProvider.contextOf<T>(
      context,
      id: id,
      listen: listenAllHooks || listenHooks != null,
      listenHooks: listenHooks,
    );

    return builder?.call(ctx, context, child) ?? child!;
  }
}
