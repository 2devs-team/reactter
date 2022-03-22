import 'package:flutter/material.dart';
import 'package:reactter/core/reactter_factory.dart';

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
    ReactterFactory().register<T>(constructor);

    print('//////////////////////////////////');
    print('[REACTTER] Instance "' + type.toString() + '" has been registered');

    initialize();
  }

  initialize() {
    if (!init) return;

    instance = ReactterFactory().getInstance<T>(
      hashCode,
      create,
      'ContextProvider ' + hashCode.toString(),
    );

    print('[REACTTER] Instance "' + type.toString() + '" has been created');
    print('//////////////////////////////////');
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

    // for (var contextProvider in widget.controllers) {
    //   contextProvider.initialize();
    // }
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
