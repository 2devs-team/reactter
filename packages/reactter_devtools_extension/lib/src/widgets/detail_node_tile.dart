import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:reactter_devtools_extension/src/bases/async_node.dart';
import 'package:reactter_devtools_extension/src/bases/node.dart';
import 'package:reactter_devtools_extension/src/controllers/nodes_controller.dart';
import 'package:reactter_devtools_extension/src/nodes/instance/instance_info.dart';
import 'package:reactter_devtools_extension/src/widgets/instance_title.dart';
import 'package:reactter_devtools_extension/src/widgets/loading.dart';
import 'package:reactter_devtools_extension/src/widgets/tile_builder.dart';

class DetailNodeTile extends StatelessWidget {
  const DetailNodeTile({
    super.key,
    required this.node,
  });

  final Node node;

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
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          RtWatcher((context, watch) {
            if (node is AsyncNode) {
              final asyncNode = node as AsyncNode;
              final isLoading = watch(asyncNode.uIsLoading).value;

              if (isLoading) return const Loading();

              if (watch(asyncNode.uInfo).value == null) {
                asyncNode.loadNode();
              }
            }

            final nodeInfo = watch(node.uInfo).value;
            final value = nodeInfo?.value;
            final dependencyKey =
                nodeInfo is InstanceInfo ? nodeInfo.dependencyKey : null;

            if (nodeInfo != null) {
              final nodesController = context.use<NodesController>();
              final nodeKey = nodeInfo.identityHashCode ?? node.key;
              final nodeOrigin = nodesController.uNodes.value[nodeKey];

              return InstanceTitle(
                nodeKey: nodeKey,
                type: nodeInfo.type,
                nodeKind: nodeInfo.nodeKind,
                label: nodeInfo.identify,
                isDependency: dependencyKey != null,
                onTapIcon: nodeOrigin != null
                    ? () => nodesController.selectNodeByKey(nodeKey)
                    : null,
              );
            }

            return Text(
              value ?? '...',
              style: Theme.of(context).textTheme.labelSmall,
            );
          }),
        ],
      ),
      isSelected: false,
      onTap: () {},
    );
  }
}
