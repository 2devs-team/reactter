// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';

class AppContext extends ReactterContext {
  late final data = UseState<String>("", this);

  late final counter = UseState<int>(5, this);

  AppContext([String data = "Default"]) {
    this.data.value = data;
  }

  increment() {
    counter.value = counter.value + 1;
  }

  reset() => counter.reset();
}

class ReactterIdExample extends StatelessWidget {
  const ReactterIdExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactterProvider(
      contexts: [
        UseContext(
          () => AppContext(),
          init: true,
        ),
        UseContext(
          () => AppContext(),
          init: true,
          id: "id_test_1",
        ),
        UseContext(
          () => AppContext("Change by id_test_2"),
          init: true,
          id: "id_test_2",
        ),
        UseContext(
          () => AppContext("Change by create contructor"),
          init: true,
          id: "new_builder",
        ),
      ],
      child: Row(
        children: const [],
      ),
      builder: (context, _) {
        print("Render");

        final mainContext = context.ofStatic<AppContext>();

        // final idTest1 = context.ofId<AppContext>("id_test_1");

        // final idTest2 = context.ofId<AppContext>("id_test_2");
        // final newBuilder = context.ofId<AppContext>("new_builder");

        return Scaffold(
          appBar: AppBar(
            title: const Text("Reactter"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Global",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("data: ${mainContext.data.value}"),
                Text("counter: ${mainContext.counter.value}"),
                // const SizedBox(height: 15),
                // const Text(
                //   "id_test_1",
                //   style: TextStyle(fontWeight: FontWeight.bold),
                // ),
                // Text("data: ${idTest1.data.value}"),
                // Text("counter: ${idTest1.counter.value}"),
                // const SizedBox(height: 15),
                // const Text(
                //   "id_test_2",
                //   style: TextStyle(fontWeight: FontWeight.bold),
                // ),
                // Text("data: ${idTest2.data.value}"),
                // Text("counter: ${idTest2.counter.value}"),
                // const SizedBox(height: 15),
                // const Text(
                //   "new_builder",
                //   style: TextStyle(fontWeight: FontWeight.bold),
                // ),
                // Text("data: ${newBuilder.data.value}"),
                // Text("counter: ${newBuilder.counter.value}"),
                // const SizedBox(height: 15),
              ],
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Global"),
                    Row(
                      children: [
                        FloatingActionButton(
                          backgroundColor: Colors.red.shade800,
                          onPressed: mainContext.reset,
                          mini: true,
                          child: const Icon(Icons.clear),
                        ),
                        FloatingActionButton(
                          onPressed: mainContext.increment,
                          mini: true,
                          child: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                ),
                // Column(
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                //     const Text("id_test_1"),
                //     Row(
                //       children: [
                //         FloatingActionButton(
                //           backgroundColor: Colors.red.shade800,
                //           child: const Icon(Icons.clear),
                //           onPressed: idTest1.reset,
                //           mini: true,
                //         ),
                //         FloatingActionButton(
                //           child: const Icon(Icons.add),
                //           onPressed: idTest1.increment,
                //           mini: true,
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
                // Column(
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                //     const Text("id_test_2"),
                //     Row(
                //       children: [
                //         FloatingActionButton(
                //           backgroundColor: Colors.red.shade800,
                //           child: const Icon(Icons.clear),
                //           onPressed: idTest2.reset,
                //           mini: true,
                //         ),
                //         FloatingActionButton(
                //           child: const Icon(Icons.add),
                //           onPressed: idTest2.increment,
                //           mini: true,
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
                // Column(
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                //     const Text("new_builder"),
                //     Row(
                //       children: [
                //         FloatingActionButton(
                //           backgroundColor: Colors.red.shade800,
                //           child: const Icon(Icons.clear),
                //           onPressed: newBuilder.reset,
                //           mini: true,
                //         ),
                //         FloatingActionButton(
                //           child: const Icon(Icons.add),
                //           onPressed: newBuilder.increment,
                //           mini: true,
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
