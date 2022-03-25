import 'package:example/prueba_de_fuego.dart';
import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';

class Global {
  static final x = UseState<String?>("Estado inicial", alwayUpdate: true);
}

class ClassA extends ReactterContext {
  String text = "Texto original 1";

  late final y =
      UseState<String?>("Texto chidori", alwayUpdate: true, context: this);

  UseState<String?> get refx => Global.x;

  ClassA() {
    UseEffect(
      () {
        // do anything
      },
      [Global.x, y],
      this,
    );

    listenHooks([
      Global.x,
      pruebaDeFuego,
    ]);
  }

  final pruebaDeFuego = UseState<String?>("Texto inicial", alwayUpdate: true);

  onPressed() {
    pruebaDeFuego.value = "COSSSMICOOOOOOOOOOOOO";
    y.value = "Estado final";
    print("Que peo?");
    print(pruebaDeFuego.value);
  }

  onPressed2() {
    Global.x.value = "Estado final";
  }
}

class ClassB extends ReactterContext {
  String text = "Texto original 2";

  UseState<String?> get refx => Global.x;

  ClassB() {
    listenHooks([Global.x]);
  }
}

class ExamplePage extends StatelessWidget {
  const ExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _) {
    return UseProvider(
      contexts: [
        UseContext(
          () => ClassA(),
          init: true,
        ),
        UseContext(
          () => ClassB(),
          init: true,
        ),
      ],
      builder: (contextA, __) {
        print("Rebuild contextA");

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
                      builder: (contextB, _, newChild) {
                        print("Rebuild contextB");
                        final cons =
                            contextB.$<ClassA>((inst) => [inst.pruebaDeFuego]);
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
                    Builder(builder: (contextC) {
                      print("Rebuild contextC");
                      return Text(contextA.$<ClassA>().y.value ?? 'NULL');
                    }),
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
                      contextA,
                      MaterialPageRoute(
                        builder: (context) => const PruebaDeFuego(),
                      ),
                    );
                  },
                  child: const Text("Go to example 1"),
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              contextA.$$<ClassA>().onPressed();
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        );
      },
    );
  }
}
