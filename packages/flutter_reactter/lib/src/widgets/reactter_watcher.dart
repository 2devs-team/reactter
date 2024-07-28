part of '../widgets.dart';

/// {@template flutter_reactter.rt_watcher}
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
///     return RtWatcher((context) => Column(
///           children: [
///             Text("Count: $count"),
///             Text("Toggle is: $toggle"),
///           ],
///        ),
///     );
///   }
/// }
/// ```
///
/// Build the widget tree with the values of the [Signal]s contained in
/// the [RtWatcher], and with each change of its values,
/// it will re-build the widget tree.
///
/// Use [RtWatcher.builder] to pass a [builder] method which has the render logic.
/// It exposes [BuilderContext] and [child] widget as parameters.
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
class RtWatcher extends StatefulWidget {
  /// {@macro flutter_reactter.rt_watcher}
  const RtWatcher(this.directBuilder, {Key? key})
      : child = null,
        builder = null,
        super(key: null);

  /// Method which has the render logic
  /// Exposes [BuilderContext] and returns a widget.
  final WidgetBuilder? directBuilder;

  const RtWatcher.builder({
    Key? key,
    this.child,
    required this.builder,
  })  : directBuilder = null,
        super(key: key);

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
  State<RtWatcher> createState() => _RtWatcherState();
}

class _RtWatcherState extends State<RtWatcher> {
  final Set<Signal> _signals = {};

  static _RtWatcherState? _currentState;

  @override
  Widget build(BuildContext context) {
    final prevState = _currentState;

    _currentState = this;
    Rt.on(Signal, SignalEvent.onGetValue, _onGetValue);

    final widgetBuit = widget.directBuilder?.call(context) ??
        widget.builder?.call(context, widget.child) ??
        widget.child!;

    _currentState = prevState;
    Rt.off(Signal, SignalEvent.onGetValue, _onGetValue);

    return widgetBuit;
  }

  @override
  void dispose() {
    _clearSignals();
    super.dispose();
  }

  void _onGetValue(_, Signal signal) {
    if (_currentState != this || _signals.contains(signal)) {
      return;
    }

    _signals.add(signal);
    Rt.on(signal, Lifecycle.didUpdate, _onSignalDidUpdate);
  }

  void _onSignalDidUpdate(_, __) {
    _clearSignals();
    Future.microtask(
      () => setState(() {}),
    );
  }

  void _clearSignals() {
    for (var signal in _signals) {
      Rt.off(signal, Lifecycle.didUpdate, _onSignalDidUpdate);
    }
    _signals.clear();
  }
}

/// {@template flutter_reactter.reactter_watcher}
/// A [StatefulWidget] that listens for [Signal]s and re-build when any [Signal] is changed.
/// It's a deprecated version of [RtWatcher].
/// {@endtemplate}
@Deprecated(
  'Use `RtWatcher.builder` instead, or use `RtWatcher` directly if you don\'t need a child.',
)
class ReactterWatcher extends RtWatcher {
  const ReactterWatcher({
    Key? key,
    required TransitionBuilder builder,
    Widget? child,
  }) : super.builder(key: key, builder: builder, child: child);
}
