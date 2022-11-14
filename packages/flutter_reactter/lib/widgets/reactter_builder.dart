part of '../widgets.dart';

/// A [StatelessWidget] that gets the [ReactterContext]'s instance of [T]
/// from the closest ancestor of [ReactterProvider] and exposes it through
/// the first parameter of [builder] callback.
///
/// ```dart
/// ReactterBuilder<AppContext>(
///   builder: (appContext, context, child) {
///     return Text("state: ${appContext.stateA.value}");
///   },
/// )
/// ```
///
/// **NOTE**: [ReactterBuilder] is read-only by default, this means it
/// only renders once.
///
/// Use [id] property to find a instances of [T] with an identify.
///
/// Use [listenStates] property to listen states, and when it changed,
/// [ReactterBuilder]'s [builder] callback re-built.
///
/// Use [listenAll] property as true to listen all states, and when
/// it changed, [ReactterBuilder]'s [builder] callback re-built.
///
/// **CONSIDER** Use [child] property to pass a [Widget] that
/// you want to build it once. The [ReactterBuilder] pass it through
/// the [builder] callback, so you can incorporate it into your build:
///
/// ```dart
/// ReactterBuilder<AppContext>(
///   listenAll: true,
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
/// See also:
///
/// * [ReactterProvider], a [StatelessWidget] that provides a
/// [ReactterContext]'s instance of [T] to widget tree that can be access
/// through the [BuildContext].
/// * [ReactterContext], a base-class that allows to manages the [ReactterHook]s.
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

  /// Watchs specific states to re-build
  final ListenStates<T>? listenStates;

  /// Watchs all states to re-build
  final bool listenAll;

  /// Watchs all hooks to re-build
  @Deprecated("Use `listenAll` instead.")
  final bool listenAllHooks;

  /// Watchs specific hooks to re-build
  @Deprecated("Use `listenStates` instead.")
  final ListenHooks<T>? listenHooks;

  const ReactterBuilder({
    Key? key,
    this.id,
    this.listenStates,
    this.listenAll = false,
    this.listenHooks,
    this.listenAllHooks = false,
    this.child,
    this.builder,
  })  : assert(child != null || builder != null),
        assert(
          ((listenAll || listenAllHooks) &&
                  (listenStates ?? listenHooks) == null) ||
              !(listenAll || listenAllHooks),
          "Can't use `listenAll` with `listenStates`",
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctx = ReactterProvider.contextOf<T>(
      context,
      id: id,
      listen: (listenAll || listenAllHooks) ||
          (listenStates ?? listenHooks) != null,
      listenStates: listenStates,
      listenHooks: listenHooks,
    );

    return builder?.call(ctx, context, child) ?? child!;
  }
}
