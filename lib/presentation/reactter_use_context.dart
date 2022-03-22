library reactter;

import 'package:flutter/material.dart';
import 'package:reactter/presentation/reactter_context.dart';

class UseContext<T> extends StatefulWidget {
  final Widget Function(BuildContext context, Object mainState) builder;

  const UseContext({Key? key, required this.builder}) : super(key: key);

  @override
  State<UseContext> createState() => _UseContextState<T>();
}

class _UseContextState<T> extends State<UseContext> {
  ReactterProviderState? mainState;

  late T instance;
  @override
  initState() {
    super.initState();

    mainState = ReactterProvider.of(context);

    instance = mainState?.instanceMapper![T] as T;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, instance as Object);
  }
}
