part of '../widgets.dart';

/// {@template reactter_consumer}
/// A [StatelessWidget] that allows to obtain an instance of [T] type
/// from the closest ancestor [ReactterProvider] and passes the instance
/// to [builder].
///
/// Also, listens for instance changes or a [ReactterState] list
/// to rebuild the widget tree.
///
/// [ReactterConsumer] has same functionality as [ReactterProvider.contextOf].
///
/// Use [id] property to identify the [T] instance.
///
/// Use [listenAll] property to listen changes to the instance
/// or the states defined in [listenStates] property:
///
///```dart
/// ReactterConsumer<AppController>(
///   listenStates: (inst) => [inst.stateA],
///   builder: (context, child) {
///     return Column(
///       children: [
///         Text("state: ${appController.stateA.value}"),
///         child,
///       ],
///     );
///   },
/// )
/// ```
///
/// Use [child] property to pass a [Widget] which to be built once only.
/// It will be sent through the [builder] callback, so you can incorporate it
/// into your build:
///
///```dart
/// ReactterConsumer<AppController>(
///   listenAll: true,
///   child: Text("This widget build only once"),
///   builder: (context, child) {
///     return Column(
///       children: [
///         Text("state: ${appController.stateA.value}"),
///         child,
///       ],
///     );
///   },
/// )
///```
///
/// See also:
///
/// * [ReactterState], a state in reactter.
/// * [ReactterProvider], a widget that provides a [T] instance through Widget.
/// tree.
///{@endtemplate}
class ReactterConsumer<T extends Object?> extends StatelessWidget {
  /// {@macro reactter_consumer}
  const ReactterConsumer({
    Key? key,
    this.id,
    this.listenStates,
    this.listenAll = false,
    this.child,
    required this.builder,
  }) : super(key: key);

  /// This identifier can be used to differentiate
  /// between multiple instances of the same type [T]
  /// in the widget tree when using [ReactterProvider].
  final String? id;

  /// Watchs all states to re-build [builder] method.
  final bool listenAll;

  /// Listens states to re-build [builder] method.
  final ListenStates<T>? listenStates;

  /// Use to pass a single child widget that will be built once
  /// and incorporated into the widget tree.
  final Widget? child;

  /// Method which is responsible for building the widget tree.
  ///
  /// Exposes the instance of type [T], the [BuildContext],
  /// and the [child] widget as arguments, and returns a widget.
  final InstanceContextBuilder<T> builder;

  @override
  Widget build(BuildContext context) {
    assert(
      !listenAll || listenStates == null,
      "Can't use `listenAll` with `listenStates`",
    );

    return builder(
      ReactterProvider.contextOf<T>(
        context,
        id: id,
        listen: listenAll || listenStates != null,
        listenStates: listenStates,
      ),
      context,
      child,
    );
  }
}
