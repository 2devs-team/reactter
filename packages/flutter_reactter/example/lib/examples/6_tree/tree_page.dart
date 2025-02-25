import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'package:examples/examples/6_tree/controllers/tree_controller.dart';
import 'package:examples/examples/6_tree/widgets/tree_item.dart';

class Test extends ChangeNotifier {
  final int value;

  Test(this.value);
}

class TreePage extends StatelessWidget {
  const TreePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final listKey = GlobalKey();
    return RtProvider(
      TreeController.new,
      builder: (context, treeController, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Tree widget"),
          ),
          body: CustomScrollView(
            slivers: [
              RtSelector<TreeController, int>(
                selector: (treeController, watch) {
                  return watch(treeController.treeList).length;
                },
                builder: (context, treeController, length, _) {
                  return SliverList(
                    key: listKey,
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final treeNode =
                            treeController.treeList.elementAt(index);

                        return TreeItem(
                          key: ObjectKey(treeNode),
                          treeNode: treeNode,
                        );
                      },
                      childCount: treeController.treeList.length,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
