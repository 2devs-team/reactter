part of '../framework.dart';

/// Logger
void defaultLogWriterCallback(String value, {bool isError = false}) {
  if (Reactter.isLogEnable || isError) dev.log(value, name: 'REACTTER');
}

extension ReactterLogShortcuts on ReactterInterface {
  /// It's used to determine whether logging is enabled or disabled.
  static bool _isLogEnable = true;
  bool get isLogEnable => _isLogEnable;
  set isLogEnable(bool value) => _isLogEnable = value;

  /// It's used as a callback function for logging purposes in
  /// the `ReactterInterface` class.
  static LogWriterCallback _logCallback = defaultLogWriterCallback;
  LogWriterCallback get log => _logCallback;
  set log(LogWriterCallback value) => _logCallback = value;
}
