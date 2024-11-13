import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:reactter_devtools_extension/src/data/tree_node.dart';
import 'package:reactter_devtools_extension/src/interfaces/node_info.dart';
import 'package:reactter_devtools_extension/src/data/property_node.dart';
import 'package:reactter_devtools_extension/src/data/tree_list.dart';

abstract base class INode<I extends INodeInfo> extends TreeNode<INode> {
  final String key;
  final String kind;
  final String type;

  String? get label;

  final uInfo = UseState<I?>(null);
  final uIsSelected = UseState(false);
  final propertyNodes = TreeList<PropertyNode>();

  INode({
    required this.key,
    required this.kind,
    required this.type,
  });

  Future<void> loadDetails();
}
