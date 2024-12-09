import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:reactter_devtools_extension/src/controllers/node_details_controller.dart';
import 'package:reactter_devtools_extension/src/widgets/bidirectional_scroll_view.dart';
import 'package:reactter_devtools_extension/src/widgets/detail_node_tile.dart';

class DetailNodeList extends StatelessWidget {
  const DetailNodeList({super.key});

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    final scrollControllerY = ScrollController();
    final nodeDetailsController = context.use<NodeDetailsController>();

    return RtWatcher((context, watch) {
      final maxDepth =
          watch(nodeDetailsController.detailNodeList.uMaxDepth).value;

      return BidirectionalScrollView(
        scrollControllerY: scrollControllerY,
        maxWidth: 600 + (24.0 * maxDepth),
        builder: (context, constraints) {
          return SelectableRegion(
            focusNode: focusNode,
            selectionControls: materialTextSelectionControls,
            child: RtWatcher((context, watch) {
              final detailNodeList =
                  watch(nodeDetailsController.detailNodeList);

              final length = detailNodeList.length;

              return ListView.custom(
                key: ObjectKey(detailNodeList),
                controller: scrollControllerY,
                itemExtent: 24,
                childrenDelegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final detailNode = detailNodeList.elementAt(index);

                    return DetailNodeTile(
                      key: ObjectKey(detailNode),
                      node: detailNode,
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
