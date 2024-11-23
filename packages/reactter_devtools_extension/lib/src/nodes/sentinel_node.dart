import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:reactter_devtools_extension/src/bases/node.dart';
import 'package:reactter_devtools_extension/src/bases/node_info.dart';

final class SentinelNode extends Node<NodeInfo> {
  @override
  String? get label => 'Sentinel';

  SentinelNode._({
    required super.key,
    required super.kind,
    required super.type,
  });

  factory SentinelNode({
    required String key,
    required String kind,
    required String type,
  }) {
    return Rt.createState(
      () => SentinelNode._(
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
