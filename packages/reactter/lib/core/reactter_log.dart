part of '../core.dart';

/// Logger
void defaultLogWriterCallback(String value, {bool isError = false}) {
  if (isError || Reactter.isLogEnable) log(value, name: 'REACTTER');
}
