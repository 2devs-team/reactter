import 'package:flutter/widgets.dart';

class ReactterDevtoolsExtension extends StatefulWidget {
  const ReactterDevtoolsExtension({super.key});

  @override
  State<ReactterDevtoolsExtension> createState() =>
      _ReactterDevtoolsExtensionState();
}

class _ReactterDevtoolsExtensionState extends State<ReactterDevtoolsExtension> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Text('Reactter Devtools Extension'),
    );
  }
}
