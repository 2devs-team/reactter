import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:reactter_devtools_extension/src/bases/async_node.dart';
import 'package:reactter_devtools_extension/src/bases/node.dart';
import 'package:reactter_devtools_extension/src/bases/node_info.dart';
import 'package:reactter_devtools_extension/src/constants.dart';
import 'package:reactter_devtools_extension/src/nodes/dart/key_value_node.dart';
import 'package:reactter_devtools_extension/src/utils/extensions.dart';
import 'package:vm_service/vm_service.dart';

final class ClosureNode extends AsyncNode {
  Future<FuncRef?>? futureFuncRef;

  ClosureNode.$({
    required super.key,
    required super.instanceRef,
  });

  factory ClosureNode({required String key, required InstanceRef instanceRef}) {
    return Rt.registerState(
      () => ClosureNode.$(
        key: key,
        instanceRef: instanceRef,
      ),
    );
  }

  Future<FuncRef?> getFuncRef() async {
    final instance = await instanceRef.safeGetInstance(isAlive);
    return instance?.closureFunction;
  }

  @override
  Future<void> loadNode() async {
    await super.loadNode();
    futureFuncRef = null;
  }

  @override
  Future<List<Node>> getDetails() async {
    final funcRef = await (futureFuncRef ??= getFuncRef());

    final name = funcRef?.name;
    final location = funcRef?.location?.script?.uri;
    final locationLine = funcRef?.location?.line;
    final locationColumn = funcRef?.location?.column;

    return [
      if (name != null)
        KeyValueNode(
          key: 'name',
          value: '"$name"',
          kind: InstanceKind.kString,
        ),
      if (location != null)
        KeyValueNode(
          key: 'location',
          value: '"$location"',
          kind: InstanceKind.kString,
        ),
      if (locationLine != null)
        KeyValueNode(
          key: 'locationLine',
          value: "$locationLine",
          kind: InstanceKind.kInt,
        ),
      if (locationColumn != null)
        KeyValueNode(
          key: 'locationColumn',
          value: '$locationColumn',
          kind: InstanceKind.kInt,
        ),
    ];
  }

  @override
  Future<NodeInfo?> getNodeInfo() async {
    final funcRef = await (futureFuncRef ??= getFuncRef());

    final name = funcRef?.name;
    final location = funcRef?.location?.script?.uri;
    final locationLine = funcRef?.location?.line;
    final locationColumn = funcRef?.location?.column;
    final locationStr = "$location ${[
      locationLine,
      locationColumn
    ].where((e) => e != null).join(':')}";

    final value = name != null
        ? "Function($name) $locationStr"
        : "Unknown - Cannot load value";

    return NodeInfo(
      this,
      nodeKind: NodeKind.getKind(kind),
      type: 'Function',
      identify: name,
      identityHashCode: locationStr,
      value: value,
    );
  }
}
