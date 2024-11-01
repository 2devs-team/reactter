import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.square(
      dimension: 18,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
