import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'package:examples/examples/3_tree/tree_node.dart';
import 'package:examples/examples/3_tree/widgets/tree_item.dart';

class TreePage extends StatelessWidget {
  const TreePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactterProvider(
      TreeNode.new,
      builder: (context, treeContext, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Tree widget"),
          ),
          body: SingleChildScrollView(
            child: TreeItem(treeNode: treeContext),
          ),
        );
      },
    );
  }
}
