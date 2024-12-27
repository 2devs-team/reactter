/// I challange you to do the same thing with another solution.
/// You will see that Reactter is faster, simple and easy to use.

import 'dart:collection';
import 'package:flutter_reactter/flutter_reactter.dart';

base class TreeNode extends LinkedListEntry<TreeNode>
    with RtStateBase<TreeNode>, RtContext {
  /// A unique identifier for each instance of [TreeNode].
  static int _lastId = 0;
  static String _getId() => (_lastId++).toString();

  final String id = _getId();
  final TreeNode? parent;

  late final String path = parent != null ? "${parent!.path} > $id" : id;
  late final int depth = parent != null ? parent!.depth + 1 : 0;

  @override
  String? get debugLabel => id;

  @override
  Map<String, dynamic> get debugInfo => {
        'id': id,
        'path': path,
        'depth': depth,
        'isExpanded': uIsExpanded.value,
        'count': uCount.value,
        'descendantsTotal': uDescendantsTotal.value,
        'total': uTotal.value,
        'parent': parent?.id,
        'children': uChildren.value,
      };

  final uChildren = UseState(<TreeNode>{}, debugLabel: 'uChildren');
  final uIsExpanded = UseState(true, debugLabel: 'uIsExpanded');
  final uCount = UseState(0, debugLabel: 'uCount');
  final uDescendantsTotal = UseState(0, debugLabel: 'uDescendantsTotal');
  late final uTotal = Rt.lazyState(
    () => UseCompute(
      () => uCount.value + uDescendantsTotal.value,
      [uCount, uDescendantsTotal],
      debugLabel: 'uTotal',
    ),
    this,
  );

  TreeNode._(this.parent) {
    UseEffect(
      _onIsExpandedChanged,
      [uIsExpanded],
      debugLabel: 'onIsExpandedChanged',
    );

    UseEffect(
      _onChildrenChanged,
      [uChildren],
      debugLabel: 'onChildrenChanged',
    );

    if (parent != null) {
      UseEffect(
        _onTotalChanged,
        [uTotal],
        debugLabel: 'onTotalChanged',
      );
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
  factory TreeNode([TreeNode? parent]) {
    return Rt.singleton(
      () => Rt.createState(() {
        return TreeNode._(parent);
      }),
      id: _lastId.toString(),
    )!;
  }

  @override
  void dispose() {
    super.dispose();

    /// It's need to destroy the instance because it's a singleton
    /// and it's not automatically destroyed when it's removed from the parent.
    Rt.destroy<TreeNode>(id: id);
  }

  @override
  void unlink() {
    if (list == null) return;

    final rList = list;
    super.unlink();

    if (rList is RtState) (rList as RtState).notify();
  }

  @override
  void insertAfter(TreeNode entry) {
    if (list == null) return;

    super.insertAfter(entry);

    if (list is RtState) (list as RtState).notify();
  }

  @override
  void insertBefore(TreeNode entry) {
    if (list == null) return;

    super.insertBefore(entry);

    if (list is RtState) (list as RtState).notify();
  }

  void addChild() {
    Rt.batch(() {
      final node = TreeNode(this);

      uChildren.value.add(node);
      uChildren.notify();

      uIsExpanded.value = true;
      uIsExpanded.notify();
    });
  }

  bool remove() {
    Rt.batch(() {
      for (final node in uChildren.value.toList()) {
        node.remove();
      }

      unlink();

      parent?.uChildren.value.remove(this);
      parent?.uChildren.notify();

      if (!isDisposed) dispose();
    });

    return list == null;
  }

  void toggleExpansion() => uIsExpanded.value = !uIsExpanded.value;

  void increase() => uCount.value++;

  void decrease() => uCount.value--;

  void _onIsExpandedChanged() {
    Rt.batch(() {
      if (uIsExpanded.value) return _showChildren();

      _hideChildren();
    });
  }

  void _onChildrenChanged() => _calculateDescendantsTotal();

  void _onTotalChanged() => parent?._calculateDescendantsTotal();

  void _calculateDescendantsTotal() {
    uDescendantsTotal.value = uChildren.value.fold<int>(
      0,
      (acc, child) => acc + child.uTotal.value,
    );
  }

  void _showChildren() {
    Rt.batch(() {
      for (final node in uChildren.value) {
        if (node.list != null) continue;

        insertAfter(node);

        if (node.uIsExpanded.value) node._showChildren();
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
