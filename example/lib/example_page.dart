import 'package:flutter/material.dart';
import 'package:reactter/core/reaccter_use_effect.dart';
import 'package:reactter/reactter.dart';

import 'app_controller.dart';

class ExamplePage extends ReactterView<AppController> {
  const ExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AppController());

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
            UseEffect<AppController>(
              builder: (controller) {
                return Text(
                  controller.counter.value.toString(),
                  style: Theme.of(context).textTheme.headline4,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.onClick,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
