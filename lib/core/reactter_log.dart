import 'dart:developer' as developer;
import 'package:reactter/reactter.dart';

///VoidCallback from logs
typedef LogWriterCallback = void Function(String text, {bool isError});

/// default logger from GetX
void defaultLogWriterCallback(String value, {bool isError = false}) {
  if (isError || Reactter.isLogEnable) developer.log(value, name: 'REACTTER');
}
