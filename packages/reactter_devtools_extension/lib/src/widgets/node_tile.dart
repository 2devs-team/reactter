import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:reactter_devtools_extension/src/interfaces/node.dart';

enum NodeKind {
  instance(label: 'I', color: Colors.orange),
  state(label: 'S', color: Colors.blue),
  hook(label: 'H', color: Colors.purple),
  signal(label: 'S', color: Colors.green);

  const NodeKind({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  static NodeKind getKind(String kind) {
    switch (kind) {
      case 'instance':
        return instance;
      case 'state':
        return state;
      case 'hook':
        return hook;
      case 'signal':
        return signal;
      default:
        return instance;
    }
  }
}

class NodeTile extends StatelessWidget {
  final INode node;
  final void Function()? onTap;

  const NodeTile({
    super.key,
    required this.node,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RtWatcher((context, watch) {
      final isSelected = watch(node.uIsSelected).value;

      return ListTile(
        dense: true,
        visualDensity: const VisualDensity(vertical: 0, horizontal: 0),
        horizontalTitleGap: 0,
        minVerticalPadding: 0,
        contentPadding: EdgeInsets.zero,
        minTileHeight: 0,
        selected: isSelected,
        selectedTileColor: Theme.of(context).focusColor,
        onTap: onTap,
        // leading: NodeTileLeading(node: node),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ...List.generate(
              node.depth.toInt() - 1,
              (index) => Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: (index == node.depth.toInt() - 2) ? 0 : 0,
                ),
                child: const VerticalDivider(width: 1),
              ),
            ),
            NodeTileLeading(node: node),
            NodeTileTitle(node: node),
          ],
        ),
      );
    });
  }
}

class NodeTileLeading extends StatelessWidget {
  final INode node;

  const NodeTileLeading({super.key, required this.node});

  @override
  Widget build(BuildContext context) {
    return RtWatcher((context, watch) {
      final children = watch(node.uChildren).value;

      if (children.isEmpty) {
        return const SizedBox(width: 11);
      }

      final isExpanded = watch(node.uIsExpanded).value;

      return Padding(
        padding: const EdgeInsets.only(left: 8),
        child: IconButton(
          padding: EdgeInsets.zero,
          splashRadius: 18,
          iconSize: 24,
          constraints: const BoxConstraints.tightForFinite(),
          icon: Icon(
            isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
          ),
          onPressed: () {
            node.uIsExpanded.value = !isExpanded;
          },
        ),
      );
    });
  }
}

class NodeTileIcon extends StatelessWidget {
  final String kind;

  const NodeTileIcon({super.key, required this.kind});

  @override
  Widget build(BuildContext context) {
    final nodeKind = NodeKind.getKind(kind);

    return CircleAvatar(
      backgroundColor: nodeKind.color,
      child: Text(
        nodeKind.label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class NodeTileTitle extends StatelessWidget {
  final INode node;

  const NodeTileTitle({
    super.key,
    required this.node,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox.square(
          dimension: 24,
          child: Padding(
            padding: const EdgeInsets.all(4).copyWith(left: 0, right: 4),
            child: NodeTileIcon(kind: node.kind),
          ),
        ),
        RtWatcher((context, watch) {
          final info = watch(node.uInfo).value;

          return RichText(
            selectionRegistrar: SelectionContainer.maybeOf(context),
            selectionColor: Theme.of(context).highlightColor,
            text: TextSpan(
              style: Theme.of(context).textTheme.labelSmall,
              children: [
                TextSpan(
                  text: node.type,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: Colors.amber),
                ),
                if (info?.label != null)
                  TextSpan(
                    children: [
                      const TextSpan(text: "("),
                      TextSpan(
                        text: info?.label!,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      const TextSpan(text: ")"),
                    ],
                  ),
                TextSpan(
                  text: " #${node.key}",
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
