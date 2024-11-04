import 'package:flutter/material.dart';

import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:reactter_devtools_extension/src/data/tree_node.dart';

class TreeNodeTileBuilder extends StatelessWidget {
  final TreeNode treeNode;
  final bool isSelected;
  final Widget title;
  final void Function()? onTap;

  const TreeNodeTileBuilder({
    super.key,
    required this.treeNode,
    required this.title,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(vertical: 0, horizontal: 0),
      horizontalTitleGap: 0,
      minVerticalPadding: 0,
      contentPadding: EdgeInsets.zero,
      minTileHeight: 24,
      selected: isSelected,
      selectedTileColor: Theme.of(context).focusColor,
      onTap: onTap,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ...List.generate(
            treeNode.depth.toInt() - 1,
            (index) => Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: (index == treeNode.depth.toInt() - 2) ? 0 : 0,
              ),
              child: const VerticalDivider(width: 1),
            ),
          ),
          TileExpandable(treeNode: treeNode),
          title,
        ],
      ),
    );
  }
}

class TileExpandable extends StatelessWidget {
  final TreeNode treeNode;

  const TileExpandable({super.key, required this.treeNode});

  @override
  Widget build(BuildContext context) {
    return RtWatcher((context, watch) {
      final children = watch(treeNode.uChildren).value;

      if (children.isEmpty) {
        return const SizedBox(width: 11);
      }

      final isExpanded = watch(treeNode.uIsExpanded).value;

      return Padding(
        padding: const EdgeInsets.only(left: 8),
        child: IconButton(
          padding: EdgeInsets.zero,
          splashRadius: 18,
          iconSize: 24,
          constraints: const BoxConstraints.tightForFinite(),
          icon: Icon(
            isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
          ),
          onPressed: () {
            treeNode.uIsExpanded.value = !isExpanded;
          },
        ),
      );
    });
  }
}
