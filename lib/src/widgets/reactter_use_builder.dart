library reactter;

import 'package:flutter/material.dart';
import '../widgets/reactter_use_provider.dart';

class UseBuilder<T> extends StatelessWidget {
  final Widget? child;

  /// {@template provider.consumer.constructor}
  /// Consumes a [Provider<T>]
  /// {@endtemplate}
  const UseBuilder({
    Key? key,
    required this.builder,
    this.child,
  }) : super(key: key);

  /// {@template provider.consumer.builder}
  /// Build a widget tree based on the value from a [Provider<T>].
  ///
  /// Must not be `null`.
  /// {@endtemplate}
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
