import 'dart:collection';

import 'package:flutter_reactter/reactter.dart';
import 'package:reactter_devtools_extension/src/data/tree_node.dart';

final class TreeList<E extends TreeNode<E>> extends LinkedList<E>
    with RtContext, RtStateBase<TreeList<E>> {
  TreeList._();

  factory TreeList() => Rt.createState(() => TreeList<E>._());

  @override
  void add(E entry) => update(() => super.add(entry));

  @override
  void addFirst(E entry) => update(() => super.addFirst(entry));

  @override
  void addAll(Iterable<E> entries) => update(() => super.addAll(entries));

  @override
  bool remove(E entry) => entry.remove();

  @override
  void clear() {
    Rt.batch(() {
      for (final entry in this) {
        if (!entry.isDisposed) entry.dispose();
      }

      super.clear();

      notify();
    });
  }
}
