import 'package:flutter_reactter/reactter.dart';
import 'package:reactter_devtools_extension/src/interfaces/node.dart';
import 'package:reactter_devtools_extension/src/interfaces/node_info.dart';

base class InstanceNode extends INode<INodeInfo> {
  InstanceNode._({
    required super.key,
    required super.kind,
    required super.type,
  }) {
    // _loadStateNode();
  }

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

  @override
  void loadDetails() {
    // TODO: implement loadDetails
  }
}
