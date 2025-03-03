part of '../framework.dart';

/// Organizes the widget as nested way
@internal
class NestedWidget<W extends StatelessWidget> extends StatelessWidget {
  const NestedWidget({
    Key? key,
    required this.owner,
    required this.wrappedWidget,
    this.injectedChild,
  }) : super(key: key);

  final WrapperWidget wrappedWidget;
  final Widget? injectedChild;
  final WrapperElementMixin owner;

  @override
  NestedElement createElement() => NestedElement(this);
  // coverage:ignore-start
  @override
  Widget build(BuildContext context) => throw StateError('handled internally');
  // coverage:ignore-end
}

/// [NestedWidget]'s Element
@internal
class NestedElement extends StatelessElement {
  NestedElement(NestedWidget widget) : super(widget);

  @override
  NestedWidget get widget => super.widget as NestedWidget;

  Widget? _injectedChild;
  Widget? get injectedChild => _injectedChild;
  set injectedChild(Widget? value) {
    final previous = _injectedChild;
    if (value is NestedWidget &&
        previous is NestedWidget &&
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

  WrapperWidget? _wrappedWidget;
  WrapperWidget? get wrappedWidget => _wrappedWidget;
  set wrappedWidget(WrapperWidget? value) {
    if (_wrappedWidget != value) {
      _wrappedWidget?.dispose();
      _wrappedWidget = value;
      markNeedsBuild();
    }
  }

  @override
  void mount(Element? parent, dynamic newSlot) {
    widget.owner.addNode(this);
    _wrappedWidget = widget.wrappedWidget;
    _injectedChild = widget.injectedChild;
    super.mount(parent, newSlot);
  }

  @override
  void unmount() {
    widget.owner.removeNode(this);
    super.unmount();
  }

  @override
  Widget build() {
    return wrappedWidget!;
  }
}
