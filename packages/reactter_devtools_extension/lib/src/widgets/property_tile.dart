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
    return RtWatcher((context, watch) {
      return TreeNodeTileBuilder(
        treeNode: propertyNode,
        title: Row(
          children: [
            if (watch(propertyNode.uChildren).value.isEmpty)
              const SizedBox(width: 22),
            Text(
              "${watch(propertyNode).key}: ",
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            RtWatcher((context, watch) {
              final isLoading = watch(propertyNode.uIsLoading).value;

              if (isLoading || watch(propertyNode).value == null) {
                return const Loading();
              }

              return Text(
                "${watch(propertyNode).value}",
                style: Theme.of(context).textTheme.labelSmall,
              );
            }),
          ],
        ),
        isSelected: false,
        onTap: () {},
      );
    });
  }
}
