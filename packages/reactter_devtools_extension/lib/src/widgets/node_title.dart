import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:reactter_devtools_extension/src/bases/node.dart';
import 'package:reactter_devtools_extension/src/bases/node_info.dart';
import 'package:reactter_devtools_extension/src/controllers/nodes_controller.dart';
import 'package:reactter_devtools_extension/src/nodes/dart/closure_node.dart';
import 'package:reactter_devtools_extension/src/nodes/dart/iterable_node.dart';
import 'package:reactter_devtools_extension/src/nodes/dart/key_value_node.dart';
import 'package:reactter_devtools_extension/src/nodes/dart/map_node.dart';
import 'package:reactter_devtools_extension/src/nodes/dart/plain_instance_node.dart';
import 'package:reactter_devtools_extension/src/nodes/dart/record_node.dart';
import 'package:reactter_devtools_extension/src/nodes/instance/instance_info.dart';
import 'package:reactter_devtools_extension/src/utils/color_palette.dart';
import 'package:reactter_devtools_extension/src/widgets/instance_title.dart';

class NodeTitle extends StatelessWidget {
  final Node node;

  const NodeTitle({super.key, required this.node});

  @override
  Widget build(BuildContext context) {
    context.watch((_) => [node.uInfo]);

    final nodeInfo = node.uInfo.value;
    final nodeKey = nodeInfo?.identityHashCode;

    if (nodeInfo == null) {
      return Text(
        '...',
        style: Theme.of(context).textTheme.labelSmall,
      );
    }

    Widget getInstanceTitle(NodeInfo? nodeInfo) {
      final nodesController = context.use<NodesController>();
      final nodeOrigin = nodesController.uNodes.value[nodeKey];
      final nodeInfoOrigin = nodeOrigin?.uInfo.value;
      final isDependency = nodeInfoOrigin is InstanceInfo &&
          nodeInfoOrigin.dependencyKey != null;
      final onTapIcon = nodeKey != null && nodeOrigin != null
          ? () => nodesController.selectNodeByKey(nodeKey)
          : null;

      return InstanceTitle(
        identifyHashCode: nodeKey,
        type: nodeInfo?.type,
        nodeKind: nodeInfo?.nodeKind,
        label: nodeInfo?.identify,
        isDependency: isDependency,
        onTapIcon: onTapIcon,
      );
    }

    return switch (node) {
      KeyValueNode(uInfo: final nodeInfo) => Text(
          '${nodeInfo.value?.value}',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: ColorPalette.getColorForNodeValue(context, node),
              ),
        ),
      PlainInstanceNode(uInfo: final nodeInfo) =>
        getInstanceTitle(nodeInfo.value),
      MapNode(uInfo: final nodeInfo) ||
      IterableNode(uInfo: final nodeInfo) ||
      RecordNode(uInfo: final nodeInfo) ||
      ClosureNode(uInfo: final nodeInfo) ||
      Node<NodeInfo>(uInfo: final nodeInfo) =>
        InstanceTitle(
          identifyHashCode: nodeKey,
          type: nodeInfo.value?.type,
          nodeKind: nodeInfo.value?.nodeKind,
          label: nodeInfo.value?.identify,
        ),
    };
  }
}
