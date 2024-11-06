import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:reactter_devtools_extension/src/data/property_node.dart';
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
      key: key,
      treeNode: propertyNode,
      title: Row(
        children: [
          RtWatcher((context, watch) {
            return SizedBox(
              width: watch(propertyNode.uChildren).value.isEmpty ? 22 : 0,
            );
          }),
          Text(
            "${propertyNode.key}: ",
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          FutureBuilder<String?>(
            future: propertyNode.getValueAsync(),
            builder: (context, snapshot) {
              return RtWatcher((context, watch) {
                final isLoading = watch(propertyNode.uIsLoading).value;
                final value = watch(propertyNode.uValue).value;

                if (isLoading) {
                  return const Loading();
                }

                return Text(
                  value ?? '...',
                  style: Theme.of(context).textTheme.labelSmall,
                );
              });
            },
          ),
        ],
      ),
      isSelected: false,
      onTap: () {},
    );
  }
}
