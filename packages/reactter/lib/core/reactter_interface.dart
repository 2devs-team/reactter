part of '../core.dart';

abstract class _ReactterInterface {}

class ReactterInterface extends _ReactterInterface {
  bool isLogEnable = kDebugMode;
  LogWriterCallback log = defaultLogWriterCallback;

  /// Keep in singleton the instance of [ReactterFactory] where the instances is stored.
  ReactterFactory factory = ReactterFactory();
}

final Reactter = ReactterInterface();
