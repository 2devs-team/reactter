import 'dart:developer' as developer;
import 'package:reactter/engine/reactter_interface_instance.dart';

///VoidCallback from logs
typedef LogWriterCallback = void Function(String text, {bool isError});

///Logger
void defaultLogWriterCallback(String value, {bool isError = false}) {
  if (isError || Reactter.isLogEnable) developer.log(value, name: 'REACTTER');
}
