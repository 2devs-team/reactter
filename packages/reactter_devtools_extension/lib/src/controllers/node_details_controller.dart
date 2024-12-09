import 'dart:async';
import 'dart:collection';

import 'package:flutter_reactter/reactter.dart';
import 'package:reactter_devtools_extension/src/bases/node.dart';
import 'package:reactter_devtools_extension/src/bases/tree_list.dart';
import 'package:reactter_devtools_extension/src/utils/helper.dart';

class NodeDetailsController {
  bool _isMarked = false;
  FutureOr<void>? _futureLoadDetails;
  final LinkedHashMap<String, Node> _nodeRefs = LinkedHashMap();

  final uCurrentNode = UseState<Node?>(null);
  final detailNodeList = TreeList<Node>();

  Future<void> loadDetails(Node node) async {
    if (_isMarked) return;

    if (_futureLoadDetails != null) {
      _isMarked = true;
      await _futureLoadDetails;
    }

    await (_futureLoadDetails = Rt.batch(() async {
      if (uCurrentNode.value != node) {
        _nodeRefs.clear();
        detailNodeList.clear();
      }

      uCurrentNode.value = node;

      final nodes = await node.getDetails();

      addNodes(_nodeRefs, nodes, (node) {
        node.uIsExpanded.value = true;
        detailNodeList.add(node);
      });
    }));

    _futureLoadDetails = null;
    _isMarked = false;
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
