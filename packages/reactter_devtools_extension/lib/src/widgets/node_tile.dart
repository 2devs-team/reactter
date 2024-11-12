import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:reactter_devtools_extension/src/data/constants.dart';
import 'package:reactter_devtools_extension/src/interfaces/node.dart';
import 'package:reactter_devtools_extension/src/widgets/instance_title.dart';
import 'package:reactter_devtools_extension/src/widgets/tile_builder.dart';

class NodeTile extends StatelessWidget {
  final INode node;
  final void Function()? onTap;

  const NodeTile({
    super.key,
    required this.node,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RtWatcher((context, watch) {
      final isSelected = watch(node.uIsSelected).value;

      return TreeNodeTileBuilder(
        treeNode: node,
        title: NodeTileTitle(node: node),
        isSelected: isSelected,
        onTap: onTap,
      );
    });
  }
}

class NodeTileIcon extends StatelessWidget {
  final String kind;

  const NodeTileIcon({super.key, required this.kind});

  @override
  Widget build(BuildContext context) {
    final nodeKind = NodeKind.getKind(kind);

    return CircleAvatar(
      backgroundColor: nodeKind.color,
      child: Text(
        nodeKind.abbr,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class NodeTileTitle extends StatelessWidget {
  final INode node;

  const NodeTileTitle({
    super.key,
    required this.node,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox.square(
          dimension: 24,
          child: Padding(
            padding: const EdgeInsets.all(4).copyWith(left: 0, right: 4),
            child: NodeTileIcon(kind: node.kind),
          ),
        ),
        RtWatcher((context, watch) {
          final info = watch(node.uInfo).value;

          return InstanceTitle(
            type: node.type,
            label: info?.label,
            nKey: node.key,
          );
        }),
      ],
    );
  }
}
