import 'package:flutter/material.dart';
import 'package:reactter_devtools_extension/src/widgets/instance_icon.dart';

class InstanceTitle extends StatelessWidget {
  final String nKey;
  final String type;
  final String? kind;
  final String? label;
  final bool isDependency;
  final void Function()? onTapIcon;

  const InstanceTitle({
    super.key,
    required this.nKey,
    required this.type,
    this.kind,
    this.label,
    this.isDependency = false,
    this.onTapIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (kind != null)
          InkWell(
            onTap: onTapIcon,
            child: InstanceIcon(
              kind: kind!,
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
                text: " #$nKey",
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
