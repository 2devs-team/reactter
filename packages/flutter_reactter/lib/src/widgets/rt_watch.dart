part of '../widgets.dart';

/// {@template flutter_reactter.rt_watch}
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
///     return RtWatch((context, watch) {
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
/// While using [RtWatch], you can watch the state changes of [RtState]s using the [watch] method.
/// It will re-build the widget tree when the watched state changes.
///
/// Use [RtWatch.builder] to pass a [builder] method which has the render logic.
/// It exposes [BuilderContext], [WatchBuilder] and [child] widget as parameters.
///
/// Use [child] property to pass a [Widget] which to be built once only.
/// It will be sent through the [builder] callback, so you can incorporate it
/// into your build:
///
/// ```dart
/// RtWatch.builder(
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
///
/// {@endtemplate}
class RtWatch extends StatefulWidget {
  /// {@macro flutter_reactter.rt_watch}
  const RtWatch(this.directBuilder, {Key? key})
      : child = null,
        builder = null,
        super(key: null);

  /// {@macro flutter_reactter.watch_builder}
  final WatchBuilder? directBuilder;

  const RtWatch.builder({
    Key? key,
    this.child,
    required this.builder,
  })  : directBuilder = null,
        super(key: key);

  /// Provides a widget , which render one time.
  ///
  /// It's expose on [builder] method as second parameter.
  final Widget? child;

  /// {@macro flutter_reactter.watch_child_builder}
  final WatchChildBuilder? builder;

  @override
  State<RtWatch> createState() => _RtWatchState();
}

class _RtWatchState extends State<RtWatch> {
  final Set<RtState> _states = {};

  static _RtWatchState? _currentState;

  @override
  Widget build(BuildContext context) {
    final prevState = _currentState;

    _currentState = this;

    final widgetBuit = widget.directBuilder?.call(context, _watchState) ??
        widget.builder?.call(context, _watchState, widget.child) ??
        widget.child!;

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
    Future.microtask(
      () => setState(() {}),
    );
  }

  void _clearStates() {
    for (var state in _states) {
      Rt.off(state, Lifecycle.didUpdate, _onStateDidUpdate);
    }
    _states.clear();
  }
}
