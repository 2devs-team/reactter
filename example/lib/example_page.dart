import 'package:example/example_dispose.dart';
import 'package:flutter/material.dart';
import 'package:reactter/presentation/reactter_context.dart';

class TestingController {
  String text = "Texto original 1";

  TestingController();
}

class TestingController2 {
  String text = "Texto original 2";

  TestingController2();
}

class ExamplePage extends StatelessWidget {
  const ExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactterProvider(
      controllers: [
        ReactterController<TestingController>(
          () => TestingController(),
          init: true,
        ),
        ReactterController<TestingController2>(
          () => TestingController2(),
          init: true,
        ),
      ],
      builder: (context) {
        final controllersStates =
            ReactterProvider.of<TestingController>(context);

        final stateOf1 = controllersStates?[0].instance as TestingController;
        final stateOf2 = controllersStates?[1].instance as TestingController2;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Reactter example"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  stateOf1.text,
                ),
                Text(
                  stateOf2.text,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ExampleDispose(),
                      ),
                    );
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
      },
    );
  }
}
