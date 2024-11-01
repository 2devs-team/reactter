import 'package:devtools_app_shared/ui.dart';
import 'package:flutter/material.dart' hide Split;
import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:reactter_devtools_extension/src/widgets/nodes_list.dart';
import 'package:reactter_devtools_extension/src/widgets/properties_list.dart';
import 'controllers/nodes_controller.dart';

class RtDevToolsExtension extends StatelessWidget {
  const RtDevToolsExtension({super.key});

  @override
  Widget build(BuildContext context) {
    return RtProvider(
      () => NodesController(),
      builder: (context, inst, child) {
        return SplitPane(
          axis: SplitPane.axisFor(context, 0.8),
          initialFractions: const [0.40, 0.60],
          children: const [
            RoundedOutlinedBorder(
              clip: true,
              child: Column(
                children: [
                  AreaPaneHeader(title: Text("Instance Tree")),
                  Expanded(
                    child: NodesList(),
                  ),
                ],
              ),
            ),
            RoundedOutlinedBorder(
              clip: true,
              child: Column(
                children: [
                  AreaPaneHeader(title: Text("Details")),
                  Expanded(
                    child: PropertiesList(),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
