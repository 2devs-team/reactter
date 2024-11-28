import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:reactter_devtools_extension/src/controllers/nodes_controller.dart';
import 'package:reactter_devtools_extension/src/widgets/bidirectional_scroll_view.dart';
import 'package:reactter_devtools_extension/src/widgets/dependency_tile.dart';

class DependenciesList extends StatelessWidget {
  const DependenciesList({super.key});

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    final nodesController = context.use<NodesController>();
    final scrollControllerY = nodesController.dependencyListScrollControllerY;
    final listViewKey = nodesController.dependenciesListViewKey;

    return BidirectionalScrollView(
      scrollControllerY: scrollControllerY,
      maxWidth: 500,
      builder: (context, constraints) {
        return SelectableRegion(
          focusNode: focusNode,
          selectionControls: materialTextSelectionControls,
          child: RtWatcher((context, watch) {
            final dependenciesList = watch(nodesController.dependenciesList);
            final length = dependenciesList.length;

            return ListView.custom(
              key: listViewKey,
              controller: scrollControllerY,
              itemExtent: 24,
              childrenDelegate: SliverChildBuilderDelegate(
                (context, index) {
                  final node = dependenciesList.elementAt(index);

                  return DependencyTile(
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
  }
}
