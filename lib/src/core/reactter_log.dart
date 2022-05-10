import 'dart:developer' as developer;
import '../engine/reactter_interface_instance.dart';

/// Logger
void defaultLogWriterCallback(String value, {bool isError = false}) {
  if (isError || Reactter.isLogEnable) developer.log(value, name: 'REACTTER');
}
