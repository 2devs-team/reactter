import 'package:flutter/material.dart';
import 'package:reactter_devtools_extension/src/bases/node.dart';
import 'package:vm_service/vm_service.dart';

class ColorPalette {
  final Color selected;
  final Color key;
  final Color type;
  final Color label;
  final Color identifyHashCode;
  final Color nullValue;
  final Color boolValue;
  final Color stringValue;
  final Color numberValue;

  const ColorPalette._({
    required this.selected,
    required this.key,
    required this.type,
    required this.label,
    required this.identifyHashCode,
    required this.nullValue,
    required this.boolValue,
    required this.stringValue,
    required this.numberValue,
  });

  static ColorPalette? dark;
  static ColorPalette? light;

  factory ColorPalette._dark(BuildContext context) {
    return ColorPalette._(
      selected: Theme.of(context).primaryColorDark,
      key: Theme.of(context).colorScheme.secondary,
      type: Colors.amber,
      label: Theme.of(context).colorScheme.primary,
      identifyHashCode: Colors.grey,
      nullValue: Colors.grey,
      boolValue: Colors.lightBlue.shade300,
      stringValue: Colors.green,
      numberValue: Colors.orange,
    );
  }

  factory ColorPalette._light(BuildContext context) {
    return ColorPalette._(
      selected: Theme.of(context).primaryColorLight,
      key: Theme.of(context).colorScheme.secondary,
      type: Colors.amber.shade800,
      label: Theme.of(context).colorScheme.primary,
      identifyHashCode: Colors.grey.shade800,
      nullValue: Colors.lightBlue.shade700,
      boolValue: Colors.purple.shade800,
      stringValue: Colors.green.shade800,
      numberValue: Colors.orange.shade800,
    );
  }

  static ColorPalette of(BuildContext context) {
    final theme = Theme.of(context);

    if (theme.brightness == Brightness.dark) {
      return ColorPalette.dark ??= ColorPalette._dark(context);
    }

    return ColorPalette.light ??= ColorPalette._light(context);
  }

  static Color? getColorForNodeValue(BuildContext context, Node node) {
    switch (node.kind) {
      case InstanceKind.kNull:
        return ColorPalette.of(context).nullValue;
      case InstanceKind.kBool:
        return ColorPalette.of(context).boolValue;
      case InstanceKind.kDouble:
      case InstanceKind.kInt:
        return ColorPalette.of(context).numberValue;
      case InstanceKind.kString:
        return ColorPalette.of(context).stringValue;
      default:
        return null;
    }
  }
}
