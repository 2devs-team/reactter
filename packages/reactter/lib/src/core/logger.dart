part of '../internals.dart';

enum LogLevel { info, warning, error }

@internal
abstract class Logger {
  /// It's used to determine whether logging is enabled or disabled.
  bool isLogEnable = true;

  /// It's used as a callback function for logging purposes in
  /// the [RtInterface] class.
  LogWriterCallback get log;
}
