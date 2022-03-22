library reactter;

import 'package:flutter/material.dart';
import 'package:reactter/core/reactter_controller.dart';
import 'package:reactter/core/reactter_factory.dart';

abstract class ReactterComponent<T extends ReactterController>
    extends StatelessWidget {
  const ReactterComponent({Key? key}) : super(key: key);

  final String? tag = null;

  T get state => ReactterFactory().getInstance<T>()!;

  @override
  Widget build(BuildContext context);
}
