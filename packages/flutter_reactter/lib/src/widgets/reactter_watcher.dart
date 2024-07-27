part of '../widgets.dart';

/// {@template reactter_watcher}
/// A [StatefulWidget] that listens for [Signal]s and re-build when any [Signal] is changed.
///
/// For example:
///
/// ```dart
/// final count = Signal(0);
/// final toggle = Signal(false);
///
/// class Example extends StatelessWidget {
///   ...
///   Widget build(context) {
///     return ReactterWatcher(
///       builder: (context, child) {
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
/// the [ReactterWatcher] [builder], and with each change of its values,
/// it will re-build the widget tree.
///
/// Use [child] property to pass a [Widget] which to be built once only.
/// It will be sent through the [builder] callback, so you can incorporate it
/// into your build:
///
/// ```dart
/// ReactterWatcher(
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
///         child, // Row with 2 buttons
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
class ReactterWatcher extends StatefulWidget {
  /// {@macro reactter_watcher}
  const ReactterWatcher({
    Key? key,
    this.child,
    this.builder,
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
  State<ReactterWatcher> createState() => _ReactterWatcherState();
}

class _ReactterWatcherState extends State<ReactterWatcher> {
  final Set<Signal> _signals = {};

  static _ReactterWatcherState? _currentState;

  @override
  Widget build(BuildContext context) {
    final prevState = _currentState;

    _currentState = this;
    Rt.on(Signal, SignalEvent.onGetValue, _onGetValue);

    final widgetBuit =
        widget.builder?.call(context, widget.child) ?? widget.child!;

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
