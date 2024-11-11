import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:reactter_devtools_extension/src/controllers/nodes_controller.dart';
import 'package:reactter_devtools_extension/src/widgets/offset_scrollbar.dart';
import 'package:reactter_devtools_extension/src/widgets/property_tile.dart';

class PropertiesList extends StatelessWidget {
  const PropertiesList({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollControllerX = ScrollController();
    final scrollControllerY = ScrollController();
    final focusNode = FocusNode();
    final nodesController = context.use<NodesController>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportWidth = constraints.maxWidth;

        return Scrollbar(
          controller: scrollControllerX,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: scrollControllerX,
            scrollDirection: Axis.horizontal,
            child: Material(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000.00),
                child: OffsetScrollbar(
                  isAlwaysShown: true,
                  axis: Axis.vertical,
                  controller: scrollControllerY,
                  offsetController: scrollControllerX,
                  offsetControllerViewportDimension: viewportWidth,
                  child: SelectableRegion(
                    focusNode: focusNode,
                    selectionControls: materialTextSelectionControls,
                    child: RtWatcher((context, watch) {
                      watch(nodesController.uCurrentNodeKey);

                      final propertyNodes = nodesController.currentNode != null
                          ? watch(nodesController.currentNode!.propertyNodes)
                          : null;

                      final length = propertyNodes?.length ?? 0;

                      return ListView.custom(
                        key: ObjectKey(propertyNodes),
                        controller: scrollControllerY,
                        itemExtent: 24,
                        childrenDelegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final propertyNode =
                                propertyNodes!.elementAt(index);

                            return PropertyTile(
                              propertyNode: propertyNode,
                            );
                          },
                          childCount: length,
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
