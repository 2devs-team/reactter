import 'package:flutter/material.dart';

class RadioWithLabel<T extends Object> extends StatelessWidget {
  const RadioWithLabel({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.label,
    required this.onChanged,
  }) : super(key: key);

  final T value;
  final T? groupValue;
  final String label;
  final void Function(T?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<T>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          visualDensity: VisualDensity.compact,
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
