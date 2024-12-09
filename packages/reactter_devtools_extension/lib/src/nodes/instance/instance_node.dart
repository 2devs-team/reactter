import 'package:flutter_reactter/reactter.dart';
import 'package:reactter_devtools_extension/src/bases/node.dart';
import 'package:reactter_devtools_extension/src/bases/node_info.dart';
import 'package:reactter_devtools_extension/src/nodes/instance/instance_info.dart';
import 'package:reactter_devtools_extension/src/services/eval_service.dart';
import 'package:reactter_devtools_extension/src/utils/extensions.dart';
import 'package:vm_service/vm_service.dart';

base class InstanceNode<I extends InstanceInfo> extends Node<I> {
  InstanceNode.$({required super.key})
      : super(kind: InstanceKind.kPlainInstance);

  factory InstanceNode({required String key}) {
    return Rt.createState(
      () => InstanceNode.$(key: key),
    );
  }

  Future<Node?> getDependency() async {
    try {
      final eval = await EvalService.devtoolsEval;
      final dependencyKey = uInfo.value?.dependencyKey;
      final dependencyRef = await EvalService.evalsQueue.add(
        () => eval.safeEval(
          'RtDevTools._instance?.getDependencyRef("$dependencyKey")',
          isAlive: isAlive,
        ),
      );
      return dependencyRef.getNode('dependency');
    } catch (e) {
      print(e);
    }

    return null;
  }

  @override
  Future<List<Node<NodeInfo>>> getDetails() async => [
        await getDependency(),
      ].whereType<Node>().toList();

  @override
  void markToLoadNode(covariant Function? onUpdate) {
    onUpdate?.call();
  }
}
