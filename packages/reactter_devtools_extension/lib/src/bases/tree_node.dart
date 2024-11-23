import 'dart:collection';
import 'package:flutter_reactter/reactter.dart';

abstract base class TreeNode<E extends TreeNode<E>> extends LinkedListEntry<E>
    with RtStateBase<E>, RtContext {
  final uChildren = UseState(LinkedHashSet<E>());
  final uIsExpanded = UseState(true);
  final uDepth = UseState(0);

  E? _parent;
  E? get parent => _parent;

  E get lastDescendant {
    if (!uIsExpanded.value) return this as E;
    if (uChildren.value.isEmpty) return this as E;

    return uChildren.value.last.lastDescendant;
  }

  int? getIndex() => list?.indexed.firstWhere((e) => e.$2 == this).$1;

  TreeNode() {
    UseEffect(_onIsExpandedChanged, [uIsExpanded]);

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

  void replaceFor(E entry) {
    Rt.batch(() {
      entry._toParent(parent);

      for (final child in [...uChildren.value]) {
        entry.addChild(child);
      }

      entry.uIsExpanded.update(() {
        entry.uIsExpanded.value = uIsExpanded.value;
      });

      uChildren.update(() {
        uChildren.value.clear();
      });

      remove();
    });
  }

  void addChild(E entry) {
    Rt.batch(() {
      entry._toParent(this as E);

      uChildren.update(() {
        uChildren.value.add(entry);
      });
    });
  }

  bool remove() {
    Rt.batch(() {
      unlink();

      for (final node in [...uChildren.value]) {
        node.remove();
      }

      final parentIsDisposed = parent?.uChildren.isDisposed ?? true;
      if (!parentIsDisposed) {
        parent?.uChildren.update(() {
          parent?.uChildren.value.remove(this);
        });
      }

      if (!isDisposed) dispose();
    });

    return list == null;
  }

  void _toParent(E? parentToSet) {
    if (parentToSet == _parent) return;

    _parent?.uChildren.value.remove(this);
    _parent?.uChildren.notify();
    _parent = parentToSet;

    unbind();
    unlink();

    if (_parent != null) bind(_parent!);

    if (_parent?.uIsExpanded.value ?? false) {
      _parent?.lastDescendant.insertAfter(this as E);
    }

    _recalculateDepth();
    uIsExpanded.notify();
  }

  void _recalculateDepth() {
    uDepth.value = parent?.uDepth.value == null ? 0 : parent!.uDepth.value + 1;

    for (final child in [...uChildren.value]) {
      child._recalculateDepth();
    }
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
    if (list == null) return;

    Rt.batch(() {
      E? prevChild;

      for (final node in [...uChildren.value]) {
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
        if (node.list == null) continue;

        node._hideChildren();
        node.unlink();
      }
    });
  }
}
