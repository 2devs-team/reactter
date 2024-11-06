import 'package:devtools_app_shared/service.dart';
import 'package:flutter_reactter/reactter.dart';
import 'package:reactter_devtools_extension/src/data/dependency_info.dart';
import 'package:reactter_devtools_extension/src/interfaces/node.dart';
import 'package:reactter_devtools_extension/src/services/eval_service.dart';
import 'package:vm_service/vm_service.dart';

base class DependencyNode extends INode<DependencyInfo> {
  final uIsLoading = UseState(false);

  DependencyNode._({
    required super.key,
    required super.kind,
    required super.type,
  }) {
    _loadDependencyNode();
  }

  factory DependencyNode({
    required String key,
    required String kind,
    required String type,
  }) {
    return Rt.createState(
      () => DependencyNode._(
        key: key,
        kind: kind,
        type: type,
      ),
    );
  }

  Future<void> _loadDependencyNode() async {
    uIsLoading.value = true;

    final eval = await EvalService.devtoolsEval;
    final isAlive = Disposable();

    final dependencyNode = await eval.evalInstance(
      'RtDevTools._instance?.getDependencyInfo("$key")',
      isAlive: isAlive,
    );

    assert(dependencyNode.kind == InstanceKind.kMap);

    final dependencyNodeAssociations =
        dependencyNode.associations?.cast<MapAssociation>();

    assert(dependencyNodeAssociations != null);

    String? type;
    String? id;

    for (var element in dependencyNodeAssociations!) {
      assert(element.key != null && element.value != null);

      final eKey = element.key!.valueAsString!;
      final eValue = element.value!.valueAsString;

      if (element.value!.kind == InstanceKind.kNull) continue;

      if (eValue == null) continue;

      switch (eKey) {
        case 'type':
          type = eValue;
          break;
        case 'id':
          id = eValue;
          break;
      }
    }

    assert(type != null);

    uInfo.value = DependencyInfo(
      id: id,
    );

    uIsLoading.value = false;
  }

  @override
  Future<void> loadDetails() async {
    // TODO: implement loadDetails
  }
}
