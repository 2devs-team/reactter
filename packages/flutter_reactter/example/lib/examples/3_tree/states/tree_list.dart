import 'dart:collection';

import 'package:flutter_reactter/reactter.dart';

class TreeList<E extends LinkedListEntry<E>> extends LinkedList<E>
    with RtContext, RtStateBase<TreeList<E>> {
  @override
  void add(E entry) => update(() => super.add(entry));

  @override
  void addFirst(E entry) => update(() => super.addFirst(entry));

  @override
  void addAll(Iterable<E> entries) => update(() => super.addAll(entries));

  @override
  bool remove(E entry) {
    final res = super.remove(entry);
    if (res) notify();

    return res;
  }

  @override
  void clear() => update(() => super.clear());
}
