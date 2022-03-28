import 'package:flutter/material.dart';

import 'testing_cases/use_effect_escenary.dart';

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
      // home: NestedUseProvider(),
      home: UseEffectExample(),
    );
  }
}
