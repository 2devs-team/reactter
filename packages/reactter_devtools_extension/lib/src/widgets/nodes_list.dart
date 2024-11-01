import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:reactter_devtools_extension/src/controllers/nodes_controller.dart';
import 'package:reactter_devtools_extension/src/widgets/node_tile.dart';
import 'package:reactter_devtools_extension/src/widgets/offset_scrollbar.dart';

class NodesList extends StatelessWidget {
  const NodesList({super.key});

  @override
  Widget build(BuildContext context) {
    final listKey = GlobalKey();
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
                      final length = watch(nodesController.nodesList).length;

                      return ListView.custom(
                        key: listKey,
                        controller: scrollControllerY,
                        itemExtent: 24,
                        childrenDelegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final node =
                                nodesController.nodesList.elementAt(index);

                            return NodeTile(
                              key: Key(node.key),
                              node: node,
                              onTap: () => nodesController.selectNode(node),
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
