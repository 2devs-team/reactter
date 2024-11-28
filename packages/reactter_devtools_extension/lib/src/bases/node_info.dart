import 'package:reactter_devtools_extension/src/bases/node.dart';
import 'package:reactter_devtools_extension/src/constants.dart';

base class NodeInfo {
  final Node node;
  final NodeKind? nodeKind;
  final String? type;
  final String? identify;
  final String? identityHashCode;
  final String? value;

  const NodeInfo(
    this.node, {
    this.nodeKind,
    this.type,
    this.identify,
    this.identityHashCode,
    this.value,
  });

  NodeInfo copyWith({
    NodeKind? nodeKind,
    String? type,
    String? identify,
    String? identityHashCode,
    String? value,
  }) {
    return NodeInfo(
      node,
      nodeKind: nodeKind ?? this.nodeKind,
      type: type ?? this.type,
      identify: identify ?? this.identify,
      identityHashCode: identityHashCode ?? this.identityHashCode,
      value: value ?? this.value,
    );
  }
}
