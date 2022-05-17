import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';

class AppContext extends ReactterContext {
  late final counter = UseState<int>(0, this);

  late final counterByTwo = UseState<int>(0, this);

  late final theme = UseState<String>('light', this);

  AppContext() {
    UseEffect(() {
      counterByTwo.value = counter.value * 2;
    }, [counter]);
  }

  increment() {
    counter.value = counter.value + 1;
    theme.value = theme.value == 'dark' ? 'light' : 'dark';
  }

  reset() => counter.reset();
}

class CounterComponent extends ReactterComponent<AppContext> {
  const CounterComponent({Key? key}) : super(key: key);

  @override
  get builder => () => AppContext();

  @override
  get id => 'test';

  @override
  listenHooks(ctx) {
    return [ctx.theme];
  }

  @override
  Widget render(ctx, context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Counter value * 2: ${ctx.counterByTwo.value}"),
        const SizedBox(height: 12),
        Text("Counter value: ${ctx.counter.value}"),
      ],
    );
  }
}

class ReactterComponentTest extends StatelessWidget {
  const ReactterComponentTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactterProvider(
      contexts: [
        UseContext(() => AppContext(), id: 'test'),
      ],
      builder: (context, _) {
        final appContext =
            context.ofId<AppContext>('test', (ctx) => [ctx.theme]);

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
                  onPressed: appContext.reset,
                  child: const Icon(Icons.clear),
                ),
              ),
              FloatingActionButton(
                key: const Key(
                  //Testing porpuses, Reactter don't need it.
                  'addButton',
                ),
                onPressed: appContext.increment,
                child: const Icon(Icons.add),
              ),
            ],
          ),
        );
      },
    );
  }
}
