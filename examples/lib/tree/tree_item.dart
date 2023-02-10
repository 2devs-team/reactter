import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'tree_context.dart';

class TreeItem extends ReactterComponent<TreeContext> {
  const TreeItem({
    Key? key,
    required this.item,
    this.isLastChild = false,
  }) : super(key: key);

  final TreeContext item;
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
                        style: Theme.of(context).textTheme.bodySmall,
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
    final treeContext = context.use<TreeContext>(id);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Path of item[id='$id']"),
          content: Text(treeContext.path),
        );
      },
    );
  }

  Positioned buildTreeLine(TreeContext treeContext) {
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
                final treeContext = context.watchId<TreeContext>(
                  id,
                  (ctx) => [ctx.children],
                );

                return SizedBox(
                  width: treeContext.children.value.isEmpty ? 42 : 6,
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

  Builder buildChildrenList() {
    return Builder(
      builder: (context) {
        final treeContext = context.watchId<TreeContext>(
          id,
          (ctx) => [ctx.hide, ctx.children],
        );
        final children = treeContext.children.value;
        final hide = treeContext.hide.value;
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

  Builder buildCountLabel() {
    return Builder(
      builder: (context) {
        final treeContext = context.watchId<TreeContext>(
          id,
          (ctx) => [ctx.count, ctx.total],
        );

        return Text(
          "${treeContext.count.value} (${treeContext.total.value})",
        );
      },
    );
  }

  Builder buildAddButton() {
    return Builder(
      builder: (context) {
        final treeContext = context.watchId<TreeContext>(
          id,
          (ctx) => [ctx.hide, ctx.children],
        );

        if (treeContext.children.value.isEmpty) {
          return const SizedBox(width: 36);
        }

        return Button(
          icon: Transform.rotate(
            angle: treeContext.hide.value ? -pi / 2 : 0,
            child: const Icon(Icons.expand_circle_down_rounded),
          ),
          onPressed: treeContext.toggleHide,
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
