library reactter;

import 'package:flutter/material.dart';
import 'package:provider/single_child_widget.dart';
import 'package:reactter/widgets/reactter_use_provider.dart';

class UseBuilder<T> extends SingleChildStatelessWidget {
  /// {@template provider.consumer.constructor}
  /// Consumes a [Provider<T>]
  /// {@endtemplate}
  const UseBuilder({
    Key? key,
    required this.builder,
    Widget? child,
  }) : super(key: key, child: child);

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
  Widget buildWithChild(BuildContext context, Widget? child) {
    return builder(
      context,
      UseProvider.of<T>(context) as T,
      child,
    );
  }
}
