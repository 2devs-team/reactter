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
  }) {
    // _loadStateNode();
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

  Future<dynamic> _loadStateNode() async {
    uIsLoading.value = true;

    final eval = await EvalService.devtoolsEval;
    final isAlive = Disposable();

    final stateNode = await eval.evalInstance(
      'RtDevTools._instance?.getStateInfo("$key")',
      isAlive: isAlive,
    );

    assert(stateNode.kind == InstanceKind.kMap);

    final stateNodeAssociations =
        stateNode.associations?.cast<MapAssociation>();

    assert(stateNodeAssociations != null);

    String? label;

    for (var element in stateNodeAssociations!) {
      assert(element.key != null && element.value != null);

      final eKey = element.key!.valueAsString!;
      final eValue = element.value!.valueAsString!;

      if (element.value!.kind == InstanceKind.kNull) continue;

      switch (eKey) {
        case 'label':
          label = eValue;
          break;
      }
    }

    uInfo.value = StateInfo(
      label: label,
    );

    uIsLoading.value = false;
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

    final propertiesInst = await eval.evalInstance(
      'RtDevTools._instance?.getDebugInfo("$key")',
      isAlive: isAlive,
    );

    if (propertiesInst.kind == InstanceKind.kNull) {
      return;
    }

    assert(propertiesInst.kind == InstanceKind.kMap);

    final associations = propertiesInst.associations?.cast<MapAssociation>();

    assert(associations != null);

    final properties = <PropertyNode>[];

    for (final association in associations!) {
      final key = association.key!.valueAsString!;
      final valueRef = association.value;

      properties.add(
        PropertyNode(
          key: key,
          valueRef: valueRef,
        ),
      );
    }

    propertyNodes.clear();
    propertyNodes.addAll(properties);
  }
}
