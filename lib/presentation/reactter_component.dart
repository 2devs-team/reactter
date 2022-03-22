library reactter;

import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';

abstract class ReactterComponent<T extends Object> extends StatelessWidget {
  const ReactterComponent({Key? key}) : super(key: key);

  final String? tag = null;

  T get state => Reactter.factory.getInstance<T>(false, "ReactterComponent")!;

  @override
  Widget build(BuildContext context);
}
