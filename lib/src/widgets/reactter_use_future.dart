library reactter;

import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';

class UseFuture<T> extends StatelessWidget {
  final UseState watch;
  final Future? future;
  final Widget Function()? isWaiting;
  final Widget Function(T watched) isDone;

  const UseFuture({
    Key? key,
    required this.future,
    required this.watch,
    this.isWaiting,
    required this.isDone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return isWaiting?.call() ?? const SizedBox.shrink();
        }
        return isDone((watch.value as T));
      },
    );
  }
}
