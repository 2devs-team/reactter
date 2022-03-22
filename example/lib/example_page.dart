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
        final stateOf1 = ReactterProvider.of<TestingController>(context);
        final stateOf2 = ReactterProvider.of<TestingController2>(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text("Reactter example"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  stateOf1?.text ?? 'No funca',
                ),
                Text(
                  stateOf2?.text ?? "No funca",
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
