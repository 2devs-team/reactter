import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'test_context.dart';

class ReactterProvidersBuilder extends StatefulWidget {
  final TransitionBuilder builder;

  const ReactterProvidersBuilder({Key? key, required this.builder})
      : super(key: key);

  @override
  State<ReactterProvidersBuilder> createState() =>
      _ReactterProvidersBuilderState();
}

class _ReactterProvidersBuilderState extends State<ReactterProvidersBuilder> {
  @override
  Widget build(BuildContext context) {
    return ReactterProviders(
      [
        ReactterProvider(
          () => TestContext(),
          init: true,
        ),
        ReactterProvider(
          () {
            final ctx = TestContext();
            ctx.stateString.value = "from uniqueId";
            return ctx;
          },
          id: 'uniqueId',
        ),
      ],
      builder: widget.builder,
      child: const Text('child'),
    );
  }
}
