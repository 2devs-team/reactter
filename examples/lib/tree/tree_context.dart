import 'package:reactter/reactter.dart';

class TreeContext extends ReactterContext {
  TreeContext? parent;

  late final count = UseState(0, this);
  late final children = UseState(<TreeContext>[], this);
  late final hide = UseState(false, this);

  void increment() => count.value++;

  void decrement() => count.value--;

  void addChild() {
    final child = TreeContext();
    child.parent = this;

    children.update(() => children.value.add(child));
    hide.value = false;
  }

  void removeChild(TreeContext child) {
    children.update(() => children.value.remove(child));
  }

  void removeFromParent() {
    parent?.removeChild(this);
  }

  void toggleHide() {
    hide.value = !hide.value;
  }
}
