part of '../core.dart';

class ReactterInterface {
  bool isLogEnable = kDebugMode;
  LogWriterCallback log = defaultLogWriterCallback;

  ReactterFactory factory = ReactterFactory();
}

/// Keep in singleton the instance of [ReactterFactory] where the instances is stored.
final Reactter = ReactterInterface();
