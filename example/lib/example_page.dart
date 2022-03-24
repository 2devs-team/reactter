import 'package:flutter/material.dart';
import 'package:reactter/presentation/reactter_context.dart';
import 'package:reactter/reactter.dart';

class Global {
  static final x = UseState<String?>(null, alwayUpdate: true);
}

class WatfContext extends ReactterStates {
  String text = "Texto original 1";

  final y = UseState<String?>(null, alwayUpdate: true);

  UseState<String?> get refx => Global.x;

  WatfContext() {
    renderWhenStateChanged([Global.x, y]);
  }

  onPressed() {
    Global.x.value = 'New text';
  }

  onPressed2() {
    y.value = 'New text y';
  }
}

class Testing2Context extends ReactterStates {
  String text = "Texto original 2";

  UseState<String?> get refx => Global.x;

  Testing2Context() {
    renderWhenStateChanged([Global.x]);
  }
}

class ExamplePage extends StatelessWidget {
  const ExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactterProvider(
      contexts: [
        ReactterContext(
          () => WatfContext(),
          init: true,
        ),
        ReactterContext(
          () => Testing2Context(),
          init: true,
        ),
      ],
      builder: (context, _) {
        // final stateOf1 = ReactterProvider.getContext<TestingContext>(context);
        // final stateOf2 = ReactterProvider.getContext<Testing2Context>(context);
        // context.$<WatfContext>().x.value;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Reactter example"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: [
                    ReactterConsumer(builder: (context, _, __) {
                      final cons = context.$<WatfContext>((inst) => [Global.x]);
                      print('render part A');
                      return Text(cons.refx.value ?? 'NULL');
                    }),
                    ReactterConsumer(builder: (context, _, __) {
                      final cons =
                          context.$<Testing2Context>((inst) => [Global.x]);
                      print('render part B');
                      return Text(cons.refx.value ?? 'NULL');
                    }),
                    Text(context.$<WatfContext>().y.value ?? 'NULL'),
                  ],
                ),
                Builder(builder: (context) {
                  // print('render part B');
                  return Text('NULL');
                }),
                // Text(
                //   stateOf1?.text ?? 'No funca',
                // ),
                // Text(
                //   stateOf2?.text ?? "No funca",
                // ),
                // UseProvider(builder: (_, contextOf) {
                //   return Column(
                //     children: [
                //       Text(contextOf<WatfContext>().text),
                //       Text(contextOf<Testing2Context>().text),
                //     ],
                //   );
                // }),
                // UseContext<WatfContext>(
                //   builder: (context, instance) {
                //     final test = instance as WatfContext;
                //     return Text(instance.text);
                //   },
                // ),
                ElevatedButton(
                  onPressed: () {
                    context.$<WatfContext>().onPressed();
                  },
                  child: const Text("Go to example 1"),
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.$<WatfContext>().onPressed2();
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        );
      },
    );
  }
}
