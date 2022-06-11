import 'package:flutter/material.dart';

import 'package:example/examples/tree/tree_item.dart';
import 'package:example/examples/tree/tree_context.dart';
import 'package:reactter/reactter.dart';

class TreeExample extends StatelessWidget {
  const TreeExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactterProvider(
        contexts: [
          UseContext(() => TreeContext()),
        ],
        builder: (context, _) {
          final treeContext = context.read<TreeContext>();

          return Scaffold(
            appBar: AppBar(
              title: const Text("Tree widget"),
            ),
            body: SingleChildScrollView(
              child: TreeItem(item: treeContext),
            ),
          );
        });
  }
}
