import 'dart:collection';

import 'package:examples/examples/6_tree/states/tree_node.dart';
import 'package:flutter_reactter/reactter.dart';

base class TreeList extends LinkedList<TreeNode>
    with RtContextMixin, RtStateBase<TreeList> {
  TreeList._();

  factory TreeList() {
    return Rt.createState(() => TreeList._());
  }

  @override
  void add(TreeNode entry) {
    update(() {
      super.add(entry);

      entry.bind(this);
    });
  }

  @override
  void addFirst(TreeNode entry) {
    update(() {
      super.addFirst(entry);

      entry.bind(this);
    });
  }

  @override
  void addAll(Iterable<TreeNode> entries) {
    update(() {
      super.addAll(entries);

      for (final entry in entries) {
        entry.bind(this);
      }
    });
  }

  @override
  bool remove(TreeNode entry) {
    Rt.destroy<TreeNode>(id: entry.id);

    final res = super.remove(entry);

    if (res) notify();

    return res;
  }

  @override
  void dispose() {
    clear();
    super.dispose();
  }

  @override
  void clear() {
    super.clear();
    if (!isDisposed) notify();
  }
}
