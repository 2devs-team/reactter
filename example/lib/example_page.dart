import 'package:example/prueba_de_fuego.dart';
import 'package:flutter/material.dart';
import 'package:reactter/presentation/reactter_context.dart';
import 'package:reactter/reactter.dart';

class Global {
  static final x = UseState<String?>("Estado inicial", alwayUpdate: true);
}

class WatfContext extends ReactterContext {
  String text = "Texto original 1";

  final y = UseState<String?>("Texto chidori", alwayUpdate: true);

  UseState<String?> get refx => Global.x;

  WatfContext() {
    renderWhenStateChanged([Global.x, y, pruebaDeFuego]);
  }

  final pruebaDeFuego = UseState<String?>("Texto inicial", alwayUpdate: true);

  onPressed() {
    pruebaDeFuego.value = "COSSSMICOOOOOOOOOOOOO";
    print("Que peo?");
    print(pruebaDeFuego.value);
  }

  onPressed2() {
    Global.x.value = "Estado final";
  }
}

class Testing2Context extends ReactterContext {
  String text = "Texto original 2";

  UseState<String?> get refx => Global.x;

  Testing2Context() {
    renderWhenStateChanged([Global.x]);
  }
}

class ExamplePage extends StatelessWidget {
  const ExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _) {
    return UseProvider(
      contexts: [
        UseContext(
          () => WatfContext(),
          init: true,
        ),
        UseContext(
          () => Testing2Context(),
          init: true,
        ),
      ],
      builder: (A, __) {
        // final stateOf1 = ReactterProvider.getContext<TestingContext>(context);
        // final stateOf2 = ReactterProvider.getContext<Testing2Context>(context);
        // context.$<WatfContext>().x.value;

        print("REBUILD CONTEXT");

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
                    UseBuilder(
                      child: const Text(""),
                      builder: (B, _, newChild) {
                        print("REBUILD BUILDER");
                        final cons =
                            B.$<WatfContext>((inst) => [inst.pruebaDeFuego]);
                        return Column(
                          children: [
                            Text(cons.pruebaDeFuego.value ?? 'NULL'),
                            newChild ?? Container()
                          ],
                        );
                      },
                    ),
                    // UseBuilder(builder: (context, _, __) {
                    //   final cons =
                    //       context.$<Testing2Context>((inst) => [Global.x]);
                    //   print('render part B');
                    //   return Text(cons.refx.value ?? 'NULL');
                    // }),
                    // Text(context.$<WatfContext>().y.value ?? 'NULL'),
                  ],
                ),

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
                    // A.$<WatfContext>().onPressed();
                    Navigator.push(
                        A,
                        MaterialPageRoute(
                            builder: (context) => const PruebaDeFuego()));
                  },
                  child: const Text("Go to example 1"),
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              A.$<WatfContext>().onPressed();
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        );
      },
    );
  }
}
