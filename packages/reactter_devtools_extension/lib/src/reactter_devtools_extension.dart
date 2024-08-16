import 'dart:async';

import 'package:devtools_app_shared/service.dart';
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/widgets.dart';

class ReactterDevtoolsExtension extends StatefulWidget {
  const ReactterDevtoolsExtension({super.key});

  @override
  State<ReactterDevtoolsExtension> createState() =>
      _ReactterDevtoolsExtensionState();
}

class _ReactterDevtoolsExtensionState extends State<ReactterDevtoolsExtension> {
  late final StreamSubscription extensionEventSubscription;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final vmService = await serviceManager.onServiceAvailable;

    final evalOnDartLibrary = EvalOnDartLibrary(
      'package:flutter_reactter/src/devtools.dart',
      vmService,
      serviceManager: serviceManager,
    );

    try {
      final instanceRef = await evalOnDartLibrary.safeEval(
        'ReactterDevTools.debugInstance',
        isAlive: null,
      );

      print(
        'ReactterDevTools.debugInstance: ${instanceRef.identityHashCode}',
      );
    } catch (e) {
      print('Error: $e');
    }

    extensionEventSubscription = vmService.onExtensionEvent.listen((event) {
      if (!(event.extensionKind?.startsWith('ext.reactter.') ?? false)) {
        return;
      }

      print(
        "Received event: ${event.extensionKind}"
        " with data: ${event.extensionData}",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Text('Reactter Devtools Extension'),
    );
  }
}
