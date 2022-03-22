import 'package:example/example_page.dart';
import 'package:flutter/material.dart';
import 'package:reactter/presentation/reactter_create_context.dart';
import 'package:reactter/reactter.dart';

class ExampleDispose2 extends ReactterComponent<TestingController> {
  const ExampleDispose2({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reactter example"),
      ),
      body: CreateContext(
        controllers: [
          ContextProvider<TestingController>(
            () => TestingController("Instancia 2"),
            init: true,
            create: true,
          )
        ],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                state.text,
                style: const TextStyle(fontSize: 30),
              ),
            ],
          ),
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
