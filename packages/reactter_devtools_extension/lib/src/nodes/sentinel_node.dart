import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:reactter_devtools_extension/src/bases/node.dart';
import 'package:reactter_devtools_extension/src/bases/node_info.dart';

final class SentinelNode extends Node<NodeInfo> {
  SentinelNode._({required super.key}) : super(kind: 'sentinel');

  factory SentinelNode({required String key}) {
    return Rt.registerState(
      () => SentinelNode._(key: key),
    );
  }

  @override
  Future<void> loadNode() {
    assert(false, 'SentinelNode should not be loaded');
    throw UnimplementedError();
  }

  @override
  Future<List<Node<NodeInfo>>> getDetails() {
    assert(false, 'SentinelNode should not be expanded');
    throw UnimplementedError();
  }
}
