part of '../widgets.dart';

class ReactterProviders extends StatelessWidget implements ReactterScopeWidget {
  final List<ReactterProviderAbstraction> _providers;

  /// Provides a widget witch render one time.
  ///
  /// It's expose on [builder] method as second parameter.
  final Widget? _child;

  /// Method which has the render logic
  ///
  /// Exposes [BuilderContext] and [child] widget as parameters.
  /// and returns a widget.
  final TransitionBuilder? _builder;

  const ReactterProviders({
    required List<ReactterProviderAbstraction> providers,
    Key? key,
    Widget? child,
    TransitionBuilder? builder,
  })  : _providers = providers,
        _child = child,
        _builder = builder,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return _builder?.call(context, _child) ?? _child!;
  }

  @override
  ReactterProvidersElement createElement() {
    return ReactterProvidersElement(this);
  }
}

class ReactterProvidersElement extends StatelessElement
    with ReactterScopeElementMixin {
  /// Creates an element that uses the given widget as its configuration.
  ReactterProvidersElement(ReactterProviders widget) : super(widget);

  @override
  ReactterProviders get widget => super.widget as ReactterProviders;

  final nodes = <ReactterNestedProviderElement>{};

  @override
  Widget build() {
    ReactterNestedProviders? nestedHook;
    var nextNode = parent?.injectedChild ??
        Builder(
          builder: (context) => widget.build(context),
        );

    for (final child in widget._providers.reversed) {
      nextNode = nestedHook = ReactterNestedProviders(
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
        if (next is ReactterNestedProviders) {
          nestedHook = next;
        } else {
          break;
        }
      }
    }

    return nextNode;
  }
}
