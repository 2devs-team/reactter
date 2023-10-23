import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    Key? key,
    required this.icon,
    this.color,
    required this.onPressed,
  }) : super(key: key);

  final Color? color;
  final IconData icon;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: color,
        padding: const EdgeInsets.all(4),
        minimumSize: const Size.square(32),
        maximumSize: const Size.square(32),
        fixedSize: const Size.square(32),
      ),
      onPressed: onPressed,
      child: Icon(icon),
    );
  }
}
