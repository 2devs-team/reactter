part of '../core.dart';

/// Logger
void defaultLogWriterCallback(String value, {bool isError = false}) {
  if (isError || Reactter.isLogEnable) dev.log(value, name: 'REACTTER');
}
