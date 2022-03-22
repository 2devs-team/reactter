library reactter;

import 'package:flutter/material.dart';
import 'package:reactter/presentation/reactter_context.dart';

class UseProvider extends StatefulWidget {
  final Widget Function(BuildContext context, T Function<T>() mainState)
      builder;

  const UseProvider({Key? key, required this.builder}) : super(key: key);

  @override
  State<UseProvider> createState() => _UseProviderState();
}

class _UseProviderState extends State<UseProvider> {
  ReactterProviderState? mainState;

  Map<Type, Object?>? instances;

  T contextOf<T>() {
    return instances![T] as T;
  }

  @override
  initState() {
    super.initState();

    mainState = ReactterProvider.of(context);

    instances = mainState?.instanceMapper;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, contextOf);
  }
}
