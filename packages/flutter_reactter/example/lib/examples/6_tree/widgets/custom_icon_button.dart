import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  final Widget icon;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(2),
      splashRadius: 18,
      iconSize: 24,
      constraints: const BoxConstraints.tightForFinite(),
      icon: icon,
      onPressed: onPressed,
    );
  }
}
