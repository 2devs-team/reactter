export 'package:reactter/reactter.dart' hide Rt;
import 'package:flutter/foundation.dart';
import 'package:reactter/reactter.dart' as r show Rt;

// ignore: non_constant_identifier_names
final Rt = r.Rt..isLogEnable = kDebugMode;
