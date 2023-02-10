import 'package:flutter_reactter/flutter_reactter.dart';

class TreeContext extends ReactterContext {
  final TreeContext? parent;

  late final count = UseState(0, this);
  late final total = UseState(0, this);
  late final children = UseState(<TreeContext>[], this);
  late final hide = UseState(false, this);

  String get path => "${parent?.path ?? ''} > $hashCode";

  TreeContext([this.parent]) {
    if (parent != null) {
      UseEffect(() {
        UseEvent.withInstance(this).on(
          Lifecycle.didUpdate,
          (_, __) => parent?._calculateTotal(),
        );
      }, [], this);
    }

    UseEffect(_calculateTotal, [count, children]);
  }

  void increase() => count.value++;

  void decrease() => count.value--;

  void addChild() {
    final child = TreeContext(this);
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

  void _calculateTotal() {
    int acc = 0;
    for (int i = 0; i < children.value.length; i++) {
      final child = children.value[i];

      acc += child.total.value;
    }

    total.value = count.value + acc;
  }
}
