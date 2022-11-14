import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'tree_context.dart';

class TreeItem extends ReactterComponent<TreeContext> {
  const TreeItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  final TreeContext item;

  @override
  String get id => "${item.hashCode}";

  @override
  get listenStates => (_) => [];

  @override
  get builder => () => item;

  @override
  Widget render(treeContext, context) {
    return ListTile(
      onTap: () {},
      dense: true,
      visualDensity: VisualDensity.compact,
      minVerticalPadding: 16,
      title: Row(
        children: [
          IconButton(
            onPressed: treeContext.decrease,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 32),
            splashRadius: 18,
            iconSize: 24,
            icon: const Icon(Icons.indeterminate_check_box_rounded),
          ),
          const SizedBox(width: 8),
          Builder(
            builder: (context) {
              context.watchId<TreeContext>(id, (ctx) => [ctx.count]);

              return Text("${treeContext.count.value}");
            },
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: treeContext.increase,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 32),
            splashRadius: 18,
            iconSize: 24,
            icon: const Icon(Icons.add_box_rounded),
          ),
          const SizedBox(width: 8),
          Builder(
            builder: (context) {
              context.watchId<TreeContext>(id, (ctx) => [ctx.total]);

              return Text("Total(${treeContext.total.value})");
            },
          ),
          const Spacer(),
          Text("id: $id"),
          const Spacer(),
          IconButton(
            onPressed: treeContext.addChild,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 32),
            splashRadius: 18,
            iconSize: 24,
            icon: const Icon(Icons.add_circle),
          ),
          if (treeContext.parent != null)
            IconButton(
              onPressed: treeContext.removeFromParent,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 32),
              splashRadius: 18,
              iconSize: 24,
              icon: Transform.rotate(
                angle: -pi / 4,
                child: const Icon(Icons.add_circle),
              ),
            ),
          Builder(
            builder: (context) {
              context.watchId<TreeContext>(
                id,
                (ctx) => [ctx.hide, ctx.children],
              );

              return Visibility(
                visible: treeContext.children.value.isNotEmpty,
                child: IconButton(
                  onPressed: treeContext.toggleHide,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(width: 32),
                  splashRadius: 18,
                  iconSize: 24,
                  icon: Transform.rotate(
                    angle: treeContext.hide.value ? -pi : 0,
                    child: Icon(treeContext.hide.value
                        ? Icons.expand_circle_down_outlined
                        : Icons.expand_circle_down_rounded),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      subtitle: Builder(
        builder: (context) {
          context.watchId<TreeContext>(id, (ctx) => [ctx.hide, ctx.children]);

          return Visibility(
            visible: !treeContext.hide.value,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: treeContext.children.value.length,
              itemBuilder: (context, index) {
                final item = treeContext.children.value[index];

                return TreeItem(
                  key: ObjectKey(item),
                  item: item,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
