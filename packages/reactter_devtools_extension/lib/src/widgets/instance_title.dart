import 'package:flutter/material.dart';

class InstanceTitle extends StatelessWidget {
  final String type;
  final String? label;
  final String nKey;

  const InstanceTitle({
    super.key,
    required this.type,
    this.label,
    required this.nKey,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
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
    );
  }
}
