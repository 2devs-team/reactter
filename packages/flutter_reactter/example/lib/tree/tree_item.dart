import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'tree_node.dart';

class TreeItem extends ReactterComponent<TreeNode> {
  const TreeItem({
    Key? key,
    required this.item,
    this.isLastChild = false,
  }) : super(key: key);

  final TreeNode item;
  final bool isLastChild;

  @override
  String get id => "${item.hashCode}";

  @override
  get builder => () => item;

  @override
  Widget render(treeContext, context) {
    return InkWell(
      onTap: () => openDialog(context),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 8),
                  buildAddButton(),
                  Button(
                    icon: const Icon(Icons.add_circle),
                    onPressed: treeContext.addChild,
                  ),
                  if (treeContext.parent != null)
                    Button(
                      icon: Transform.rotate(
                        angle: -pi / 4,
                        child: const Icon(Icons.add_circle),
                      ),
                      onPressed: treeContext.removeFromParent,
                    ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        id,
                        style: Theme.of(context).textTheme.caption,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Button(
                    icon: const Icon(Icons.indeterminate_check_box_rounded),
                    onPressed: treeContext.decrease,
                  ),
                  buildCountLabel(),
                  Button(
                    icon: const Icon(Icons.add_box),
                    onPressed: treeContext.increase,
                  ),
                ],
              ),
              buildChildrenList(),
            ],
          ),
          buildTreeLine(treeContext),
        ],
      ),
    );
  }

  Future<void> openDialog(BuildContext context) {
    final treeNode = context.use<TreeNode>(id);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("About item[id='$id']"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("path:"),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      treeNode.path,
                      style: Theme.of(context).textTheme.caption,
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text("children:"),
                  const SizedBox(width: 8),
                  Text(
                    "${treeNode.children.value.length}",
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
              Row(
                children: [
                  const Text("count:"),
                  const SizedBox(width: 8),
                  Text(
                    "${treeNode.count.value}",
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
              Row(
                children: [
                  const Text("childrenTotal:"),
                  const SizedBox(width: 8),
                  Text(
                    "${treeNode.childrenTotal.value}",
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
              Row(
                children: [
                  const Text("total(count + childrenTotal):"),
                  const SizedBox(width: 8),
                  Text(
                    "${treeNode.total}",
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildTreeLine(TreeNode treeContext) {
    return Positioned(
      top: 0,
      bottom: 0,
      child: Align(
        alignment: Alignment.topLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: treeContext.parent == null || isLastChild ? 19 : null,
              child: const VerticalDivider(
                width: 2,
                thickness: 2,
              ),
            ),
            Builder(
              builder: (context) {
                final treeNode = context.watchId<TreeNode>(
                  id,
                  (inst) => [inst.children],
                );

                return SizedBox(
                  width: treeNode.children.value.isEmpty ? 42 : 6,
                  height: 36,
                  child: const Divider(
                    height: 2,
                    thickness: 2,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildChildrenList() {
    return Builder(
      builder: (context) {
        final treeNode = context.watchId<TreeNode>(
          id,
          (inst) => [inst.hide, inst.children],
        );
        final children = treeNode.children.value;
        final hide = treeNode.hide.value;
        final itemLast = children.isNotEmpty ? children.last : null;

        return ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.only(left: 24),
          itemCount: hide ? 0 : children.length,
          itemBuilder: (context, index) {
            final item = children[index];

            return TreeItem(
              key: ObjectKey(item),
              item: item,
              isLastChild: item == itemLast,
            );
          },
        );
      },
    );
  }

  Widget buildCountLabel() {
    return Builder(
      builder: (context) {
        final treeNode = context.watchId<TreeNode>(
          id,
          (inst) => [inst.count, inst.childrenTotal],
        );

        return Text(
          "${treeNode.count.value} (${treeNode.total})",
        );
      },
    );
  }

  Widget buildAddButton() {
    return Builder(
      builder: (context) {
        final treeNode = context.watchId<TreeNode>(
          id,
          (inst) => [inst.hide, inst.children],
        );

        if (treeNode.children.value.isEmpty) {
          return const SizedBox(width: 36);
        }

        return Button(
          icon: Transform.rotate(
            angle: treeNode.hide.value ? -pi / 2 : 0,
            child: const Icon(Icons.expand_circle_down_rounded),
          ),
          onPressed: treeNode.toggleHide,
        );
      },
    );
  }
}

class Button extends StatelessWidget {
  const Button({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  final Widget icon;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(6),
      splashRadius: 18,
      iconSize: 24,
      constraints: const BoxConstraints.tightForFinite(),
      icon: icon,
      onPressed: onPressed,
    );
  }
}
