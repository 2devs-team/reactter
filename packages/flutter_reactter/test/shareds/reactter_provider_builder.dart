import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'test_builder.dart';
import 'test_context.dart';

class ReactterProviderBuilder extends StatelessWidget {
  final TransitionBuilder builder;

  const ReactterProviderBuilder({Key? key, required this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestBuilder(
      child: ReactterProviders(
        providers: [
          ReactterProvider(() => TestContext()),
          ReactterProvider(
            () => TestContext(),
            id: 'uniqueId',
            onInit: (TestContext inst) =>
                inst.stateString.value = "from uniqueId",
          ),
        ],
        builder: builder,
      ),
    );
  }
}
