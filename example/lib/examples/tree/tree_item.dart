import 'dart:math';
import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';

import 'package:example/examples/tree/tree_context.dart';

class TreeItem extends ReactterComponent<TreeContext> {
  const TreeItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  final TreeContext item;

  @override
  String get id => item.hashCode.toString();

  @override
  get builder => () => item;

  @override
  Widget render(ctx, context) {
    return ListTile(
      onTap: () {},
      dense: true,
      visualDensity: VisualDensity.compact,
      minVerticalPadding: 16,
      title: Row(
        children: [
          ReactterBuilder<TreeContext>(
            id: id,
            listenHooks: (ctx) => [ctx.count],
            builder: (ctx, context, child) {
              return Text("Count: ${ctx.count.value}");
            },
          ),
          IconButton(
            onPressed: ctx.increment,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 42),
            splashRadius: 18,
            iconSize: 24,
            icon: const Icon(Icons.add_box_rounded),
          ),
          IconButton(
            onPressed: ctx.drecrement,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 42),
            splashRadius: 18,
            iconSize: 24,
            icon: const Icon(Icons.indeterminate_check_box_rounded),
          ),
          const Spacer(),
          Text("id: $id"),
          const Spacer(),
          IconButton(
            onPressed: ctx.addChild,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 42),
            splashRadius: 18,
            iconSize: 24,
            icon: const Icon(Icons.add_circle),
          ),
          if (ctx.parent != null)
            IconButton(
              onPressed: ctx.removeFromParent,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 42),
              splashRadius: 18,
              iconSize: 24,
              icon: Transform.rotate(
                angle: -pi / 4,
                child: const Icon(Icons.add_circle),
              ),
            ),
          ReactterBuilder<TreeContext>(
            id: id,
            listenHooks: (ctx) => [ctx.hide],
            builder: (ctx, context, child) {
              return IconButton(
                onPressed: ctx.toggleHide,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(width: 42),
                splashRadius: 18,
                iconSize: 24,
                icon: Transform.rotate(
                  angle: ctx.hide.value ? -pi : 0,
                  child: Icon(ctx.hide.value
                      ? Icons.expand_circle_down_outlined
                      : Icons.expand_circle_down_rounded),
                ),
              );
            },
          ),
        ],
      ),
      subtitle: ReactterBuilder<TreeContext>(
        id: id,
        listenHooks: (ctx) => [ctx.hide],
        builder: (ctx, context, child) {
          return ctx.hide.value
              ? const SizedBox()
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: ctx.children.value.length,
                  itemBuilder: (context, index) {
                    final item = ctx.children.value[index];

                    return TreeItem(item: item);
                  },
                );
        },
      ),
    );
  }
}
