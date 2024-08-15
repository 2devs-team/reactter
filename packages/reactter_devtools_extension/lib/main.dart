import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';
import 'package:reactter_devtools_extension/src/reactter_devtools_extension.dart';

void main() {
  runApp(const DevToolsExtension(child: ReactterDevtoolsExtension()));
}
