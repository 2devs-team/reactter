import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:reactter_devtools_extension/src/bases/async_node.dart';
import 'package:reactter_devtools_extension/src/bases/node.dart';
import 'package:reactter_devtools_extension/src/bases/node_info.dart';
import 'package:reactter_devtools_extension/src/constants.dart';
import 'package:reactter_devtools_extension/src/utils/extensions.dart';
import 'package:vm_service/vm_service.dart';

final class MapNode extends AsyncNode {
  Future<List<Node>>? futureEntryNodes;

  MapNode.$({
    required super.key,
    required super.instanceRef,
  });

  factory MapNode({required String key, required InstanceRef instanceRef}) {
    return Rt.createState(
      () => MapNode.$(key: key, instanceRef: instanceRef),
    );
  }

  Future<List<Node>> getEntryNodes() async {
    final instance = await instanceRef.safeGetInstance(isAlive);
    final associations = instance?.associations?.cast<MapAssociation>() ?? [];
    final entryNodes = <Node>[];

    for (final entry in associations) {
      final keyRef = entry.key as InstanceRef;
      final keyStr = await keyRef.safeValue(isAlive);
      final valueRef = entry.value as InstanceRef;

      entryNodes.add(valueRef.getNode(keyStr));
    }

    return entryNodes;
  }

  @override
  Future<void> loadNode() async {
    await super.loadNode();
    futureEntryNodes = null;
  }

  @override
  Future<NodeInfo?> getNodeInfo() async {
    final nodes = await (futureEntryNodes ??= getEntryNodes());
    final value = "Map(length: ${nodes.length})";

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
    return await (futureEntryNodes ??= getEntryNodes());
  }
}
