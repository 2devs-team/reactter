import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';

import 'app_controller.dart';

class ExamplePage extends ReactterComponent<AppController> {
  const ExamplePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(AppController());

    // ReactterFactory().register<AppController>(() => AppController());

    final constructors = ReactterFactory().constructors;

    // print(ReactterFactory().isRegistered<AppController>());
    // final instance = ReactterFactory().getInstance<AppController>();

    // final newInstance = ReactterFactory().getInstance<AppController>();

    final test = "";
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
            Render<AppController>(
              builder: (controller) {
                return Text(
                  0.toString(),
                  style: Theme.of(context).textTheme.headline4,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: state.onClick,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
