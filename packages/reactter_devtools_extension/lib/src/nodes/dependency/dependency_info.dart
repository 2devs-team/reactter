import 'package:reactter_devtools_extension/src/constants.dart';
import 'package:reactter_devtools_extension/src/nodes/instance/instance_info.dart';

final class DependencyInfo extends InstanceInfo {
  final String? mode;

  DependencyInfo(
    super.node, {
    this.mode,
    super.type,
    super.identify,
    super.identityHashCode,
    super.value,
  }) : super(nodeKind: NodeKind.dependency);
}
