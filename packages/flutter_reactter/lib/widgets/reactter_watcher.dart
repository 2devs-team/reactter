part of '../widgets.dart';

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

class _ReactterWatcherState extends State<ReactterWatcher>
    with ReactterSignalProxy {
  final Set<Signal> _signals = {};

  @override
  Widget build(BuildContext context) {
    _clearSignals();

    ReactterSignalProxy? signalProxyPrev = Reactter.signalProxy;
    Reactter.signalProxy = this;

    final widgetBuit =
        widget.builder?.call(context, widget.child) ?? widget.child!;

    Reactter.signalProxy = signalProxyPrev;

    return widgetBuit;
  }

  @override
  void dispose() {
    _clearSignals();
    super.dispose();
  }

  @override
  void addSignal(Signal signal) {
    Reactter.signalProxy = null;
    if (!_signals.contains(signal)) {
      Reactter.one(signal, Lifecycle.didUpdate, _onSignalDidUpdate);
      _signals.add(signal);
    }
    Reactter.signalProxy = this;
  }

  _onSignalDidUpdate(_, __) {
    setState(() {});
  }

  _clearSignals() {
    for (var signal in _signals) {
      Reactter.off(signal, Lifecycle.didUpdate, _onSignalDidUpdate);
    }
    _signals.clear();
  }
}
