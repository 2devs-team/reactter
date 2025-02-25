import 'package:reactter_devtools_extension/src/nodes/instance/instance_info.dart';

final class StateInfo extends InstanceInfo {
  final String? debugLabel;
  final String? boundInstanceKey;

  StateInfo(
    super.node, {
    super.nodeKind,
    super.type,
    super.identify,
    super.identityHashCode,
    super.value,
    super.dependencyKey,
    this.debugLabel,
    this.boundInstanceKey,
  });
}
