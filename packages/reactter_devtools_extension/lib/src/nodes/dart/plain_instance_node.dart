import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:reactter_devtools_extension/src/bases/async_node.dart';
import 'package:reactter_devtools_extension/src/bases/node.dart';
import 'package:reactter_devtools_extension/src/bases/node_info.dart';
import 'package:reactter_devtools_extension/src/constants.dart';
import 'package:reactter_devtools_extension/src/nodes/dependency/dependency_info.dart';
import 'package:reactter_devtools_extension/src/nodes/instance/instance_info.dart';
import 'package:reactter_devtools_extension/src/nodes/state/state_info.dart';
import 'package:reactter_devtools_extension/src/services/eval_service.dart';
import 'package:reactter_devtools_extension/src/utils/extensions.dart';
import 'package:vm_service/vm_service.dart';

base class PlainInstanceNode extends AsyncNode {
  PlainInstanceNode._({
    required super.key,
    required super.instanceRef,
  });

  factory PlainInstanceNode({
    required String key,
    required InstanceRef instanceRef,
  }) {
    return Rt.createState(
      () => PlainInstanceNode._(
        key: key,
        instanceRef: instanceRef,
      ),
    );
  }

  @override
  Future<NodeInfo?> getNodeInfo() async {
    final eval = await EvalService.devtoolsEval;
    final instanceInfo = await EvalService.evalsQueue.add(
      () => eval.evalInstance(
        'RtDevTools.instance?.getPlainInstanceInfo(instance)',
        isAlive: isAlive,
        scope: {'instance': instanceRef.id!},
      ),
    );

    if (instanceInfo.kind != InstanceKind.kMap) return null;

    final instanceInfoMap = await instanceInfo.evalValue(isAlive, 2);

    if (instanceInfoMap is! Map) return null;

    final String kind = instanceInfoMap['kind'];
    final String key = instanceInfoMap['key'];
    final String type = instanceInfoMap['type'];
    final String? id = instanceInfoMap['id'];
    final String? debugLabel = instanceInfoMap['debugLabel'];
    final String? value = instanceInfoMap['value'];
    final String? identify = id ?? debugLabel ?? value;
    final String formattedValue =
        identify != null ? "$type($identify) #$key" : "$type #$key";
    final nodeKind = NodeKind.getKind(kind)!;

    switch (nodeKind) {
      case NodeKind.dependency:
        final mode = instanceInfoMap['mode'];

        return DependencyInfo(
          this,
          type: type,
          identify: id,
          mode: mode,
          value: formattedValue,
        );
      case NodeKind.instance:
        final dependencyKey = instanceInfoMap['dependencyKey'];

        return InstanceInfo(
          this,
          type: type,
          identityHashCode: key,
          identify: value,
          dependencyKey: dependencyKey,
          value: formattedValue,
        );
      case NodeKind.state:
      case NodeKind.hook:
      case NodeKind.signal:
        return StateInfo(
          this,
          nodeKind: NodeKind.getKind(kind)!,
          type: type,
          identify: debugLabel,
          identityHashCode: key,
          value: formattedValue,
          debugLabel: debugLabel,
        );
      default:
        return NodeInfo(
          this,
          nodeKind: NodeKind.getKind(kind),
          type: type,
          identify: value,
          identityHashCode: key,
          value: formattedValue,
        );
    }
  }

  @override
  Future<List<Node>> getDetails() async {
    final instance = await instanceRef.safeGetInstance(isAlive);
    final fields = instance?.fields?.cast<BoundField>() ?? [];
    final nodes = fields.map((field) {
      if (field.value is! InstanceRef) return null;

      if (field.name.startsWith('_') || field.name.startsWith('\$')) {
        return null;
      }

      return (field.value as InstanceRef).getNode(field.name);
    }).toList();

    return nodes.whereType<Node>().toList();
  }
}
