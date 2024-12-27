import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String label;
  final Color? color;
  final bool isSmall, isSelected;
  final VoidCallback? onPressed;

  Button.primary({
    Key? key,
    required this.label,
    this.isSelected = false,
    this.onPressed,
  })  : isSmall = false,
        color = Colors.amberAccent.shade700,
        super(key: key);

  Button.secondary({
    Key? key,
    required this.label,
    this.isSelected = false,
    this.onPressed,
  })  : isSmall = true,
        color = Colors.grey.shade800,
        super(key: key);

  Button.tertiary({
    Key? key,
    required this.label,
    this.onPressed,
  })  : isSmall = false,
        isSelected = false,
        color = Colors.grey.shade700,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        clipBehavior: Clip.hardEdge,
        onPressed: onPressed ?? () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Colors.grey.shade700,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          side: BorderSide(
            width: isSelected ? 4 : 1,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          shape: const ContinuousRectangleBorder(side: BorderSide.none),
        ),
        child: FittedBox(
          child: Text(
            label,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontSize: isSmall ? 16 : null,
                ),
          ),
        ),
      ),
    );
  }
}
