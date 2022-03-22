import 'package:example/example_page.dart';
import 'package:flutter/material.dart';
import 'package:reactter/presentation/reactter_create_context.dart';
import 'package:reactter/reactter.dart';
import 'example_dispose_2.dart';

class ExampleDispose extends ReactterComponent<TestingController> {
  const ExampleDispose({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dispose view 1"),
      ),
      body: CreateContext(
        controllers: [
          ContextProvider<TestingController>(
            () => TestingController("Instancia 1"),
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
                style: TextStyle(fontSize: 30),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ExampleDispose2()));
                },
                child: const Text("Go to example 2"),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: state.changeText,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
