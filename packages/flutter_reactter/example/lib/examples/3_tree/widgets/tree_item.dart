// ignore_for_file: avoid_renaming_method_parameters

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'package:examples/examples/3_tree/tree_node.dart';
import 'package:examples/examples/3_tree/widgets/custom_icon_button.dart';
import 'package:examples/examples/3_tree/widgets/tree_items.dart';

class TreeItem extends RtComponent<TreeNode> {
  const TreeItem({
    Key? key,
    required this.treeNode,
    this.isTreeNodeLast = false,
  }) : super(key: key);

  final TreeNode treeNode;
  final bool isTreeNodeLast;

  @override
  String get id => "${treeNode.hashCode}";

  @override
  get builder => () => treeNode;

  @override
  Widget render(context, treeContext) {
    return InkWell(
      onTap: () => _openDialog(context),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 8),
                  _buildExpandButton(),
                  CustomIconButton(
                    icon: const Icon(Icons.add_circle),
                    onPressed: treeContext.addChild,
                  ),
                  if (treeContext.parent != null)
                    CustomIconButton(
                      icon: Transform.rotate(
                        angle: -pi / 4,
                        child: const Icon(Icons.add_circle),
                      ),
                      onPressed: treeContext.removeFromParent,
                    ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        id,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildCountLabel(),
                  CustomIconButton(
                    icon: const Icon(Icons.indeterminate_check_box_rounded),
                    onPressed: treeContext.decrease,
                  ),
                  CustomIconButton(
                    icon: const Icon(Icons.add_box),
                    onPressed: treeContext.increase,
                  ),
                ],
              ),
              _buildTreeItems(),
            ],
          ),
          _buildTreeLine(treeContext),
        ],
      ),
    );
  }

  Future<void> _openDialog(BuildContext context) {
    final treeNode = context.use<TreeNode>(id);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("About item[id='$id']"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("path:"),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      treeNode.path,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text("children:"),
                  const SizedBox(width: 8),
                  Text(
                    "${treeNode.uChildren.value.length}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              Row(
                children: [
                  const Text("count:"),
                  const SizedBox(width: 8),
                  Text(
                    "${treeNode.uCount.value}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              Row(
                children: [
                  const Text("childrenTotal:"),
                  const SizedBox(width: 8),
                  Text(
                    "${treeNode.uChildrenTotal.value}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              Row(
                children: [
                  const Text("total(count + childrenTotal):"),
                  const SizedBox(width: 8),
                  Text(
                    "${treeNode.uTotal.value}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExpandButton() {
    return Builder(
      builder: (context) {
        final treeNode = context.watchId<TreeNode>(
          id,
          (inst) => [inst.uIsExpanded, inst.uChildren],
        );

        if (treeNode.uChildren.value.isEmpty) {
          return const SizedBox(width: 36);
        }

        return CustomIconButton(
          icon: Transform.rotate(
            angle: treeNode.uIsExpanded.value ? 0 : -pi / 2,
            child: const Icon(Icons.expand_circle_down_rounded),
          ),
          onPressed: treeNode.toggleExpansion,
        );
      },
    );
  }

  Widget _buildCountLabel() {
    return Builder(
      builder: (context) {
        final treeNode = context.watchId<TreeNode>(
          id,
          (inst) => [inst.uCount, inst.uTotal],
        );

        return Text(
          "${treeNode.uCount.value} (${treeNode.uTotal.value})",
        );
      },
    );
  }

  Widget _buildTreeItems() {
    return Builder(
      builder: (context) {
        final treeNode = context.watchId<TreeNode>(
          id,
          (inst) => [
            inst.uIsExpanded,
            inst.uChildren,
          ],
        );

        return TreeItems(
          children: treeNode.uChildren.value,
          expanded: treeNode.uIsExpanded.value,
        );
      },
    );
  }

  Widget _buildTreeLine(TreeNode treeContext) {
    return Positioned(
      top: 0,
      bottom: 0,
      child: Align(
        alignment: Alignment.topLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: treeContext.parent == null || isTreeNodeLast ? 19 : null,
              child: const VerticalDivider(
                width: 2,
                thickness: 2,
              ),
            ),
            Builder(
              builder: (context) {
                final treeNode = context.watchId<TreeNode>(
                  id,
                  (inst) => [inst.uChildren],
                );

                return SizedBox(
                  width: treeNode.uChildren.value.isEmpty ? 42 : 6,
                  height: 36,
                  child: const Divider(
                    height: 2,
                    thickness: 2,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
