import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';

class ReactterController<T extends Object> {
  final String id;
  final Type type = T;
  final T Function() constructor;
  T? instance;
  final bool init;
  final bool create;

  ReactterController(
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

class ReactterProvider extends StatefulWidget {
  const ReactterProvider(
      {Key? key, required this.controllers, required this.builder})
      : super(key: key);

  final List<ReactterController> controllers;
  final Widget Function(BuildContext context) builder;

  static T? of<T extends Object>(BuildContext context) {
    final ReactterProviderState? mainState =
        context.findAncestorStateOfType<ReactterProviderState>();

    if (mainState == null) {
      return null;
    }

    for (var controller in mainState.controllers!) {
      if (controller.type == T) {
        return ReactterFactory().getInstance<T>() as T;
      }
    }

    return null;
  }

  @override
  State<ReactterProvider> createState() => ReactterProviderState();
}

class ReactterProviderState extends State<ReactterProvider> {
  List<ReactterController>? controllers;

  @override
  initState() {
    super.initState();

    controllers = widget.controllers;

    for (var controller in widget.controllers) {
      controller.initialize(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return widget.builder(context);
    });
  }

  @override
  dispose() {
    for (var controller in widget.controllers) {
      print('[REACTTER] Instance "' +
          controller.type.toString() +
          '" with hashcode: ' +
          controller.hashCode.toString() +
          ' has been disposed');

      controller.destroy();
    }
  }
}
