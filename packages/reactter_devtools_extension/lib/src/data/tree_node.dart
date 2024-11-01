import 'dart:collection';
import 'package:flutter_reactter/reactter.dart';

abstract base class TreeNode<E extends TreeNode<E>> extends LinkedListEntry<E>
    with RtStateBase<E>, RtContext {
  final uChildren = UseState(LinkedHashSet<E>());
  final uIsExpanded = UseState(true);

  E? _parent;
  E? get parent => _parent;

  int get depth => (parent?.depth ?? 0) + 1;

  E get lastDescendant {
    if (!uIsExpanded.value) return this as E;
    if (uChildren.value.isEmpty) return this as E;

    return uChildren.value.last.lastDescendant;
  }

  TreeNode() {
    UseEffect(
      _onIsExpandedChanged,
      [uIsExpanded],
    );

    if (list != null) bind(list!);
  }

  @override
  void unlink() {
    if (list == null) return;

    final rList = list;
    super.unlink();
    if (rList is RtState) (rList as RtState).notify();
  }

  @override
  void insertAfter(E entry) {
    if (list == null) return;

    super.insertAfter(entry);
    if (list is RtState) (list as RtState).notify();
  }

  @override
  void insertBefore(E entry) {
    if (list == null) return;

    super.insertBefore(entry);
    if (list is RtState) (list as RtState).notify();
  }

  void replace(E entry) {
    Rt.batch(() {
      if (parent != null) {
        entry._parent = parent;
        insertBefore(entry);
      }

      if (entry.list == null) {
        list?.add(entry);
      }

      entry.uIsExpanded.value = uIsExpanded.value;

      final children = uChildren.value;

      for (final child in [...children]) {
        entry.addChild(child);
      }

      children.clear();

      remove();
    });
  }

  void addChild(E entry) {
    Rt.batch(() {
      if (entry.parent != this) {
        entry.parent?.uChildren.value.remove(entry);
        entry.parent?.uChildren.notify();
        entry._parent = this as E;
        entry
          ..unbind()
          ..bind(this);
      }

      uChildren.value.add(entry);
      uChildren.notify();

      if (uIsExpanded.value) {
        _showChildren();
      } else {
        _hideChildren();
      }
    });
  }

  bool remove() {
    Rt.batch(() {
      final children = uChildren.value.toList();

      for (final node in children) {
        node.remove();
      }

      unlink();

      parent?.uChildren
        ?..value.remove(this)
        ..notify();

      if (!isDisposed) dispose();
    });

    return list == null;
  }

  void _onIsExpandedChanged() {
    Rt.batch(() {
      if (uIsExpanded.value) {
        _showChildren();
      } else {
        _hideChildren();
      }
    });
  }

  void _showChildren() {
    Rt.batch(() {
      E? prevChild;

      for (final node in uChildren.value) {
        node.unlink();

        if (prevChild == null) {
          insertAfter(node);
        } else {
          prevChild.lastDescendant.insertAfter(node);
        }

        if (node.uIsExpanded.value) {
          node._showChildren();
        } else {
          node._hideChildren();
        }

        prevChild = node;
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
}
