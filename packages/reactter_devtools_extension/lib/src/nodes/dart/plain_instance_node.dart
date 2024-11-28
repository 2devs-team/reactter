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

base class PlainInstanceNode extends AsyncNode<NodeInfo> {
  PlainInstanceNode._({required super.key, required super.instanceRef})
      : super(kind: InstanceKind.kPlainInstance);

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
        'RtDevTools._instance?.getPlainInstanceInfo(instance)',
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
    final String? identify = id ?? debugLabel;
    final String value =
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
        );
      case NodeKind.instance:
        final dependencyKey = instanceInfoMap['dependencyKey'];

        return InstanceInfo(
          this,
          type: type,
          identityHashCode: key,
          dependencyKey: dependencyKey,
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
          value: value,
          debugLabel: debugLabel,
        );
      default:
        return NodeInfo(
          this,
          nodeKind: NodeKind.getKind(kind),
          type: type,
          identityHashCode: key,
          value: value,
        );
    }
  }

  @override
  Future<List<Node<NodeInfo>>> getDetails() async {
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
