import 'package:examples/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

Future<void> main() async {
  Rt.initializeDebugging();
  runApp(const MyApp());
}
