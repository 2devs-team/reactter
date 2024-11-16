part of '../widgets.dart';

/// {@template flutter_reactter.rt_consumer}
/// A [StatelessWidget] that allows to obtain the instance of the [T] dependency
/// from the closest ancestor [RtProvider] and passes the instance
/// to [builder].
///
/// Also, listens for dependency changes or a [RtState] list
/// to rebuild the widget tree.
///
/// [RtConsumer] has same functionality as [RtProvider.contextOf].
///
/// Use [id] property to identify the [T] dependency.
///
/// Use [listenAll] property to listen changes to the dependency
/// or the states defined in [listenStates] property:
///
///```dart
/// RtConsumer<AppController>(
///   listenStates: (inst) => [inst.stateA],
///   builder: (context, appController, child) {
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
/// RtConsumer<AppController>(
///   listenAll: true,
///   child: Text("This widget build only once"),
///   builder: (context, appController, child) {
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
/// * [RtState], a state in reactter.
/// * [RtProvider], a widget that provides a [T] dependency through Widget.
/// tree.
///{@endtemplate}
class RtConsumer<T extends Object?> extends StatelessWidget {
  /// {@macro reactter_consumer}
  const RtConsumer({
    Key? key,
    this.id,
    this.listenStates,
    this.listenAll = false,
    this.child,
    required this.builder,
  }) : super(key: key);

  /// This identifier can be used to differentiate
  /// between multiple instances of the same type [T]
  /// in the widget tree when using [RtProvider].
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
  /// Exposes the [BuildContext], the instance of the [T] dependency,
  /// and the [child] widget as arguments, and returns a widget.
  final InstanceChildBuilder<T> builder;

  @override
  Widget build(BuildContext context) {
    assert(
      !listenAll || listenStates == null,
      "Can't use `listenAll` with `listenStates`",
    );

    return builder(
      context,
      RtProvider.contextOf<T>(
        context,
        id: id,
        listen: listenAll || listenStates != null,
        listenStates: listenStates,
      ),
      child,
    );
  }
}
