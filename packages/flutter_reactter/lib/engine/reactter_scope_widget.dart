part of '../../widgets.dart';

abstract class ReactterScopeWidget implements Widget {
  @override
  ReactterScopeElementMixin createElement();
}

mixin ReactterScopeElementMixin on Element {
  ReactterNestedProviderElement? parent;

  @override
  void mount(Element? parent, dynamic newSlot) {
    if (parent is ReactterNestedProviderElement?) {
      this.parent = parent;
    }
    super.mount(parent, newSlot);
  }

  @override
  void activate() {
    super.activate();
    visitAncestorElements((parent) {
      if (parent is ReactterNestedProviderElement) {
        this.parent = parent;
      }
      return false;
    });
  }
}
