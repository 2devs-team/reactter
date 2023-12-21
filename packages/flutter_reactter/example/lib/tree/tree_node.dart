import 'package:flutter_reactter/flutter_reactter.dart';

class TreeNode {
  final TreeNode? parent;

  final uHide = UseState(false);
  final uChildren = UseState(<TreeNode>[]);
  final uCount = UseState(0);
  final uChildrenTotal = UseState(0);
  late final uTotal = Reactter.lazyState(
    () => UseCompute(
      () => uCount.value + uChildrenTotal.value,
      [uCount, uChildrenTotal],
    ),
    this,
  );

  String get path => "${parent?.path ?? ''} > $hashCode";

  TreeNode([this.parent]) {
    if (parent != null) {
      UseEffect(
        parent!._calculateChildrenTotal,
        [uTotal],
      );
    }

    UseEffect(() {
      uHide.value = false;
      _calculateChildrenTotal();
    }, [uChildren]);
  }

  void increase() => uCount.value++;

  void decrease() => uCount.value--;

  void toggleHide() => uHide.value = !uHide.value;

  void addChild() {
    uChildren.update(
      () => uChildren.value.add(TreeNode(this)),
    );
  }

  void removeChild(TreeNode child) {
    uChildren.update(
      () => uChildren.value.remove(child),
    );
  }

  void removeFromParent() => parent?.removeChild(this);

  void _calculateChildrenTotal() {
    uChildrenTotal.value = uChildren.value.fold<int>(
      0,
      (acc, child) => acc + child.uTotal.value,
    );
  }
}
