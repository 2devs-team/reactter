import 'package:flutter/material.dart';

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

enum NodeKind {
  dependency(
    key: 'dependency',
    label: 'Dependency',
    abbr: 'D',
    color: Colors.teal,
  ),
  instance(
    key: 'instance',
    label: 'Instance',
    abbr: 'I',
    color: Colors.orange,
  ),
  state(
    key: 'state',
    label: 'State',
    abbr: 'S',
    color: Colors.blue,
  ),
  hook(
    key: 'hook',
    label: 'Hook',
    abbr: 'H',
    color: Colors.purple,
  ),
  signal(
    key: 'signal',
    label: 'Signal',
    abbr: 'S',
    color: Colors.green,
  );

  const NodeKind({
    required this.key,
    required this.label,
    required this.abbr,
    required this.color,
  });

  final String key;
  final String label;
  final String abbr;
  final Color color;

  static NodeKind? getKind(String kind) {
    switch (kind) {
      case 'dependency':
        return dependency;
      case 'instance':
        return instance;
      case 'state':
        return state;
      case 'hook':
        return hook;
      case 'signal':
        return signal;
      default:
        return null;
    }
  }
}
