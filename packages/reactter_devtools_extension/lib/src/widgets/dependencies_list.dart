import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:reactter_devtools_extension/src/controllers/nodes_controller.dart';
import 'package:reactter_devtools_extension/src/widgets/dependency_tile.dart';
import 'package:reactter_devtools_extension/src/widgets/offset_scrollbar.dart';

class DependenciesList extends StatelessWidget {
  const DependenciesList({super.key});

  @override
  Widget build(BuildContext context) {
    final nodesController = context.use<NodesController>();
    final listViewKey = nodesController.dependenciesListViewKey;
    final scrollControllerX = ScrollController();
    final scrollControllerY = nodesController.dependencyListScrollControllerY;
    final focusNode = FocusNode();

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
              child: RtWatcher((context, watch) {
                const minWith = 500.0;

                return ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: viewportWidth > minWith ? viewportWidth : minWith,
                  ),
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
                        final dependenciesList =
                            watch(nodesController.dependenciesList);
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
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
