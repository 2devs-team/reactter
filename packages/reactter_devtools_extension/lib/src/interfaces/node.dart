import 'package:devtools_app_shared/service.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:reactter_devtools_extension/src/data/tree_node.dart';
import 'package:reactter_devtools_extension/src/interfaces/node_info.dart';
import 'package:reactter_devtools_extension/src/data/property_node.dart';
import 'package:reactter_devtools_extension/src/data/tree_list.dart';
import 'package:reactter_devtools_extension/src/services/eval_service.dart';
import 'package:vm_service/vm_service.dart';

abstract base class INode<I extends INodeInfo> extends TreeNode<INode> {
  final String key;
  final String kind;
  final String type;

  String? get label;

  final uInfo = UseState<I?>(null);
  final uIsSelected = UseState(false);
  final propertyNodes = TreeList<IPropertyNode>();

  INode({
    required this.key,
    required this.kind,
    required this.type,
  });

  Future<void> loadDetails() async {
    await loadDependencyRef();
  }

  Future<void> loadDependencyRef() async {
    final eval = await EvalService.devtoolsEval;
    final isAlive = Disposable();
    final dependencyKey = uInfo.value?.dependencyRef;

    final dependencyRefValue = await eval.evalInstance(
      'RtDevTools._instance?.getDependencyRef("$dependencyKey")',
      isAlive: isAlive,
    );

    PropertyAsyncNode? propertyNode;

    for (final node in propertyNodes) {
      if (node.key == 'dependencyRef' && node is PropertyAsyncNode) {
        propertyNode = node;
        break;
      }
    }

    if (dependencyRefValue.kind == InstanceKind.kNull) {
      propertyNode?.remove();
      return;
    }

    if (propertyNode == null) {
      propertyNodes.add(
        PropertyAsyncNode(
          key: 'dependencyRef',
          valueRef: dependencyRefValue,
          isExpanded: false,
        ),
      );
    } else {
      propertyNode.updateValueRef(dependencyRefValue);
    }
  }
}
