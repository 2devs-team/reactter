import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';

class AppContext extends ReactterContext {
  late final counter = UseState<int>(0, context: this);

  late final counterByTwo = UseState<int>(0, context: this);

  late final theme =
      UseState<String>('Light', context: this, alwaysUpdate: true);

  AppContext() {
    UseEffect(() {
      counterByTwo.value = counter.value * 2;
    }, [counter]);
  }

  increment() {
    counter.value = counter.value + 1;
  }

  reset() => counter.reset();
}

class CounterComponent extends ReactterComponent<AppContext> {
  const CounterComponent({Key? key}) : super(key: key);

  @override
  listen(ctx) {
    return [ctx.theme];
  }

  @override
  Widget render(ctx) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Counter value * 2: ${ctx.counterByTwo.value}"),
        const SizedBox(height: 12),
        Text("Counter value: " + ctx.counter.value.toString()),
      ],
    );
  }
}

class ReactterComponentTest extends StatelessWidget {
  const ReactterComponentTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UseProvider(
      contexts: [
        UseContext(
          () => AppContext(),
          init: true,
        ),
      ],
      builder: (context, _) {
        final appContext = context.of<AppContext>((ctx) => [ctx.theme]);

        return Scaffold(
          appBar: AppBar(
            title: const Text("Reactter"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CounterComponent(),
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
