import 'dart:collection';

import 'package:flutter_reactter/reactter.dart';
import 'package:reactter_devtools_extension/src/bases/tree_node.dart';

base class TreeList<E extends TreeNode<E>> extends LinkedList<E>
    with RtContext, RtStateBase<TreeList<E>> {
  final uMaxDepth = UseState(0);

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
  void dispose() {
    clear();
    super.dispose();
  }

  @override
  void clear() {
    super.clear();
    uMaxDepth.value = 0;
    if (!isDisposed) notify();
  }
}
