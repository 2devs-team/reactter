import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'tree_context.dart';
import 'tree_item.dart';

class TreeExample extends StatelessWidget {
  const TreeExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactterProvider(
      () => TreeContext(),
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
      },
    );
  }
}
