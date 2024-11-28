import 'package:flutter_reactter/reactter.dart';
import 'package:reactter_devtools_extension/src/bases/node.dart';
import 'package:reactter_devtools_extension/src/bases/tree_list.dart';

class NodeDetailsController {
  final uCurrentNode = UseState<Node?>(null);
  final detailNodeList = TreeList<Node>();

  Future<void> loadDetails(Node node) async {
    await Rt.batch(() async {
      uCurrentNode.value = node;

      final detailNodes = await node.getDetails();

      detailNodeList.clear();
      detailNodeList.addAll(detailNodes);

      for (var detailNode in detailNodeList) {
        detailNode.uIsExpanded.value = true;
      }
    });
  }

  void reloadDetails() async {
    final node = uCurrentNode.value;

    if (node == null) return;

    await loadDetails(node);
  }

  void resetState() {
    uCurrentNode.value = null;
    detailNodeList.clear();
  }
}
