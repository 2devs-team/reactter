import 'package:example/app_controller.dart';
import 'package:example/test_leo/test_leo_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactter/presentation/reactter_create_context.dart';
import 'example_page.dart';
import 'package:reactter/reactter.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: ExamplePage(),
      home: TestLeoView(),
    );
  }
}
