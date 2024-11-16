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

class NodeTileTitle extends StatelessWidget {
  final INode node;

  const NodeTileTitle({
    super.key,
    required this.node,
  });

  @override
  Widget build(BuildContext context) {
    return RtWatcher((context, watch) {
      final info = watch(node.uInfo).value;
      final dependencyRef = info?.dependencyRef;

      return InstanceTitle(
        nKey: node.key,
        type: node.type,
        kind: node.kind,
        label: node.label,
        isDependency: dependencyRef != null,
      );
    });
  }
}
