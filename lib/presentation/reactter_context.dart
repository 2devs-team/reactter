import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';

class ReactterContext<T extends Object> {
  final String id;
  final Type type = T;
  final T Function() constructor;
  T? instance;
  final bool init;
  final bool create;

  ReactterContext(
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
      {Key? key, required this.contexts, required this.builder})
      : super(key: key);

  final List<ReactterContext> contexts;
  final Widget Function(BuildContext context) builder;

  static T? getContext<T extends Object>(BuildContext context) {
    final ReactterProviderState? mainState =
        context.findAncestorStateOfType<ReactterProviderState>();

    if (mainState == null) {
      return null;
    }

    for (var controller in mainState.contexts!) {
      if (controller.type == T) {
        return ReactterFactory().getInstance<T>() as T;
      }
    }

    return null;
  }

  static ReactterProviderState? of(BuildContext context) {
    return context.findAncestorStateOfType<ReactterProviderState>();
  }

  @override
  State<ReactterProvider> createState() => ReactterProviderState();
}

class ReactterProviderState extends State<ReactterProvider> {
  List<ReactterContext>? contexts;
  Map<Type, Object?>? instanceMapper;

  @override
  initState() {
    super.initState();

    contexts = widget.contexts;

    for (var controller in widget.contexts) {
      controller.initialize(true);

      instanceMapper ??= {};
      instanceMapper
          ?.addEntries([MapEntry(controller.type, controller.instance)]);
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
    for (var controller in widget.contexts) {
      print('[REACTTER] Instance "' +
          controller.type.toString() +
          '" with hashcode: ' +
          controller.hashCode.toString() +
          ' has been disposed');

      controller.destroy();
    }
  }
}
