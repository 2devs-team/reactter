import 'package:devtools_app_shared/service.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:reactter_devtools_extension/src/interfaces/node.dart';
import 'package:reactter_devtools_extension/src/data/property_node.dart';
import 'package:reactter_devtools_extension/src/data/state_info.dart';
import 'package:reactter_devtools_extension/src/services/eval_service.dart';

base class StateNode extends INode<StateInfo> {
  final uIsLoading = UseState(false);

  @override
  String? get label => uInfo.value?.debugLabel;

  StateNode._({
    required super.key,
    required super.kind,
    required super.type,
  }) {
    UseEffect(loadDependencyRef, [uInfo]);
  }

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
    await Future.wait([
      super.loadDetails(),
      loadBoundInstance(),
      loadDebugInfo(),
    ]);
  }

  Future<void> loadBoundInstance() async {
    final eval = await EvalService.devtoolsEval;
    final isAlive = Disposable();

    final boundInstanceValue = await eval.evalInstance(
      'RtDevTools._instance?.getBoundInstance("$key")',
      isAlive: isAlive,
    );

    PropertyAsyncNode? propertyNode;

    for (final node in propertyNodes) {
      if (node.key == 'boundInstance' && node is PropertyAsyncNode) {
        propertyNode = node;
        break;
      }
    }

    if (propertyNode == null) {
      propertyNodes.add(
        PropertyAsyncNode(
          key: 'boundInstance',
          valueRef: boundInstanceValue,
          isExpanded: false,
        ),
      );
    } else {
      propertyNode.updateValueRef(boundInstanceValue);
    }
  }

  Future<void> loadDebugInfo() async {
    final eval = await EvalService.devtoolsEval;
    final isAlive = Disposable();

    final debugInfoValue = await eval.evalInstance(
      'RtDevTools._instance?.getDebugInfo("$key")',
      isAlive: isAlive,
    );

    PropertyAsyncNode? propertyNode;

    for (final node in propertyNodes) {
      if (node.key == 'debugInfo' && node is PropertyAsyncNode) {
        propertyNode = node;
        break;
      }
    }

    if (propertyNode == null) {
      propertyNodes.add(
        PropertyAsyncNode(
          key: 'debugInfo',
          valueRef: debugInfoValue,
          isExpanded: true,
        ),
      );
    } else {
      propertyNode.updateValueRef(debugInfoValue);
    }
  }
}
