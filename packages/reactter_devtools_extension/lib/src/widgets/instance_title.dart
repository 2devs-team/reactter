import 'package:flutter/material.dart';
import 'package:reactter_devtools_extension/src/constants.dart';
import 'package:reactter_devtools_extension/src/widgets/instance_icon.dart';

class InstanceTitle extends StatelessWidget {
  final String nodeKey;
  final String? type;
  final NodeKind? nodeKind;
  final String? label;
  final bool isDependency;
  final void Function()? onTapIcon;

  const InstanceTitle({
    required this.nodeKey,
    super.key,
    this.type,
    this.nodeKind,
    this.label,
    this.isDependency = false,
    this.onTapIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (nodeKind != null)
          InkWell(
            onTap: onTapIcon,
            child: InstanceIcon(
              nodeKind: nodeKind,
              isDependency: isDependency,
            ),
          ),
        RichText(
          selectionRegistrar: SelectionContainer.maybeOf(context),
          selectionColor: Theme.of(context).highlightColor,
          text: TextSpan(
            style: Theme.of(context).textTheme.labelSmall,
            children: [
              TextSpan(
                text: type,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: Colors.amber),
              ),
              if (label != null)
                TextSpan(
                  children: [
                    const TextSpan(text: "("),
                    TextSpan(
                      text: label!,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    const TextSpan(text: ")"),
                  ],
                ),
              TextSpan(
                text: " #$nodeKey",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
