import 'package:flutter_reactter/reactter.dart';
import 'package:reactter_devtools_extension/src/interfaces/node.dart';
import 'package:reactter_devtools_extension/src/interfaces/node_info.dart';

base class SlotNode extends INode<INodeInfo> {
  @override
  final String? label = null;

  SlotNode._({required super.key, required super.kind, required super.type});

  factory SlotNode({
    required String key,
    required String kind,
    required String type,
  }) {
    return Rt.createState(
      () => SlotNode._(
        key: key,
        kind: kind,
        type: type,
      ),
    );
  }

  @override
  Future<void> loadDetails() async {
    // TODO: implement loadDetails
  }
}
