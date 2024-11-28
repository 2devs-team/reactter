import 'package:flutter_reactter/reactter.dart';
import 'package:reactter_devtools_extension/src/bases/node.dart';
import 'package:reactter_devtools_extension/src/bases/node_info.dart';
import 'package:vm_service/vm_service.dart';

final class NullNode extends Node<NodeInfo> {
  NullNode.$({required super.key}) : super(kind: InstanceKind.kNull) {
    uInfo.value = NodeInfo(
      this,
      type: 'null',
      identify: 'null',
      value: 'null',
    );
  }

  factory NullNode({required String key}) {
    return Rt.createState(
      () => NullNode.$(key: key),
    );
  }

  @override
  Future<List<Node>> getDetails() async {
    return [];
  }
}
