part of '../core.dart';

class ReactterInterface {
  bool isLogEnable = kDebugMode;
  LogWriterCallback log = defaultLogWriterCallback;

  /// Keep in singleton the instance of [ReactterFactory] where the instances is stored.
  ReactterFactory factory = ReactterFactory();
}

final Reactter = ReactterInterface();
