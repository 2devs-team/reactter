// ignore_for_file: avoid_renaming_method_parameters

import 'package:flutter/material.dart';

import '../tree_node.dart';
import 'tree_item.dart';

class TreeItems extends StatefulWidget {
  const TreeItems({
    super.key,
    required this.children,
    required this.expanded,
  });

  final List<TreeNode> children;
  final bool expanded;

  @override
  State<TreeItems> createState() => _TreeItemsState();
}

class _TreeItemsState extends State<TreeItems> with TickerProviderStateMixin {
  late AnimationController _rotationController;

  bool _hide = false;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )
      ..drive(CurveTween(curve: Curves.easeOut))
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          return setState(() {
            _hide = true;
          });
        }

        if (_hide) {
          setState(() {
            _hide = false;
          });
        }
      });

    if (widget.expanded) {
      _rotationController.forward();
    }
  }

  @override
  void didUpdateWidget(TreeItems oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.expanded) {
      _rotationController.forward();
    } else {
      _rotationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Remove instance build
    if (_hide) return const SizedBox();

    final treeItems = _generateTreeItems();

    return SizeTransition(
      sizeFactor: _rotationController,
      axisAlignment: -1,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              children: treeItems,
            ),
          ),
        ],
      ),
    );
  }

  void toggleExpansion() {
    if (widget.expanded) {
      _rotationController.forward();
    } else {
      _rotationController.reverse();
    }

    setState(() {});
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  List<Widget> _generateTreeItems() {
    final treeNodes = widget.children;
    final treeNodeLast = treeNodes.isNotEmpty ? treeNodes.last : null;

    return [
      for (final treeNode in treeNodes)
        // Fix StackOverflowError when building too many TreeItem
        if (treeNodes.indexOf(treeNode) % 2 == 0)
          LayoutBuilder(
            builder: (_, __) {
              return TreeItem(
                key: ObjectKey(treeNode),
                treeNode: treeNode,
                isTreeNodeLast: treeNode == treeNodeLast,
              );
            },
          )
        else
          TreeItem(
            key: ObjectKey(treeNode),
            treeNode: treeNode,
            isTreeNodeLast: treeNode == treeNodeLast,
          ),
    ];
  }
}
