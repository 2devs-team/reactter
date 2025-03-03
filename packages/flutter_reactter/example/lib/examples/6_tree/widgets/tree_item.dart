// ignore_for_file: avoid_renaming_method_parameters

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'package:examples/examples/6_tree/states/tree_node.dart';
import 'package:examples/examples/6_tree/widgets/custom_icon_button.dart';

class TreeItem extends RtComponent<TreeNode> {
  final TreeNode treeNode;

  @override
  get builder => () => treeNode;

  @override
  String? get id => treeNode.id;

  String get idStr => id != null ? 'ID: $id' : "root";

  const TreeItem({
    Key? key,
    required this.treeNode,
  }) : super(key: key);

  @override
  Widget render(context, treeNode) {
    return SizedBox(
      height: 36,
      child: InkWell(
        onTap: () => _openDialog(context),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: 22.0 * treeNode.depth),
                      _buildNode(),
                      const Expanded(
                        child: Divider(
                          height: 2,
                          thickness: 2,
                        ),
                      ),
                      _buildCount(),
                    ],
                  ),
                ],
              ),
            ),
            _buildTreeLine(),
          ],
        ),
      ),
    );
  }

  Future<void> _openDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("About the node($idStr)"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Path:"),
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
                  const Text("Children:"),
                  const SizedBox(width: 8),
                  Text(
                    "${treeNode.uChildren.value.length}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              Row(
                children: [
                  const Text("Count:"),
                  const SizedBox(width: 8),
                  Text(
                    "${treeNode.uCount.value}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              Row(
                children: [
                  const Text("Descendants Total:"),
                  const SizedBox(width: 8),
                  Text(
                    "${treeNode.uDescendantsTotal.value}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              Row(
                children: [
                  const Text("Total (Count + Descendants Total):"),
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

  Widget _buildNode() {
    return RtWatcher((context, watch) {
      final children = watch(treeNode.uChildren).value;
      final isExpanded = watch(treeNode.uIsExpanded).value;

      return Container(
        margin: EdgeInsets.only(
          left: children.isEmpty ? 28 : 0,
        ),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 2,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
        ),
        child: Row(
          children: [
            if (children.isNotEmpty)
              CustomIconButton(
                icon: Transform.rotate(
                  angle: isExpanded ? 0 : -pi / 2,
                  child: const Icon(Icons.expand_circle_down_rounded),
                ),
                onPressed: treeNode.toggleExpansion,
              ),
            CustomIconButton(
              icon: const Icon(Icons.add_circle),
              onPressed: treeNode.addChild,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2).copyWith(
                right: treeNode.parent == null ? 8 : 0,
              ),
              child: Text(
                idStr,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            if (treeNode.parent != null)
              CustomIconButton(
                icon: const Icon(Icons.cancel),
                onPressed: treeNode.remove,
              ),
          ],
        ),
      );
    });
  }

  Widget _buildCount() {
    return Builder(
      builder: (context) {
        return Container(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 2,
              ),
            ),
          ),
          child: Row(
            children: [
              CustomIconButton(
                icon: const Icon(Icons.indeterminate_check_box_rounded),
                onPressed: treeNode.decrease,
              ),
              RtWatcher((context, watch) {
                return Text(
                  "${watch(treeNode.uCount).value} (${watch(treeNode.uTotal).value})",
                  style: Theme.of(context).textTheme.bodySmall,
                );
              }),
              CustomIconButton(
                icon: const Icon(Icons.add_box),
                onPressed: treeNode.increase,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTreeLine() {
    if (treeNode.parent == null) {
      return const SizedBox();
    }

    return Positioned(
      top: -2,
      left: -6,
      bottom: 2,
      child: Align(
        alignment: Alignment.topLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._buildParentLines(treeNode, []),
            RtWatcher((context, watch) {
              return SizedBox(
                height: treeNode.parent != null &&
                        watch(treeNode.parent!.uChildren).value.first ==
                            treeNode
                    ? 21
                    : null,
                child: const VerticalDivider(
                  width: 2,
                  thickness: 2,
                ),
              );
            }),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 19),
                RtWatcher((context, watch) {
                  return SizedBox(
                    width: watch(treeNode.uChildren).value.isEmpty ? 32 : 4,
                    child: const Divider(
                      height: 2,
                      thickness: 2,
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildParentLines(TreeNode node, List<Widget> parentLines) {
    if (node.parent == null) {
      return parentLines;
    }

    parentLines.insert(
      0,
      RtWatcher((context, watch) {
        final parentFromParent = node.parent?.parent;
        final hasParentParent = parentFromParent != null;
        final isParentFirst = hasParentParent &&
            watch(parentFromParent.uChildren).value.first == node.parent;

        if (isParentFirst) {
          return const SizedBox(width: 22);
        }

        return Container(
          width: 22,
          alignment: Alignment.centerLeft,
          child: const VerticalDivider(
            width: 2,
            thickness: 2,
          ),
        );
      }),
    );

    return _buildParentLines(node.parent!, parentLines);
  }
}
