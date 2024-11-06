import 'package:devtools_app_shared/service.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:reactter_devtools_extension/src/interfaces/node.dart';
import 'package:reactter_devtools_extension/src/data/property_node.dart';
import 'package:reactter_devtools_extension/src/data/state_info.dart';
import 'package:reactter_devtools_extension/src/services/eval_service.dart';

import 'package:vm_service/vm_service.dart';

base class StateNode extends INode<StateInfo> {
  final uIsLoading = UseState(false);

  StateNode._({
    required super.key,
    required super.kind,
    required super.type,
  });

  factory StateNode({
    required String key,
    required String kind,
    required String type,
  }) {
    return Rt.createState(
      () => StateNode._(
        key: key,
        kind: kind,
        type: type,
      ),
    );
  }

  @override
  Future<void> loadDetails() async {
    await Future.wait([loadBoundInstance(), loadProperties()]);
  }

  Future<void> loadBoundInstance() async {
    // final eval = await EvalService.devtoolsEval;
    // final isAlive = Disposable();
    // final valueInst = await eval.safeGetInstance(ref, isAlive);

    // final inst = await eval.evalInstance(
    //   'state.boundInstance',
    //   isAlive: isAlive,
    //   scope: {'state': ref.id!},
    // );
  }

  Future<void> loadProperties() async {
    final eval = await EvalService.devtoolsEval;
    final isAlive = Disposable();

    final debugInfoValue = await eval.evalInstance(
      'RtDevTools._instance?.getDebugInfo("$key")',
      isAlive: isAlive,
    );

    PropertyNode? propertyNode;

    for (final node in propertyNodes) {
      if (node.key == 'debugInfo') {
        propertyNode = node;
        break;
      }
    }

    if (propertyNode == null) {
      propertyNodes.add(
        PropertyNode(
          key: 'debugInfo',
          valueRef: debugInfoValue,
          isExpanded: true,
        ),
      );
    } else {
      propertyNode.reassignValueRef(debugInfoValue);
    }
  }
}
