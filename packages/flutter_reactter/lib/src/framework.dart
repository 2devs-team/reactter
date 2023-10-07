import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:reactter/reactter.dart' hide Reactter;
import 'package:reactter/reactter.dart' as r show Reactter;

part 'framework/reactter_dependency.dart';
part 'framework/reactter_nested.dart';
part 'framework/reactter_scope.dart';
part 'framework/reactter_wrapper.dart';

// ignore: non_constant_identifier_names
final Reactter = r.Reactter..isLogEnable = kDebugMode;
