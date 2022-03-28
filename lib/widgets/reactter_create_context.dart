// ignore_for_file: avoid_print
library reactter;

import 'package:flutter/material.dart';
import 'package:reactter/widgets/reactter_context_provider.dart';

class CreateContext extends StatefulWidget {
  final List<ContextProvider> controllers;
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

    for (var contextProvider in widget.controllers) {
      contextProvider.initialize(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  dispose() {
    for (var contextProvider in widget.controllers) {
      print('[REACTTER] Instance "' +
          contextProvider.type.toString() +
          '" with hashcode: ' +
          contextProvider.hashCode.toString() +
          ' has been disposed');

      contextProvider.destroy();
    }

    super.dispose();
  }
}
