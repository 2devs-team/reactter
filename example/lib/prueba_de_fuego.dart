import 'package:flutter/material.dart';
import 'package:reactter/presentation/reactter_context.dart';
import 'package:reactter/reactter.dart';

import 'example_page.dart';

class PruebaDeFuego extends StatelessWidget {
  const PruebaDeFuego({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("test")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("No me renderizo"),
            Builder(builder: (context) {
              return Text("Yo si y me vae pito");
            }),
            UseBuilder(builder: (context, _, __) {
              return ElevatedButton(
                onPressed: () {
                  context.$<WatfContext>().onPressed();
                },
                child: const Text("Test"),
              );
            })
          ],
        ),
      ),
    );
  }
}
