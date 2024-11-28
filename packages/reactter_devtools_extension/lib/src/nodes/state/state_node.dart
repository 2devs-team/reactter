import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:reactter_devtools_extension/src/bases/node.dart';
import 'package:reactter_devtools_extension/src/nodes/instance/instance_node.dart';
import 'package:reactter_devtools_extension/src/nodes/state/state_info.dart';
import 'package:reactter_devtools_extension/src/services/eval_service.dart';
import 'package:reactter_devtools_extension/src/utils/extensions.dart';

final class StateNode extends InstanceNode<StateInfo> {
  final uIsLoading = UseState(false);

  StateNode.$({required super.key}) : super.$();

  factory StateNode({required String key}) {
    return Rt.createState(
      () => StateNode.$(key: key),
    );
  }

  @override
  Future<List<Node>> getDetails() async {
    final instanceRefs = await Future.wait([
      getDependency(),
      getBoundInstance(),
      getDebugInfo(),
    ]);

    return instanceRefs.whereType<Node>().toList();
  }

  Future<Node?> getBoundInstance() async {
    try {
      final eval = await EvalService.devtoolsEval;
      final boundInstanceRef = await eval.evalInstance(
        'RtDevTools._instance?.getBoundInstance("$key")',
        isAlive: isAlive,
      );
      return boundInstanceRef.getNode('boundInstance');
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<Node?> getDebugInfo() async {
    try {
      final eval = await EvalService.devtoolsEval;
      final debugInfoRef = await eval.evalInstance(
        'RtDevTools._instance?.getDebugInfo("$key")',
        isAlive: isAlive,
      );
      return debugInfoRef.getNode('debugInfo');
    } catch (e) {
      print(e);
    }
    return null;
  }
}
