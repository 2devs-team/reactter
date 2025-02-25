import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:reactter_devtools_extension/src/controllers/nodes_controller.dart';
import 'package:reactter_devtools_extension/src/widgets/bidirectional_scroll_view.dart';
import 'package:reactter_devtools_extension/src/widgets/node_tile.dart';

class NodesList extends StatelessWidget {
  const NodesList({super.key});

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    final nodesController = context.use<NodesController>();
    final listViewKey = nodesController.nodesListViewKey;
    final scrollControllerY = nodesController.nodesListScrollControllerY;

    return RtWatcher((context, watch) {
      final maxDepth = watch(nodesController.nodesList.uMaxDepth).value;

      return BidirectionalScrollView(
        scrollControllerY: scrollControllerY,
        maxWidth: 400 + (24.0 * maxDepth),
        builder: (context, constraints) {
          return SelectableRegion(
            focusNode: focusNode,
            selectionControls: materialTextSelectionControls,
            child: RtWatcher((context, watch) {
              final nodesList = watch(nodesController.nodesList);
              final length = nodesList.length;

              return ListView.custom(
                key: listViewKey,
                controller: scrollControllerY,
                itemExtent: 24,
                childrenDelegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final node = nodesList.elementAt(index);

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
          );
        },
      );
    });
  }
}
