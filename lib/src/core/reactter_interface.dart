import 'package:flutter/foundation.dart';
import 'reactter_factory.dart';
import 'reactter_log.dart';

abstract class ReactterInterface {
  bool isLogEnable = kDebugMode;
  LogWriterCallback log = defaultLogWriterCallback;

  ReactterFactory factory = ReactterFactory();
}
