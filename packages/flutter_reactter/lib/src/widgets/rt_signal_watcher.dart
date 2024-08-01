part of '../widgets.dart';

/// {@template flutter_reactter.rt_signal_watcher}
/// A [StatefulWidget] that listens for [Signal]s and re-build when any [Signal] is changed.
///
/// For example:
///
/// ```dart
/// final count = Signal(0);
/// final toggle = Signal(false);
///
/// class Example extends StatelessWidget {
///   Widget build(context) {
///     return RtSignalWatcher(
///       build: (context, child) {
///         return Column(
///           children: [
///             Text("Count: $count"),
///             Text("Toggle is: $toggle"),
///           ],
///         );
///       },
///     );
///   }
/// }
/// ```
///
/// Build the widget tree with the values of the [Signal]s contained in
/// the [RtSignalWatcher], and with each change of its values,
/// it will re-build the widget tree.
//
/// Use [child] property to pass a [Widget] which to be built once only.
/// It will be sent through the [builder] callback, so you can incorporate it
/// into your build:
///
/// ```dart
/// RtSignalWatcher(
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
///   builder: (context, child) {
///     return Column(
///       children: [
///         Text("Count: $count"),
///         Text("Toggle is: $toggle"),
///         if (child != null) child, // Row with 2 buttons
///       ],
///     );
///   },
/// );
/// ```
///
/// See also:
///
/// * [Signal], a reactive state of any type.
/// {@endtemplate}
class RtSignalWatcher extends StatefulWidget {
  /// {@macro flutter_reactter.rt_signal_watcher}
  const RtSignalWatcher({
    Key? key,
    this.child,
    required this.builder,
  }) : super(key: key);

  /// Provides a widget , which render one time.
  ///
  /// It's expose on [builder] method as second parameter.
  final Widget? child;

  /// Method which has the render logic
  ///
  /// Exposes [BuilderContext] and [child] widget as parameters.
  /// and returns a widget.
  final TransitionBuilder? builder;

  @override
  State<RtSignalWatcher> createState() => _RtSignalWatcherState();
}

class _RtSignalWatcherState extends State<RtSignalWatcher> {
  static _RtSignalWatcherState? _currentState;
  final Set<RtState> _states = {};

  @override
  Widget build(BuildContext context) {
    final prevState = _currentState;

    _currentState = this;
    Rt.on(Signal, SignalEvent.onGetValue, _onWatch);

    final widgetBuit =
        widget.builder?.call(context, widget.child) ?? widget.child!;

    _currentState = prevState;
    Rt.off(Signal, SignalEvent.onGetValue, _onWatch);

    return widgetBuit;
  }

  @override
  void dispose() {
    _clearStates();
    super.dispose();
  }

  void _onWatch(_, RtState state) {
    if (_currentState != this || _states.contains(state)) {
      return;
    }

    _addState(state);
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

  void _addState(RtState state) {
    _states.add(state);
    Rt.on(state, Lifecycle.didUpdate, _onStateDidUpdate);
  }

  void _clearStates() {
    for (final state in _states) {
      Rt.off(state, Lifecycle.didUpdate, _onStateDidUpdate);
    }

    _states.clear();
  }
}

/// {@macro flutter_reactter.rt_signal_watcher}
@Deprecated('Use `RtSignalWatcher` instead.')
typedef ReactterWatcher = RtSignalWatcher;
