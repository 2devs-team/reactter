import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:reactter_devtools_extension/src/bases/async_node.dart';
import 'package:reactter_devtools_extension/src/bases/node.dart';
import 'package:reactter_devtools_extension/src/bases/node_info.dart';
import 'package:reactter_devtools_extension/src/constants.dart';
import 'package:reactter_devtools_extension/src/utils/extensions.dart';
import 'package:vm_service/vm_service.dart';

final class RecordNode extends AsyncNode {
  Future<List<Node>>? futureFieldNodes;

  RecordNode.$({
    required super.key,
    required super.instanceRef,
  });

  factory RecordNode({required String key, required InstanceRef instanceRef}) {
    return Rt.createState(
      () => RecordNode.$(
        key: key,
        instanceRef: instanceRef,
      ),
    );
  }

  Future<List<Node>> getFieldNodes() async {
    final instance = await instanceRef.safeGetInstance(isAlive);
    final fields = instance?.fields?.cast<BoundField>() ?? [];
    final fieldNodes = <Node>[];

    for (final field in fields) {
      final node = (field.value as InstanceRef).getNode("${field.name}");
      fieldNodes.add(node);
    }

    return fieldNodes;
  }

  @override
  Future<void> loadNode() async {
    await super.loadNode();
    futureFieldNodes = null;
  }

  @override
  Future<List<Node>> getDetails() async {
    return await (futureFieldNodes ??= getFieldNodes());
  }

  @override
  Future<NodeInfo?> getNodeInfo() async {
    if (uNeedToLoadNode.value) return null;

    final nodes = await (futureFieldNodes ??= getFieldNodes());
    final value = "Record(length: ${nodes.length})";

    return NodeInfo(
      this,
      nodeKind: NodeKind.getKind(kind),
      type: kind,
      identify: "length: ${nodes.length}",
      value: value,
    );
  }
}
