part of '../widgets.dart';

/// A abstract [StatelessWidget] class that provides
/// the functionality of [ReactterProvider] with a [ReactterContext] of [T],
/// and exposes it through [render] method.
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
///
/// If you don't use [builder] getter, the instance of [T] is not created
/// and is instead tried to be found it in the nearest ancestor
/// where it was created.
///
/// Use [id] getter to create or find a instances of [T] with an identify:
///
/// ```dart
/// class App extends ReactterComponent<AppContext> {
///   @override
///   get id => "uniqueId";
///   ...
/// }
/// ```
///
/// Use [listenHooks] getter to listen hooks, and when it changed,
/// [ReactterComponent]'s [render] re-built:
///
/// ```dart
/// class App extends ReactterComponent<AppContext> {
///   @override
///   get listenHooks => (ctx) => [ctx.stateA, ctx.stateB];
///   ...
/// }
/// ```
///
/// Use [listenAllHooks] getter as true to listen all hooks, and when it changed,
/// [ReactterComponent]'s [render] re-built:
///
/// ```dart
/// class App extends ReactterComponent<AppContext> {
///   @override
///   get listenAllHook => true;
///   ...
/// }
/// ```
///
/// **CONSIDER:** Dont's use [ReactterContext] with constructor parameters
/// to prevent conflicts.
///
/// See also:
///
/// * [ReactterProvider], a [StatelessWidget] that provides a [ReactterContext]'s instance of [T]
/// to widget tree that can be access through the [BuildContext].
/// * [ReactterContext], a base-class that allows to manages the [ReactterHook]s.
abstract class ReactterComponent<T extends ReactterContext>
    extends StatelessWidget {
  const ReactterComponent({Key? key}) : super(key: key);

  /// Id for instance of [T].
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
