import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'test_context.dart';

class ReactterProviderBuilder extends StatelessWidget {
  final InstanceBuilder<TestContext> builder;
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
        final ctx = TestContext();
        if (id != null) {
          ctx.stateString.value = "from uniqueId";
        }
        return ctx;
      },
      id: id,
      builder: builder,
    );
  }
}
