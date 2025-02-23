import 'package:flutter_reactter/reactter.dart';
import 'package:reactter_devtools_extension/src/bases/node.dart';
import 'package:reactter_devtools_extension/src/bases/node_info.dart';

final class KeyValueNode extends Node {
  String _value;

  String get value => _value;
  set value(String value) {
    if (_value == value) return;

    _value = value;
    uInfo.value = NodeInfo(this, type: kind, value: _value);
  }

  KeyValueNode.$({
    required super.key,
    required super.kind,
    required String value,
  }) : _value = value {
    uInfo.value = NodeInfo(this, type: kind, value: _value);
  }

  factory KeyValueNode({
    required String key,
    required String value,
    required String kind,
  }) {
    return Rt.registerState(
      () => KeyValueNode.$(key: key, value: value, kind: kind),
    );
  }

  @override
  Future<List<Node>> getDetails() async {
    return [];
  }
}
