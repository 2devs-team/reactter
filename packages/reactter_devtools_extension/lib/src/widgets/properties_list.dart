import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:reactter_devtools_extension/src/controllers/nodes_controller.dart';
import 'package:reactter_devtools_extension/src/widgets/property_tile.dart';

class PropertiesList extends StatelessWidget {
  const PropertiesList({super.key});

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    final inst = context.use<NodesController>();

    return SelectableRegion(
      focusNode: focusNode,
      selectionControls: materialTextSelectionControls,
      child: Scrollbar(
        child: SizedBox.expand(
          child: RtWatcher(
            (context, watch) {
              watch(inst.uCurrentNodeKey).value;

              if (inst.currentNode == null) {
                return const SizedBox();
              }

              final properties = watch(inst.currentNode!.propertyNodes);

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0).copyWith(bottom: 4),
                  //   child: Text("Debug info",
                  //       style: Theme.of(context).textTheme.bodyMedium),
                  // ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: properties.length,
                      itemBuilder: (context, index) {
                        final propertyNode = properties.elementAt(index);

                        return PropertyTile(
                          key: ObjectKey(propertyNode),
                          propertyNode: propertyNode,
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
