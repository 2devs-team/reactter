import 'package:flutter/material.dart';

class Badget extends StatelessWidget {
  const Badget({
    Key? key,
    required this.label,
    required this.value,
    required this.labelColor,
    required this.valueColor,
    this.icon,
  }) : super(key: key);

  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: labelColor,
        borderRadius: BorderRadius.circular(4),
      ),
      clipBehavior: Clip.hardEdge,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 8),
          if (icon != null) Icon(icon, color: Colors.white, size: 16),
          if (icon != null) const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: Colors.white),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              color: valueColor,
              height: 24,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                value,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
