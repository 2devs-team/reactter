import 'package:reactter_devtools_extension/src/bases/node_info.dart';
import 'package:reactter_devtools_extension/src/constants.dart';

base class InstanceInfo extends NodeInfo {
  final String? dependencyKey;

  InstanceInfo(
    super.node, {
    super.nodeKind = NodeKind.instance,
    super.type,
    super.identify,
    super.identityHashCode,
    super.value,
    this.dependencyKey,
  });
}
