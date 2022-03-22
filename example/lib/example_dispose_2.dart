import 'package:flutter/material.dart';
import 'package:reactter/presentation/reactter_create_context.dart';
import 'package:reactter/reactter.dart';

import 'app_controller.dart';

class ExampleDispose2 extends ReactterComponent<AppController> {
  const ExampleDispose2({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reactter example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              state.textToShow.value,
            ),
          ],
        ),
      ),
      // body: CreateContext(
      //   controllers: [
      //     ContextProvider<AppController>(() => AppController(), init: true)
      //   ],
      //   child: Center(
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: <Widget>[
      //         Text(
      //           state.textToShow.value,
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
