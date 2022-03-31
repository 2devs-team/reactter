library reactter;

import 'package:flutter/material.dart';
import '../widgets/reactter_use_provider.dart';

/// Create a new context to provide [T] to his builder.
class UseBuilder<T> extends StatelessWidget {
  final Widget? child;

  const UseBuilder({
    Key? key,
    required this.builder,
    this.child,
  }) : super(key: key);

  /// Build a widget tree based on the value from a [Context<T>].
  ///
  /// Must not be `null`.
  final Widget Function(
    BuildContext context,
    T value,
    Widget? child,
  ) builder;

  @override
  Widget build(BuildContext context) {
    return builder(
      context,
      UseProvider.of<T>(context) as T,
      child,
    );
  }
}
