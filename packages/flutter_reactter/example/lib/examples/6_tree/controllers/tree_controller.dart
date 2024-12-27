import 'package:examples/examples/6_tree/states/tree_list.dart';
import 'package:examples/examples/6_tree/states/tree_node.dart';

class TreeController {
  final root = TreeNode();
  final treeList = TreeList();

  TreeController() {
    treeList.add(root);
  }
}
