import 'dart:collection';

import 'package:reactter_devtools_extension/src/bases/async_node.dart';
import 'package:reactter_devtools_extension/src/bases/node.dart';
import 'package:reactter_devtools_extension/src/nodes/dart/key_value_node.dart';

void addNodes(
  LinkedHashMap<String, Node> nodeRefs,
  List<Node> nodes,
  void Function(Node node) onAdd,
) {
  final nodeToRemove = nodeRefs.keys.toSet();

  for (final node in nodes) {
    final nodeRef = nodeRefs[node.key];
    final isEqual = node.kind == nodeRef?.kind;

    if (isEqual) {
      if (nodeRef is AsyncNode) {
        nodeRef.updateInstanceRef((node as AsyncNode).instanceRef);
      } else if (nodeRef is KeyValueNode) {
        nodeRef.value = (node as KeyValueNode).value;
      }
    } else {
      if (nodeRef != null) {
        nodeRef.replaceFor(node);
      } else {
        onAdd(node);
      }

      nodeRefs.putIfAbsent(node.key, () => node);
    }

    nodeToRemove.remove(node.key);
  }

  for (final key in nodeToRemove) {
    final node = nodeRefs.remove(key);
    node?.remove();
  }
}
