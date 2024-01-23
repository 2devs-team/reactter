part of 'core.dart';

void defaultLogWriterCallback(String value, {bool isError = false}) {
  if (Reactter.isLogEnable || isError) dev.log(value, name: 'REACTTER');
}

@internal
abstract class Logger {
  /// It's used to determine whether logging is enabled or disabled.
  bool isLogEnable = true;

  /// It's used as a callback function for logging purposes in
  /// the `ReactterInterface` class.
  LogWriterCallback log = defaultLogWriterCallback;
}
