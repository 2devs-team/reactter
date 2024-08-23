import 'package:examples/examples/3_tree/states/tree_list.dart';
import 'package:examples/examples/3_tree/states/tree_node.dart';
import 'package:flutter_reactter/reactter.dart';

class TreeController {
  final root = TreeNode(null);
  final treeList = Rt.createState(() => TreeList<TreeNode>());

  TreeController() {
    treeList.add(root);
    root.bind(treeList);
  }
}
