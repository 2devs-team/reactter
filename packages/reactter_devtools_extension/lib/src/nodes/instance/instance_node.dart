import 'package:flutter_reactter/reactter.dart';
import 'package:reactter_devtools_extension/src/nodes/instance/instance_info.dart';
import 'package:reactter_devtools_extension/src/bases/node.dart';

final class InstanceNode extends Node<InstanceInfo> {
  @override
  final label = null;

  InstanceNode._({
    required super.key,
    required super.kind,
    required super.type,
  });

  factory InstanceNode({
    required String key,
    required String kind,
    required String type,
  }) {
    return Rt.createState(
      () => InstanceNode._(
        key: key,
        kind: kind,
        type: type,
      ),
    );
  }
}
