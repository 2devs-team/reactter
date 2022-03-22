import 'package:flutter/material.dart';
import 'package:reactter/core/reactter_factory.dart';

class ContextProvider<T extends Object> {
  final String id;
  final Type type = T;
  final T Function() constructor;
  T? instance;
  final bool init;

  ContextProvider(
    this.constructor, {
    this.init = false,
    this.id = "",
  }) {
    ReactterFactory().register<T>(constructor);
    print('[REACTTER] Instance "' + type.toString() + '" has been registered');
  }

  initialize() {
    if (!init) return;
    instance = ReactterFactory().getInstance<T>(hashCode);
    print('[REACTTER] Instance "' + type.toString() + '" has been initialized');
  }

  destroy() {
    ReactterFactory().destroy<T>(hashCode);
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
      contextProvider.initialize();
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
          ' has been initialize');

      contextProvider.destroy();
    }

    super.dispose();
  }
}
