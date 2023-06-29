part of '../widgets.dart';

/// A [StatefulWidget] that listens for [Signal]s and re-build when any [Signal] is changed.
///
/// For example:
///
/// ```dart
/// final count = 0.signal;
/// final toggle = false.signal;
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
/// **CONSIDER** Use [child] property to pass a [Widget] that
/// you want to build it once. The [ReactterWatcher] pass it through
/// the [builder] callback, so you can incorporate it into your build:
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
class ReactterWatcher extends StatefulWidget {
  /// Provides a widget , which render one time.
  ///
  /// It's expose on [builder] method as second parameter.
  final Widget? child;

  /// Method which has the render logic
  ///
  /// Exposes [BuilderContext] and [child] widget as parameters.
  /// and returns a widget.
  final TransitionBuilder? builder;

  const ReactterWatcher({
    Key? key,
    this.child,
    this.builder,
  }) : super(key: key);

  @override
  State<ReactterWatcher> createState() => _ReactterWatcherState();
}

class _ReactterWatcherState extends State<ReactterWatcher> {
  final Set<Signal> _signals = {};

  static _ReactterWatcherState? _currentState;

  @override
  Widget build(BuildContext context) {
    _clearSignals();

    final prevState = _currentState;

    _currentState = this;
    Reactter.on(Signal, SignalEvent.onGetValue, _onGetValue);

    final widgetBuit =
        widget.builder?.call(context, widget.child) ?? widget.child!;

    _currentState = prevState;
    Reactter.off(Signal, SignalEvent.onGetValue, _onGetValue);

    return widgetBuit;
  }

  @override
  void dispose() {
    _clearSignals();
    Reactter.off(Signal, SignalEvent.onGetValue, _onGetValue);
    super.dispose();
  }

  _onGetValue(_, Signal signal) {
    if (_currentState != this || _signals.contains(signal)) {
      return;
    }

    Reactter.one(signal, Lifecycle.didUpdate, _onSignalDidUpdate);
    _signals.add(signal);
  }

  void _onSignalDidUpdate(_, __) => setState(() {});

  void _clearSignals() {
    for (var signal in _signals) {
      Reactter.off(signal, Lifecycle.didUpdate, _onSignalDidUpdate);
    }
    _signals.clear();
  }
}
