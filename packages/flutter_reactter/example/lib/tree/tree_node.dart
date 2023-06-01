import 'package:flutter_reactter/flutter_reactter.dart';

class TreeNode {
  final TreeNode? parent;

  final children = UseState(<TreeNode>[]);
  final childrenTotal = UseState(0);
  final count = UseState(0);
  final hide = UseState(false);

  String get path => "${parent?.path ?? ''} > $hashCode";
  int get total => count.value + childrenTotal.value;

  TreeNode([this.parent]) {
    if (parent != null) {
      UseEffect(parent!._calculateTotal, [count, childrenTotal]);
    }

    UseEffect(() {
      hide.value = false;
      _calculateTotal();
    }, [children]);
  }

  void increase() => count.value++;

  void decrease() => count.value--;

  void toggleHide() => hide.value = !hide.value;

  void addChild() {
    children.update(
      () => children.value.add(TreeNode(this)),
    );
  }

  void removeChild(TreeNode child) {
    children.update(
      () => children.value.remove(child),
    );
  }

  void removeFromParent() => parent?.removeChild(this);

  void _calculateTotal() {
    childrenTotal.value = children.value.fold<int>(
      0,
      (acc, child) => acc + child.total,
    );
  }
}
