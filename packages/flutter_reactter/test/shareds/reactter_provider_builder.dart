import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'test_controller.dart';

class RtProviderBuilder extends StatelessWidget {
  final InstanceChildBuilder<TestController> builder;
  final String? id;

  const RtProviderBuilder({
    Key? key,
    this.id,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RtProvider(
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
