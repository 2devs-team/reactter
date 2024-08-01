part of '../widgets.dart';

/// {@template flutter_reactter.rt_watcher}
/// **This widget is EXPERIMENTAL and may be changed in the future.**
///
/// A [StatefulWidget] that listens for [RtState]s and re-build when any watched [RtState] changes.
///
/// For example:
///
/// ```dart
/// final count = UseState(0);
/// final toggle = UseState(false);
///
/// class Example extends StatelessWidget {
///   Widget build(context) {
///     return RtWatcher((context, watch) {
///       return Column(
///           children: [
///             Text("Count: ${watch(count).value}"),
///             Text("Toggle is: ${watch(toggle).value}"),
///           ],
///        );
///     });
///   }
/// }
/// ```
/// While using [RtWatcher], you can watch the state changes of [RtState]s using the [watch] method.
/// It will re-build the widget tree when the watched state changes.
///
/// Use [RtWatcher.builder] to pass a [builder] method which has the render logic.
/// It exposes [BuilderContext], [WatchBuilder] and [child] widget as parameters.
///
/// Use [child] property to pass a [Widget] which to be built once only.
/// It will be sent through the [builder] callback, so you can incorporate it
/// into your build:
///
/// ```dart
/// RtWatcher.builder(
///   child: Row(
///     children: [
///       ElevatedButton(
///         onPressed: () => signal.value += 1,
///         child: const Text("Increase +1"),
///       ),
///       ElevatedButton(
///         onPressed: () => toggle(!toggle.value),
///         child: const Text("Toggle"),
///       ),
///     ],
///   ),
///   builder: (context, watch, child) {
///     return Column(
///       children: [
///         Text("Count: ${watch(count).value}"),
///         Text("Toggle is: ${watch(toggle).value}"),
///         if (child != null) child, // Row with 2 buttons
///       ],
///     );
///   },
/// );
/// ```
/// {@endtemplate}
class RtWatcher extends StatefulWidget {
  /// {@macro flutter_reactter.rt_watcher}
  RtWatcher(
    WatchBuilder builder, {
    Key? key,
  })  : child = null,
        builder = ((context, watch, _) => builder.call(context, watch)),
        super(key: key);

  const RtWatcher.builder({
    Key? key,
    this.child,
    required this.builder,
  }) : super(key: key);

  /// Provides a widget , which render one time.
  ///
  /// It's expose on [builder] method as second parameter.
  final Widget? child;

  /// {@macro flutter_reactter.watch_child_builder}
  final WatchChildBuilder builder;

  @override
  State<RtWatcher> createState() => _RtWatcherState();
}

class _RtWatcherState extends State<RtWatcher> {
  final Set<RtState> _states = {};

  static _RtWatcherState? _currentState;

  @override
  Widget build(BuildContext context) {
    final prevState = _currentState;

    _currentState = this;

    final widgetBuit = widget.builder(context, _watchState, widget.child);

    _currentState = prevState;

    return widgetBuit;
  }

  @override
  void dispose() {
    _clearStates();
    super.dispose();
  }

  T _watchState<T extends RtState>(T state) {
    if (_currentState != this || _states.contains(state)) {
      return state;
    }

    _states.add(state);
    Rt.on(state, Lifecycle.didUpdate, _onStateDidUpdate);

    return state;
  }

  void _onStateDidUpdate(_, __) {
    _clearStates();
    _rebuild();
  }

  void _rebuild() async {
    if (!mounted) return;

    // coverage:ignore-start
    if (SchedulerBinding.instance.schedulerPhase != SchedulerPhase.idle) {
      await SchedulerBinding.instance.endOfFrame;
    }
    // coverage:ignore-end

    if (!mounted) return;

    (context as Element).markNeedsBuild();
  }

  void _clearStates() {
    for (final state in _states) {
      Rt.off(state, Lifecycle.didUpdate, _onStateDidUpdate);
    }
    _states.clear();
  }
}
