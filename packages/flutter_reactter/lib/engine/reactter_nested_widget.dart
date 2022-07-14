part of '../widgets.dart';

/// Organizes the widget as nested way
class ReactterNestedWidget<W extends StatelessWidget> extends StatelessWidget {
  const ReactterNestedWidget({
    Key? key,
    required this.owner,
    required this.wrappedWidget,
    this.injectedChild,
  }) : super(key: key);

  final ReactterWrapperWidget wrappedWidget;
  final Widget? injectedChild;
  final ReactterWrapperElementMixin owner;

  @override
  ReactterNestedElement createElement() => ReactterNestedElement(this);

  @override
  Widget build(BuildContext context) => throw StateError('handled internally');
}

/// [ReactterNestedWidget]'s Element
class ReactterNestedElement extends StatelessElement {
  ReactterNestedElement(ReactterNestedWidget widget) : super(widget);

  @override
  ReactterNestedWidget get widget => super.widget as ReactterNestedWidget;

  Widget? _injectedChild;
  Widget? get injectedChild => _injectedChild;
  set injectedChild(Widget? value) {
    final previous = _injectedChild;
    if (value is ReactterNestedWidget &&
        previous is ReactterNestedWidget &&
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

  ReactterWrapperWidget? _wrappedChild;
  ReactterWrapperWidget? get wrappedChild => _wrappedChild;
  set wrappedChild(ReactterWrapperWidget? value) {
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
