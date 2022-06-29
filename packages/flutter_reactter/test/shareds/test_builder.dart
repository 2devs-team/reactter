import 'package:flutter/material.dart';

class TestBuilder extends StatelessWidget {
  final Widget child;

  const TestBuilder({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }
}
