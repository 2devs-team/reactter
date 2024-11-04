import 'package:flutter/material.dart';

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
  instance(label: 'Instance', abbr: 'I', color: Colors.orange),
  state(label: 'State', abbr: 'S', color: Colors.blue),
  hook(label: 'Hook', abbr: 'H', color: Colors.purple),
  signal(label: 'Signal', abbr: 'S', color: Colors.green);

  const NodeKind({
    required this.label,
    required this.abbr,
    required this.color,
  });

  final String label;
  final String abbr;
  final Color color;

  static NodeKind getKind(String kind) {
    switch (kind) {
      case 'instance':
        return instance;
      case 'state':
        return state;
      case 'hook':
        return hook;
      case 'signal':
        return signal;
      default:
        return instance;
    }
  }
}
