import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'tree_node.dart';
import 'tree_item.dart';

class TreePage extends StatelessWidget {
  const TreePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactterProvider<TreeNode>(
      () => TreeNode(),
      builder: (treeContext, context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Tree widget"),
          ),
          body: SingleChildScrollView(
            child: TreeItem(item: treeContext),
          ),
        );
      },
    );
  }
}
