part of '../widgets.dart';

/// {@template reactter_component}
/// A abstract [StatelessWidget] class that provides [ReactterProvider] features,
/// whose instance of [T] type defined is exposing trough [render] method.
///
/// ```dart
/// class App extends ReactterComponent<AppController> {
///   const App({Key? key}) : super(key: key);
///
///   @override
///   get builder => () => AppController();
///
///   @override
///   Widget render(BuildContext context, AppController inst) {
///     return Text("State: ${inst.stateHook.value}");
///   }
/// }
/// ```
///
/// Use [builder] getter to define the instance creating method.
///
/// ```dart
/// class App extends ReactterComponent<AppController> {
///   @override
///   get builder => () => AppController();
///   ...
/// }
/// ```
///
/// > **NOTE:**
/// > If you don't use [builder] getter, the [T] instance is not created
/// and instead tried to be found it in the nearest ancestor
/// where it was created.
///
/// Use [id] getter to identify the [T] instance:
///
/// ```dart
/// class App extends ReactterComponent<AppController> {
///   @override
///   get id => "uniqueId";
///   ...
/// }
/// ```
///
/// Use [listenStates] getter to define the states
/// and with its changes rebuild the Widget tree defined in [render] method.
///
/// ```dart
/// class App extends ReactterComponent<AppController> {
///   @override
///   get listenStates => (inst) => [inst.stateA, inst.stateB];
///   ...
/// }
/// ```
///
/// Use [listenAll] getter as `true` to listen all instance changes to rebuild
/// the Widget tree defined in [render] method.
///
/// ```dart
/// class App extends ReactterComponent<AppController> {
///   @override
///   get listenAll => true;
///   ...
/// }
/// ```
///
/// > **RECOMMENDED:**
/// > Dont's use Object with constructor parameters to prevent conflicts.
///
/// See also:
///
/// * [ReactterProvider], a [StatelessWidget] that provides an instance of [T] type
/// to widget tree that can be access through the [BuildContext].
/// {@endtemplate}
abstract class ReactterComponent<T extends Object> extends StatelessWidget {
  const ReactterComponent({Key? key}) : super(key: key);

  /// Id for instance of [T].
  String? get id => null;

  /// How to builder the instance of [T].
  InstanceBuilder<T>? get builder => null;

  /// Listens states to re-build [render] method.
  ListenStates<T>? get listenStates => null;

  /// Watchs all states to re-build [render] method.
  bool get listenAll => false;

  /// Replaces a build method.
  ///
  /// Provides the [T] instance along with the [BuildContext].
  ///
  /// It should build a Widget based on the current [T] instance changes.
  @protected
  Widget render(BuildContext context, T inst);

  @protected
  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    assert(
      !listenAll || listenStates == null,
      "Can't use `listenAll` with `listenStates`",
    );

    if (builder == null) {
      return render(context, _getInstance(context));
    }

    return ReactterProvider<T>(
      builder!,
      id: id,
      builder: (context, instance, _) => render(context, _getInstance(context)),
    );
  }

  T _getInstance(BuildContext context) {
    if (!listenAll && listenStates == null) {
      return context.use(id);
    }

    return id == null
        ? context.watch<T>(listenStates)
        : context.watchId<T>(id!, listenStates);
  }
}
