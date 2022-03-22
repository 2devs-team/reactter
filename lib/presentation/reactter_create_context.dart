import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';

class ContextProvider<T extends Object> {
  final String id;
  final Type type = T;
  final T Function() constructor;
  T? instance;
  final bool init;
  final bool create;

  ContextProvider(
    this.constructor, {
    this.init = false,
    this.create = false,
    this.id = "",
  }) {
    Reactter.factory.register<T>(constructor);

    initialize(init);
  }

  initialize([bool init = false]) {
    if (!init) return;

    if (instance != null) return;

    instance = Reactter.factory.getInstance<T>(create, 'ContextProvider');
  }

  destroy() {
    if (instance == null) return;

    Reactter.factory.deleted(instance!);
  }
}

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
