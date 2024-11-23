import 'package:devtools_app_shared/service.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:reactter_devtools_extension/src/bases/tree_node.dart';
import 'package:reactter_devtools_extension/src/bases/node_info.dart';
import 'package:reactter_devtools_extension/src/bases/property_node.dart';
import 'package:reactter_devtools_extension/src/bases/tree_list.dart';
import 'package:reactter_devtools_extension/src/nodes/property/property_async_node.dart';
import 'package:reactter_devtools_extension/src/services/eval_service.dart';
import 'package:vm_service/vm_service.dart';

abstract base class Node<I extends NodeInfo> extends TreeNode<Node> {
  final String key;
  final String kind;
  final String type;

  String? get label;

  final uInfo = UseState<I?>(null);
  final uIsSelected = UseState(false);
  final propertyNodes = TreeList<PropertyNode>();
  final isAlive = Disposable();

  Node({
    required this.key,
    required this.kind,
    required this.type,
  });

  @override
  void dispose() {
    isAlive.dispose();
    super.dispose();
  }

  Future<void> loadDetails() async {
    await loadDependencyRef();
  }

  Future<void> loadDependencyRef() async {
    try {
      final eval = await EvalService.devtoolsEval;
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
    } catch (e) {
      print(e);
    }
  }
}
