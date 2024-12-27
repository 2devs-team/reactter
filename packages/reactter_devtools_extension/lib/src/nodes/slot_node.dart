import 'package:flutter_reactter/reactter.dart';
import 'package:reactter_devtools_extension/src/bases/node.dart';
import 'package:reactter_devtools_extension/src/bases/node_info.dart';

final class SlotNode extends Node<NodeInfo> {
  SlotNode._({required super.key}) : super(kind: 'slot');

  factory SlotNode({required String key}) {
    return Rt.createState(
      () => SlotNode._(key: key),
    );
  }

  @override
  Future<void> loadNode() {
    throw UnimplementedError();
  }

  @override
  Future<List<Node<NodeInfo>>> getDetails() {
    // TODO: implement getDetails
    throw UnimplementedError();
  }
}
