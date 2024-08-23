import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    Key? key,
    required this.icon,
    this.tooltip,
    required this.onPressed,
  }) : super(key: key);

  final Widget icon;
  final String? tooltip;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(2),
      splashRadius: 18,
      iconSize: 24,
      constraints: const BoxConstraints.tightForFinite(),
      icon: icon,
      tooltip: tooltip,
      onPressed: onPressed,
    );
  }
}
