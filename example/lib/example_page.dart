import 'package:example/example_dispose.dart';
import 'package:flutter/material.dart';
import 'package:reactter/core/reactter_factory.dart';
import 'package:reactter/presentation/reactter_component.dart';
import 'package:reactter/presentation/reactter_render.dart';
import 'package:reactter/reactter.dart';

import 'app_controller.dart';

class ExamplePage extends StatelessWidget {
  const ExamplePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // ReactterFactory().register<AppController>(() => AppController());

    // final constructors = ReactterFactory().constructors;

    // print(ReactterFactory().isRegistered<AppController>());
    // final instance = ReactterFactory().getInstance<AppController>();

    // final newInstance = ReactterFactory().getInstance<AppController>();

    // final test = "";
    // final counterValue = instance?.counter.value ?? 50;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reactter example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ExampleDispose()));
              },
              child: const Text("Go to example 1"),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
