part of '../widgets.dart';

/// A abstract [StatelessWidget] class that provides the functionality of [ReactterProvider]
/// with a [ReactterContext] of [T], and exposes it through [render] method.
///
/// ```dart
/// class App extends ReactterComponent<AppContext> {
///   const App({Key? key}) : super(key: key);
///
///   @override
///   get builder => () => AppContext();
///
///   @override
///   Widget render(AppContext ctx, BuildContext context) {
///     return Text("State: ${ctx.stateHook.value}");
///   }
/// }
/// ```
abstract class ReactterComponent<T extends ReactterContext>
    extends StatelessWidget {
  const ReactterComponent({Key? key}) : super(key: key);

  /// Id of [T].
  @protected
  String? get id => null;

  /// How to builder the instance of [T].
  @protected
  ContextBuilder<T>? get builder => null;

  /// Listens hooks to re-render [render] method.
  @protected
  ListenHooks<T>? get listenHooks => null;

  /// Invoked when the [ReactterContext]'s instance is created.
  OnInitContext<T>? get onInit => null;

  /// Replaces a build method.
  ///
  /// Provides the [ReactterContext]'s instance of [T] along with the [BuildContext].
  ///
  /// It should build a Widget based on the current [ReactterContext] changes.
  @protected
  Widget render(T ctx, BuildContext context);

  @protected
  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    if (builder == null) {
      return ReactterBuilder<T>(
        id: id,
        listenHooks: listenHooks,
        builder: (ctx, context, child) => render(ctx, context),
      );
    }

    return ReactterProvider<T>(
      builder!,
      id: id,
      onInit: onInit,
      builder: (context, _) => render(_getContext(context), context),
    );
  }

  T _getContext(BuildContext context) {
    return id == null
        ? context.watch<T>(listenHooks)
        : context.watchId<T>(id!, listenHooks);
  }
}
