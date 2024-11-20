part of '../framework.dart';

/// Abstract class to implementing a wrapper widget
@internal
abstract class WrapperWidget implements Widget {
  @override
  WrapperElementMixin createElement();

  void dispose();
}

/// Mixin to [WrapperWidget]'s Element
@internal
mixin WrapperElementMixin<T extends Widget> on Element {
  NestedElement? parent;

  final nodes = <NestedElement>{};

  @override
  T get widget => super.widget as T;

  @override
  void mount(Element? parent, dynamic newSlot) {
    if (parent is NestedElement?) {
      this.parent = parent;
    }
    super.mount(parent, newSlot);
  }

  @override
  void activate() {
    super.activate();
    visitAncestorElements((parent) {
      if (parent is NestedElement) {
        this.parent = parent;
      }
      return false;
    });
  }

  void addNode(NestedElement node) {
    nodes.add(node);
  }

  void removeNode(NestedElement node) {
    nodes.remove(node);
  }
}
