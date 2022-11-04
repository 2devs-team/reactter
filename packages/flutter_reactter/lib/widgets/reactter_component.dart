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
  String? get id => null;

  /// How to builder the instance of [T].
  ContextBuilder<T>? get builder => null;

  /// Listens hooks to re-render [render] method.
  ListenHooks<T>? get listenHooks => null;

  /// Watchs all hooks to re-render
  bool get listenAllHooks => false;

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
    assert(
      (listenAllHooks && listenHooks == null) || !listenAllHooks,
      "Can't use `listenAllHooks` with `listenHooks`",
    );

    if (builder == null) {
      final T instance = _getInstance(context);
      return render(instance, context);
    }

    return ReactterProvider<T>(
      builder!,
      id: id,
      builder: (instance, context, _) => render(_getInstance(context), context),
    );
  }

  T _getInstance(BuildContext context) {
    if (listenHooks == null && !listenAllHooks) {
      return context.use(id);
    }

    return id == null
        ? context.watch<T>(listenHooks)
        : context.watchId<T>(id!, listenHooks);
  }
}
