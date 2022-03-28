import 'package:example/testing_cases/use_provider_inside_use_provider.dart';
import 'package:flutter/material.dart';

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
      home: UseProviderInsideUseProviderTest(),
    );
  }
}
