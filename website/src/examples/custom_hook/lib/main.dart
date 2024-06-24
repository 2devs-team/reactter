import 'package:flutter/material.dart';
import 'my_custom_form.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyCustomForm(),
    );
  }
}
