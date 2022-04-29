import 'package:example/testing_cases/use_async_example.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';

void main() {
  enableFlutterDriverExtension();

  runApp(
    const MaterialApp(
      home: UseFutureExample(),
    ),
  );
}
