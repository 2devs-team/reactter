import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_reactter/src/widgets.dart';
import 'package:meta/meta.dart';
import 'package:reactter/reactter.dart' hide Reactter;
import 'package:reactter/reactter.dart' as r show Reactter;
import 'extensions.dart';
import 'types.dart';

part 'framework/provider_base.dart';
part 'framework/provider_impl.dart';
part 'framework/dependency.dart';
part 'framework/nested.dart';
part 'framework/scope_element_mixin.dart';
part 'framework/wrapper.dart';

// ignore: non_constant_identifier_names
final Reactter = r.Reactter..isLogEnable = kDebugMode;
