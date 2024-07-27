import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'test_controller.dart';

class RtMultiProviderBuilder extends StatefulWidget {
  final TransitionBuilder builder;

  const RtMultiProviderBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  State<RtMultiProviderBuilder> createState() => _RtMultiProviderBuilderState();
}

class _RtMultiProviderBuilderState extends State<RtMultiProviderBuilder> {
  @override
  Widget build(BuildContext context) {
    return RtScope(
      child: RtMultiProvider(
        [
          RtProvider.init(
            () => TestController(),
          ),
          RtProvider(
            () {
              final inst = TestController();
              inst.stateString.value = "from uniqueId";
              return inst;
            },
            id: 'uniqueId',
          ),
        ],
        builder: widget.builder,
        child: const Text('child'),
      ),
    );
  }
}
