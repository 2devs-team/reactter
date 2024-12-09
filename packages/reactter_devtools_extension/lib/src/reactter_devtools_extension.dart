import 'package:devtools_app_shared/ui.dart';
import 'package:flutter/material.dart' hide Split;
import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:reactter_devtools_extension/src/controllers/node_details_controller.dart';
import 'package:reactter_devtools_extension/src/nodes/instance/instance_info.dart';
import 'package:reactter_devtools_extension/src/widgets/dependencies_list.dart';
import 'package:reactter_devtools_extension/src/widgets/detail_node_list.dart';
import 'package:reactter_devtools_extension/src/widgets/instance_title.dart';
import 'package:reactter_devtools_extension/src/widgets/nodes_list.dart';
import 'controllers/nodes_controller.dart';

class RtDevToolsExtension extends StatelessWidget {
  const RtDevToolsExtension({super.key});

  @override
  Widget build(BuildContext context) {
    return RtMultiProvider(
      [
        RtProvider(() => NodeDetailsController()),
        RtProvider(() => NodesController()),
      ],
      builder: (context, child) {
        return SplitPane(
          axis: SplitPane.axisFor(context, 1.2),
          initialFractions: const [0.55, 0.45],
          children: [
            RoundedOutlinedBorder(
              clip: true,
              child: LayoutBuilder(builder: (context, constraints) {
                return FlexSplitColumn(
                  totalHeight: constraints.maxHeight,
                  initialFractions: const [0.25, 0.75],
                  minSizes: const [0.0, 0.0],
                  headers: const <PreferredSizeWidget>[
                    AreaPaneHeader(
                      roundedTopBorder: false,
                      includeTopBorder: false,
                      title: Text("Dependencies"),
                    ),
                    AreaPaneHeader(
                      rightPadding: 0.0,
                      roundedTopBorder: false,
                      title: Text("State/Instance Tree"),
                    ),
                  ],
                  children: const [
                    DependenciesList(),
                    NodesList(),
                  ],
                );
              }),
            ),
            RoundedOutlinedBorder(
              clip: true,
              child: Column(
                children: [
                  RtWatcher((context, watch) {
                    final nodeDetailsController =
                        context.use<NodeDetailsController>();
                    final selectedNode =
                        watch(nodeDetailsController.uCurrentNode).value;

                    if (selectedNode == null) {
                      return const AreaPaneHeader(
                        roundedTopBorder: false,
                        title: Text("Select a node for details"),
                      );
                    }

                    final nodeInfo = watch(selectedNode.uInfo).value;

                    return AreaPaneHeader(
                      roundedTopBorder: false,
                      title: Row(
                        children: [
                          const Text(
                            "Details of ",
                          ),
                          InstanceTitle(
                            identifyHashCode: selectedNode.key,
                            type: nodeInfo?.type,
                            nodeKind: nodeInfo?.nodeKind,
                            label: nodeInfo?.identify,
                            isDependency: nodeInfo is InstanceInfo
                                ? nodeInfo.dependencyKey != null
                                : false,
                          ),
                        ],
                      ),
                    );
                  }),
                  const Expanded(
                    child: DetailNodeList(),
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
