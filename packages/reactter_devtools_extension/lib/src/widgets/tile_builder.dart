import 'package:flutter/material.dart';

import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:reactter_devtools_extension/src/bases/tree_node.dart';
import 'package:reactter_devtools_extension/src/utils/color_palette.dart';

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
      minTileHeight: 24,
      contentPadding: EdgeInsets.zero,
      selected: isSelected,
      selectedTileColor: ColorPalette.of(context).selected,
      onTap: onTap,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          RtWatcher((context, watch) {
            final depth = watch(treeNode.uDepth).value;

            return Row(
              children: List.generate(
                depth.toInt(),
                (index) => Container(
                  padding: const EdgeInsets.only(
                    left: 11,
                  ),
                  child: const VerticalDivider(width: 1),
                ),
              ),
            );
          }),
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
        return Container(
          width: 24,
        );
      }

      final isExpanded = watch(treeNode.uIsExpanded).value;

      return Container(
        padding: const EdgeInsets.only(left: 0),
        child: InkWell(
          child: Icon(
            isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
          ),
          onTap: () {
            treeNode.uIsExpanded.value = !isExpanded;
          },
        ),
      );
    });
  }
}
