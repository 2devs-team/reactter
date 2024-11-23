import 'package:flutter_reactter/reactter.dart';
import 'package:reactter_devtools_extension/src/bases/tree_node.dart';

abstract base class PropertyNode extends TreeNode<PropertyNode> {
  final String key;
  final uValue = UseState<String?>(null);
  final uInstanceInfo = UseState<Map<String, dynamic>?>(null);

  PropertyNode({required this.key, String? value, bool isExpanded = false}) {
    uValue.value = value;
    uIsExpanded.value = isExpanded;
  }
}
