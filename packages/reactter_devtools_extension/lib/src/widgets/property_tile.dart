import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:reactter_devtools_extension/src/controllers/nodes_controller.dart';
import 'package:reactter_devtools_extension/src/data/property_node.dart';
import 'package:reactter_devtools_extension/src/widgets/instance_title.dart';
import 'package:reactter_devtools_extension/src/widgets/loading.dart';
import 'package:reactter_devtools_extension/src/widgets/tile_builder.dart';

class PropertyTile extends StatelessWidget {
  const PropertyTile({
    super.key,
    required this.propertyNode,
  });

  final PropertyNode propertyNode;

  @override
  Widget build(BuildContext context) {
    return TreeNodeTileBuilder(
      treeNode: propertyNode,
      title: Row(
        children: [
          Text(
            "${propertyNode.key}: ",
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          RtWatcher((context, watch) {
            final isLoading = watch(propertyNode.uIsLoading).value;

            if (isLoading) return const Loading();

            watch(propertyNode.uValueFuture).value ??
                propertyNode.getValueAsync();

            final value = watch(propertyNode.uValue).value;

            final instanceInfo = watch(propertyNode.uInstanceInfo).value;

            if (instanceInfo != null) {
              final nKey = instanceInfo['key'] as String;
              final nodesController = context.use<NodesController>();
              final node = nodesController.uNodes.value[nKey];

              return Row(
                children: [
                  if (node != null)
                    InkWell(
                      child: const Icon(Icons.reply),
                      onTap: () {
                        nodesController.selectNodeByKey(nKey);
                      },
                    ),
                  InstanceTitle(
                    type: instanceInfo['type'],
                    label: instanceInfo['id'] ?? instanceInfo['debugLabel'],
                    nKey: nKey,
                  ),
                ],
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
