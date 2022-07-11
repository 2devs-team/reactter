part of '../widgets.dart';

/// A wrapper [StatelessWidget] that allows to use multiple [ReactterProvider] as nested way.
///
/// ```dart
/// ReactterProviders(
///   [
///     ReactterProvider(() => AppContext()),
///     ReactterProvider(() => AppContext(), id: "uniqueId"),
///   ],
///   builder: (context, child) {
///     final appContext = context.read<AppContext>();
///     final appContextWithId = context.watchId<AppContext>("uniqueId");
///     return Column(
///       children: [
///         Text("AppContext's state: ${appContext.stateHook.value}"),
///         Text("appContextWithId's state: ${appContext.stateHook.value}");
///       ],
///     );
///   }
/// )
/// ```
///
/// If you don't want to rebuild a part of [builder] callback, use the [child]
/// property, it's more efficient to build that subtree once instead of
/// rebuilding it on every [ReactterContext] changes.
///
/// ```dart
/// ReactterProviders(
///   [
///     ReactterProvider(() => AppContext()),
///     ReactterProvider(() => AppContext(), id: "uniqueId"),
///   ],
///   child: Text("This widget build only once"),
///   builder: (context, child) {
///     final appContext = context.read<AppContext>();
///     final appContextWithId = context.watchId<AppContext>("uniqueId");
///     return Column(
///       children: [
///         child,
///         Text("AppContext's state: ${appContext.stateHook.value}"),
///         Text("appContextWithId's state: ${appContext.stateHook.value}");
///       ],
///     );
///   }
/// )
/// ```
class ReactterProviders extends StatelessWidget
    implements ReactterWrapperWidget {
  final List<ReactterProviderAbstraction> providers;

  /// Provides a widget witch render one time.
  ///
  /// It's expose on [builder] method as second parameter.
  final Widget? child;

  /// Method which has the render logic
  ///
  /// Exposes [BuilderContext] and [child] widget as parameters.
  /// and returns a widget.
  final TransitionBuilder? builder;

  const ReactterProviders({
    required this.providers,
    Key? key,
    this.child,
    this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return builder?.call(context, child) ?? child!;
  }

  @override
  ReactterProvidersElement createElement() {
    return ReactterProvidersElement(this);
  }
}

class ReactterProvidersElement extends StatelessElement
    with ReactterWrapperElementMixin<ReactterProviders> {
  /// Creates an element that uses the given widget as its configuration.
  ReactterProvidersElement(ReactterProviders widget) : super(widget);

  @override
  Widget build() {
    ReactterNestedWidget? nestedHook;
    var nextNode = parent?.injectedChild ??
        Builder(
          builder: (context) => widget.build(context),
        );

    for (final child in widget.providers.reversed) {
      nextNode = nestedHook = ReactterNestedWidget<ReactterProviders>(
        owner: this,
        wrappedWidget: child,
        injectedChild: nextNode,
      );
    }

    if (nestedHook != null) {
      // We manually update ReactterNestedProviderElement instead of letter widgets do their thing
      // because an item N may be constant but N+1 not. So, if we used widgets
      // then N+1 wouldn't rebuild because N didn't change
      for (final node in nodes) {
        node
          ..wrappedChild = nestedHook!.wrappedWidget
          ..injectedChild = nestedHook.injectedChild;

        final next = nestedHook.injectedChild;
        if (next is ReactterNestedWidget) {
          nestedHook = next;
        } else {
          break;
        }
      }
    }

    return nextNode;
  }
}
