import 'package:flutter/material.dart';
import 'package:reactter/presentation/reactter_context.dart';
import 'package:reactter/presentation/reactter_use_context.dart';
import 'package:reactter/presentation/reactter_use_provider.dart';

class WatfContext {
  String text = "Texto original 1";

  WatfContext();
}

class Testing2Context {
  String text = "Texto original 2";

  Testing2Context();
}

class ExamplePage extends StatelessWidget {
  const ExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactterProvider(
      contexts: [
        ReactterContext<WatfContext>(
          () => WatfContext(),
          init: true,
        ),
        ReactterContext<Testing2Context>(
          () => Testing2Context(),
          init: true,
        ),
      ],
      builder: (context) {
        // final stateOf1 = ReactterProvider.getContext<TestingContext>(context);
        // final stateOf2 = ReactterProvider.getContext<Testing2Context>(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text("Reactter example"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Text(
                //   stateOf1?.text ?? 'No funca',
                // ),
                // Text(
                //   stateOf2?.text ?? "No funca",
                // ),
                UseProvider(builder: (_, contextOf) {
                  return Column(
                    children: [
                      Text(contextOf<WatfContext>().text),
                      Text(contextOf<Testing2Context>().text),
                    ],
                  );
                }),
                UseContext<WatfContext>(
                  builder: (context, instance) {
                    final test = instance as WatfContext;
                    return Text(instance.text);
                  },
                ),
                ElevatedButton(
                  onPressed: () {},
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
