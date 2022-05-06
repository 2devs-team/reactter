// ignore_for_file: avoid_print
import 'package:example/testing_cases/reactter_id_example.dart';
import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';

class AppContext extends ReactterContext {
  late final counter = UseState<int>(0, context: this);

  late final counterByTwo = UseState<int>(0, context: this);

  AppContext() {
    UseEffect(() {
      counterByTwo.value = counter.value * 2;
    }, [counter]);
  }

  increment() => counter.value = counter.value + 1;

  reset() => counter.reset();
}

class ReactterExample extends StatelessWidget {
  const ReactterExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UseProvider(
      contexts: [
        UseContext(
          () => AppContext(),
          init: true,
        ),
        UseContext(
          () => AppContext(),
          init: true,
        ),
      ],
      builder: (context, _) {
        print("Render");

        final appContext = context.of<AppContext>();

        return Scaffold(
          appBar: AppBar(
            title: const Text("Reactter"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Counter value * 2: ${appContext.counterByTwo.value}"),
                const SizedBox(height: 12),
                Text("Counter value: " + appContext.counter.value.toString()),
              ],
            ),
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 15),
                child: FloatingActionButton(
                  key: const Key(
                    //Testing porpuses, Reactter don't need it.
                    'resetButton',
                  ),
                  backgroundColor: Colors.red.shade800,
                  child: const Icon(Icons.clear),
                  onPressed: appContext.reset,
                ),
              ),
              FloatingActionButton(
                key: const Key(
                  //Testing porpuses, Reactter don't need it.
                  'addButton',
                ),
                child: const Icon(Icons.add),
                onPressed: appContext.increment,
              ),
            ],
          ),
        );
      },
    );
  }
}

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ReactterIdExample(),
    );
  }
}
