import 'package:flutter/material.dart';
import 'package:reactter/core/reactter_factory.dart';

class CreateContext extends StatefulWidget {
  final List<Object Function()> controllers;
  final Widget child;

  const CreateContext({
    Key? key,
    required this.controllers,
    required this.child,
  }) : super(key: key);

  @override
  State<CreateContext> createState() => _CreateContextState();
}

class _CreateContextState extends State<CreateContext> {
  @override
  initState() {
    super.initState();

    for (var controller in widget.controllers) {
      ReactterFactory().register(() => controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
