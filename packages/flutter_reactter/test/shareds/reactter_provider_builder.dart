import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'test_builder.dart';
import 'test_context.dart';

class ReactterProviderBuilder extends StatelessWidget {
  final TransitionBuilder builder;
  final String? id;

  const ReactterProviderBuilder({
    Key? key,
    this.id,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestBuilder(
      child: ReactterProvider(
        () => TestContext(),
        id: id,
        onInit: id == null
            ? null
            : (TestContext inst) => inst.stateString.value = "from uniqueId",
        builder: builder,
      ),
    );
  }
}
