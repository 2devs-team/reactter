import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:flutter_reactter/src/types.dart';

import 'test_controller.dart';

class ReactterProviderBuilder extends StatelessWidget {
  final InstanceBuilder<TestController> builder;
  final String? id;

  const ReactterProviderBuilder({
    Key? key,
    this.id,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactterProvider(
      () {
        final inst = TestController();
        if (id != null) {
          inst.stateString.value = "from uniqueId";
        }
        return inst;
      },
      id: id,
      builder: builder,
    );
  }
}
