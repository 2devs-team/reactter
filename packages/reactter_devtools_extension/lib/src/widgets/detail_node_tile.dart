import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:reactter_devtools_extension/src/bases/async_node.dart';
import 'package:reactter_devtools_extension/src/bases/node.dart';
import 'package:reactter_devtools_extension/src/utils/color_palette.dart';
import 'package:reactter_devtools_extension/src/widgets/loading.dart';
import 'package:reactter_devtools_extension/src/widgets/node_title.dart';
import 'package:reactter_devtools_extension/src/widgets/tile_builder.dart';

class DetailNodeTile extends StatelessWidget {
  final Node node;

  const DetailNodeTile({
    super.key,
    required this.node,
  });

  @override
  Widget build(BuildContext context) {
    return TreeNodeTileBuilder(
      treeNode: node,
      title: Row(
        children: [
          Text(
            "${node.key}: ",
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: ColorPalette.of(context).key),
          ),
          RtWatcher((context, watch) {
            if (node is AsyncNode) {
              final asyncNode = node as AsyncNode;

              final isLoading = watch(asyncNode.uIsLoading).value;
              if (isLoading) return const Loading();

              final isNeedToLoadNode = watch(asyncNode.uNeedToLoadNode).value;
              if (isNeedToLoadNode) asyncNode.loadNode();
            }

            return NodeTitle(
              key: ObjectKey(node),
              node: node,
            );
          }),
        ],
      ),
      isSelected: false,
      onTap: () {},
    );
  }
}
