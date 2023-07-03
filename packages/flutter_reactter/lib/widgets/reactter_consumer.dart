part of '../widgets.dart';

/// A [StatelessWidget] that allows to obtains a [T] instance
/// from the closest ancestor of [ReactterProvider]
/// and passes the instance to [builder].
///
/// Also, it listens for changes from the instance or a [ReactterState] list
/// to rebuild the Widget tree.
///
/// [ReactterConsumer] has same functionality as [ReactterProvider.contextOf].
///
/// Use [id] property to identify the [T] instance.
///
/// Use [listenAll] property for listen to changes from the instance
/// or states defined in [listenStates] property:
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
/// It will be sent through the [builder] callback, so you can incorporate it into your build:
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
/// * [ReactterProvider], a widget that provides a [T] instance through Widget tree.
///
class ReactterConsumer<T extends Object?> extends StatelessWidget {
  const ReactterConsumer({
    Key? key,
    this.id,
    this.listenStates,
    this.listenAll = false,
    this.child,
    this.builder,
  }) : super(key: key);

  /// This identifier can be used to differentiate
  /// between multiple instances of the same type `T`
  /// in the widget tree when using `ReactterProvider`.
  final String? id;

  /// Watchs all states to re-build [builder] method.
  final bool listenAll;

  /// Listens states to re-build [builder] method.
  final ListenStates<T>? listenStates;

  /// Use to pass a single child widget that will be built once
  /// and incorporated into the widget tree.
  final Widget? child;

  /// Use to define a callback function that takes in the instance of type `T`,
  /// the `BuildContext`, and the `child` widget as parameters.
  ///
  /// This callback function is responsible for building the widget tree
  /// based on the obtained instance and the provided child widget.
  final InstanceBuilder<T>? builder;

  @override
  Widget build(BuildContext context) {
    assert(
      !listenAll || listenStates == null,
      "Can't use `listenAll` with `listenStates`",
    );
    assert(child != null || builder != null);

    return builder?.call(
          ReactterProvider.contextOf<T>(
            context,
            id: id,
            listen: listenAll || listenStates != null,
            listenStates: listenStates,
          ),
          context,
          child,
        ) ??
        child!;
  }
}
