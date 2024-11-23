import 'package:flutter_reactter/reactter.dart';
import 'package:reactter_devtools_extension/src/bases/property_node.dart';

final class PropertySyncNode extends PropertyNode {
  PropertySyncNode._({
    required super.key,
    required super.value,
    required super.isExpanded,
  });

  factory PropertySyncNode({
    PropertyNode? parent,
    required String key,
    required String value,
    bool isExpanded = false,
  }) {
    return Rt.createState(
      () => PropertySyncNode._(
        key: key,
        value: value,
        isExpanded: isExpanded,
      ),
    );
  }

  void updateValue(String value) {
    uValue.value = value;
  }
}
