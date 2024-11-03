import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:reactter_devtools_extension/src/data/property_node.dart';

class PropertyTile extends StatelessWidget {
  const PropertyTile({
    super.key,
    required this.propertyNode,
  });

  final PropertyNode propertyNode;

  @override
  Widget build(BuildContext context) {
    return RtWatcher((context, watch) {
      return ListTile(
        dense: true,
        visualDensity: const VisualDensity(vertical: 0, horizontal: 2),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        minVerticalPadding: 4,
        minTileHeight: 0,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${watch(propertyNode).key}: ",
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            Flexible(
              child: Text(
                "${watch(propertyNode).value}",
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ],
        ),
        onTap: () {},
      );
    });
  }
}
