part of '../framework.dart';

/// Abstract class to implementing a wrapper widget
@internal
abstract class ReactterWrapperWidget implements Widget {
  @override
  ReactterWrapperElementMixin createElement();
}

/// Mixin to [ReactterWrapperWidget]'s Element
@internal
mixin ReactterWrapperElementMixin<T extends Widget> on Element {
  ReactterNestedElement? parent;

  final nodes = <ReactterNestedElement>{};

  @override
  T get widget => super.widget as T;

  @override
  void mount(Element? parent, dynamic newSlot) {
    if (parent is ReactterNestedElement?) {
      this.parent = parent;
    }
    super.mount(parent, newSlot);
  }

  @override
  void activate() {
    super.activate();
    visitAncestorElements((parent) {
      if (parent is ReactterNestedElement) {
        this.parent = parent;
      }
      return false;
    });
  }
}
