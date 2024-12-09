import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:reactter_devtools_extension/src/bases/async_node.dart';
import 'package:reactter_devtools_extension/src/bases/node.dart';
import 'package:reactter_devtools_extension/src/bases/node_info.dart';
import 'package:reactter_devtools_extension/src/constants.dart';
import 'package:reactter_devtools_extension/src/utils/extensions.dart';
import 'package:vm_service/vm_service.dart';

final class IterableNode extends AsyncNode {
  Future<List<Node>>? futureElementNodes;

  IterableNode.$({
    required super.key,
    required super.instanceRef,
  });

  factory IterableNode({
    required String key,
    required InstanceRef instanceRef,
  }) {
    return Rt.createState(
      () => IterableNode.$(
        key: key,
        instanceRef: instanceRef,
      ),
    );
  }

  Future<List<Node>> getElementNodes() async {
    final instance = await instanceRef.safeGetInstance(isAlive);
    final elements = instance?.elements?.cast<InstanceRef>() ?? [];
    final elementNodes = <Node>[];

    for (var i = 0; i < elements.length; i++) {
      final element = elements[i];
      final node = element.getNode(i.toString());
      elementNodes.add(node);
    }

    return elementNodes;
  }

  @override
  Future<void> loadNode() async {
    await super.loadNode();
    futureElementNodes = null;
  }

  @override
  Future<NodeInfo?> getNodeInfo() async {
    final nodes = await (futureElementNodes ??= getElementNodes());
    final value = switch (kind) {
      InstanceKind.kList => "List(length: ${nodes.length})",
      InstanceKind.kSet => "Set(length: ${nodes.length})",
      InstanceKind.kMap => "Map(length: ${nodes.length})",
      _ => "Iterable(length: ${nodes.length})",
    };

    return NodeInfo(
      this,
      nodeKind: NodeKind.getKind(kind),
      type: kind,
      identify: "length: ${nodes.length}",
      value: value,
    );
  }

  @override
  Future<List<Node>> getDetails() async {
    return await (futureElementNodes ??= getElementNodes());
  }
}
