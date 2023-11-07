// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:collection';
import 'dart:developer' as dev;

import 'package:meta/meta.dart';

import 'lifecycle.dart';
import 'types.dart';

part 'framework/reactter_event_manager.dart';
part 'framework/reactter_hook.dart';
part 'framework/reactter_instance_manager.dart';
part 'framework/reactter_instance.dart';
part 'framework/reactter_interface.dart';
part 'framework/reactter_logger.dart';
part 'framework/reactter_notifier.dart';
part 'framework/reactter_state.dart';
part 'framework/reactter_zone.dart';

final Reactter = ReactterInterface();
