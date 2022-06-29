part of '../widgets.dart';

class ReactterNestedProviders extends StatelessWidget {
  const ReactterNestedProviders({
    Key? key,
    required this.owner,
    required this.wrappedWidget,
    this.injectedChild,
  }) : super(key: key);

  final ReactterScopeWidget wrappedWidget;
  final Widget? injectedChild;
  final ReactterProvidersElement owner;

  @override
  ReactterNestedProviderElement createElement() =>
      ReactterNestedProviderElement(this);

  @override
  Widget build(BuildContext context) => throw StateError('handled internally');
}

class ReactterNestedProviderElement extends StatelessElement {
  ReactterNestedProviderElement(ReactterNestedProviders widget) : super(widget);

  @override
  ReactterNestedProviders get widget => super.widget as ReactterNestedProviders;

  Widget? _injectedChild;
  Widget? get injectedChild => _injectedChild;
  set injectedChild(Widget? value) {
    final previous = _injectedChild;
    if (value is ReactterNestedProviders &&
        previous is ReactterNestedProviders &&
        Widget.canUpdate(value.wrappedWidget, previous.wrappedWidget)) {
      // no need to rebuild the wrapped widget just for a _NestedHook.
      // The widget doesn't matter here, only its Element.
      return;
    }
    if (previous != value) {
      _injectedChild = value;
      visitChildren((e) => e.markNeedsBuild());
    }
  }

  ReactterScopeWidget? _wrappedChild;
  ReactterScopeWidget? get wrappedChild => _wrappedChild;
  set wrappedChild(ReactterScopeWidget? value) {
    if (_wrappedChild != value) {
      _wrappedChild = value;
      markNeedsBuild();
    }
  }

  @override
  void mount(Element? parent, dynamic newSlot) {
    widget.owner.nodes.add(this);
    _wrappedChild = widget.wrappedWidget;
    _injectedChild = widget.injectedChild;
    super.mount(parent, newSlot);
  }

  @override
  void unmount() {
    widget.owner.nodes.remove(this);
    super.unmount();
  }

  @override
  Widget build() {
    return wrappedChild!;
  }
}
