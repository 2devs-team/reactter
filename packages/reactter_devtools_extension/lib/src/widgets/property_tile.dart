import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:reactter_devtools_extension/src/controllers/nodes_controller.dart';
import 'package:reactter_devtools_extension/src/constants.dart';
import 'package:reactter_devtools_extension/src/bases/property_node.dart';
import 'package:reactter_devtools_extension/src/nodes/property/property_async_node.dart';
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
            if (propertyNode is PropertyAsyncNode) {
              final propertyAsynNode = propertyNode as PropertyAsyncNode;
              final isLoading = watch(propertyAsynNode.uIsLoading).value;

              if (isLoading) return const Loading();

              watch(propertyAsynNode.uValueFuture).value ??
                  propertyAsynNode.getValueAsync();
            }

            final value = watch(propertyNode.uValue).value;

            final instanceInfo = watch(propertyNode.uInstanceInfo).value;

            if (instanceInfo != null) {
              final nKey = instanceInfo['key'] as String;
              final nodesController = context.use<NodesController>();
              final node = nodesController.uNodes.value[nKey];

              if (node != null) watch(node.uInfo);

              final type = node != null ? node.type : instanceInfo['type'];
              final kind = node != null ? node.kind : instanceInfo['kind'];
              final label = node != null
                  ? node.label
                  : instanceInfo['id'] ??
                      instanceInfo['debugLabel'] ??
                      instanceInfo['name'];
              final dependencyRef = node != null
                  ? node.uInfo.value?.dependencyRef
                  : instanceInfo['dependencyRef'];

              return InstanceTitle(
                nKey: nKey,
                type: type,
                kind:
                    node == null && kind == NodeKind.instance.key ? null : kind,
                label: label,
                isDependency: dependencyRef != null,
                onTapIcon: node != null
                    ? () => nodesController.selectNodeByKey(nKey)
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
