/// I challange you to do the same thing with another solution.
/// You will see that Reactter is faster, simple and easy to use.

import 'dart:collection';
import 'package:flutter_reactter/flutter_reactter.dart';

class TreeNode extends LinkedListEntry<TreeNode>
    with RtContext, RtStateBase<TreeNode> {
  /// A unique identifier for each instance of [TreeNode].
  static int _lastId = 0;
  static String _getId() => (_lastId++).toString();

  final TreeNode? parent;
  final String id = _getId();

  late final String path = parent != null ? "${parent?.path} > $id" : id;
  late final int depth = parent != null ? parent!.depth + 1 : 0;

  final uChildren = UseState(<TreeNode>{});
  final uIsExpanded = UseState(false);
  final uHasNext = UseState(false);
  final uCount = UseState(0);
  final uDescendantsTotal = UseState(0);
  late final uTotal = Rt.lazyState(
    () => UseCompute(
      () => uCount.value + uDescendantsTotal.value,
      [uCount, uDescendantsTotal],
    ),
    this,
  );

  TreeNode._(this.parent) {
    UseEffect(_onIsExpandedChanged, [uIsExpanded]);
    UseEffect(_onChildrenChanged, [uChildren]);

    if (parent != null) {
      UseEffect(parent!._calculateDescendantsTotal, [uTotal]);
    }

    /// Bind the instance to the parent or list
    /// This way, the instance is automatically disposed including it's hooks
    /// when the parent or list is destroyed.
    if (parent != null) {
      bind(parent!);
    } else if (list != null) {
      bind(list!);
    }
  }

  /// Create a new instance of [TreeNode] and register as a singleton.
  /// This way, the instance can be accessed from anywhere in the application
  /// and keep it in memory until it is destroyed.
  factory TreeNode(TreeNode? parent) {
    return Rt.singleton(
      () => TreeNode._(parent),
      id: _lastId.toString(),
    )!;
  }

  @override
  unlink() {
    final rList = list;
    super.unlink();
    if (rList is RtState) (rList as RtState).notify();
  }

  @override
  void insertAfter(TreeNode entry) {
    super.insertAfter(entry);
    if (list is RtState) (list as RtState).notify();
  }

  @override
  void insertBefore(TreeNode entry) {
    super.insertBefore(entry);
    if (list is RtState) (list as RtState).notify();
  }

  void addChild() {
    Rt.batch(() {
      final node = TreeNode(this);

      uChildren.value.add(node);
      uChildren.notify();

      if (uChildren.value.length > 1) {
        node.uHasNext.value = true;
      }

      uIsExpanded.value = true;
      _showChildren();
    });
  }

  void remove() {
    Rt.batch(() {
      final children = uChildren.value.toList();

      for (final node in children) {
        node.remove();
      }

      if (list != null) {
        unlink();
      }

      parent?.uChildren.value.remove(this);
      parent?.uChildren.notify();

      /// It's need to destroy the instance because it's a singleton
      /// and it's not automatically destroyed when it's removed from the parent.
      Rt.destroy<TreeNode>(id: id);
    });
  }

  void toggleExpansion() => uIsExpanded.value = !uIsExpanded.value;

  void increase() => uCount.value++;

  void decrease() => uCount.value--;

  void _onIsExpandedChanged() {
    if (uIsExpanded.value) {
      return _showChildren();
    }

    _hideChildren();
  }

  void _onChildrenChanged() {
    if (uChildren.value.isNotEmpty) {
      uChildren.value.first.uHasNext.value = false;
    }

    _calculateDescendantsTotal();
  }

  void _showChildren() {
    Rt.batch(() {
      for (final node in uChildren.value) {
        if (node.list != null) {
          continue;
        }

        insertAfter(node);

        if (node.uIsExpanded.value) {
          node._showChildren();
        }
      }
    });
  }

  void _hideChildren() {
    Rt.batch(() {
      for (final node in uChildren.value) {
        if (node.list == null) {
          continue;
        }

        node._hideChildren();
        node.unlink();
      }
    });
  }

  void _calculateDescendantsTotal() {
    uDescendantsTotal.value = uChildren.value.fold<int>(
      0,
      (acc, child) => acc + child.uTotal.value,
    );
  }
}
