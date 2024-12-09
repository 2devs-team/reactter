import 'dart:async';
import 'dart:collection';

import 'package:devtools_app_shared/service.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:reactter_devtools_extension/src/bases/tree_node.dart';
import 'package:reactter_devtools_extension/src/bases/node_info.dart';
import 'package:reactter_devtools_extension/src/utils/helper.dart';

abstract base class Node<I extends NodeInfo> extends TreeNode<Node> {
  final String key;
  final String kind;

  final LinkedHashMap<String, Node> nodeRefs = LinkedHashMap();

  final uInfo = UseState<I?>(null);
  final uIsSelected = UseState(false);
  final isAlive = Disposable();

  Node({
    required this.key,
    required this.kind,
  });

  @override
  void dispose() {
    isAlive.dispose();
    super.dispose();
  }

  Future<List<Node>> getDetails();

  Future<void> loadNode() async {
    await Rt.batch(() async {
      final nodes = await getDetails();
      addNodes(nodeRefs, nodes, addChild);
    });
  }
}
