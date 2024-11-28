import 'package:flutter/material.dart';
import 'package:reactter_devtools_extension/src/bases/node.dart';

const int kMaxValueLength = 50;
const double kNodeTileHeight = 24;

enum NodeType {
  dependency('dependency'),
  state('state'),
  instance('instance');

  final String value;

  const NodeType(this.value);

  factory NodeType.fromString(String value) {
    return NodeType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => NodeType.instance,
    );
  }
}

abstract class NodeKindKey {
  static const String dependency = 'dependency';
  static const String instance = 'instance';
  static const String state = 'state';
  static const String hook = 'hook';
  static const String signal = 'signal';
}

enum NodeKind {
  dependency(
    type: NodeType.dependency,
    key: NodeKindKey.dependency,
    label: 'Dependency',
    abbr: 'D',
    color: Colors.teal,
  ),
  instance(
    type: NodeType.instance,
    key: NodeKindKey.instance,
    label: 'Instance',
    abbr: 'I',
    color: Colors.orange,
  ),
  state(
    type: NodeType.state,
    key: NodeKindKey.state,
    label: 'State',
    abbr: 'S',
    color: Colors.blue,
  ),
  hook(
    type: NodeType.state,
    key: NodeKindKey.hook,
    label: 'Hook',
    abbr: 'H',
    color: Colors.purple,
  ),
  signal(
    type: NodeType.state,
    key: NodeKindKey.signal,
    label: 'Signal',
    abbr: 'S',
    color: Colors.green,
  );

  const NodeKind({
    required this.type,
    required this.key,
    required this.label,
    required this.abbr,
    required this.color,
  });

  final NodeType type;
  final String key;
  final String label;
  final String abbr;
  final Color color;

  static NodeKind? getKind(String kind) {
    switch (kind) {
      case NodeKindKey.dependency:
        return dependency;
      case NodeKindKey.instance:
        return instance;
      case NodeKindKey.state:
        return state;
      case NodeKindKey.hook:
        return hook;
      case NodeKindKey.signal:
        return signal;
      default:
        return null;
    }
  }
}
