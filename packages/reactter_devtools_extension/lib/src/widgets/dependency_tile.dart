import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:reactter_devtools_extension/src/bases/node.dart';
import 'package:reactter_devtools_extension/src/nodes/instance/instance_info.dart';
import 'package:reactter_devtools_extension/src/widgets/instance_title.dart';
import 'package:reactter_devtools_extension/src/widgets/tile_builder.dart';

class DependencyTile extends StatelessWidget {
  final Node node;
  final void Function()? onTap;

  const DependencyTile({
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
  final Node node;

  const NodeTileTitle({
    super.key,
    required this.node,
  });

  @override
  Widget build(BuildContext context) {
    return RtWatcher((context, watch) {
      final nodeInfo = watch(node.uInfo).value;

      return InstanceTitle(
        identifyHashCode: node.key,
        nodeKind: nodeInfo?.nodeKind,
        type: nodeInfo?.type,
        label: nodeInfo?.identify,
        isDependency:
            nodeInfo is InstanceInfo ? nodeInfo.dependencyKey != null : false,
      );
    });
  }
}
