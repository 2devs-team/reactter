A light state management like React syntax.

By using `Reactter` you get:

## Features

- Use familiarized syntax such as [UseState](#UseState), [UseEffect](#UseEffect), [UseContext](#ReactterProvider-and-UseContext), [Custom hooks](#Custom-hooks) and more.
- Create custom hooks to reuse functionality.
- Reduce significantly boilerplate code.
- Improve code readability.
- Unidirectional data flow.
- An easy way to share global information in the application.

## Usage

### Create a `ReactterContext`

`ReactterContext` is a abstract class with functionality to manages hooks(like `UseState`, `UseEffect`) and lifecycle events.

You can use it's functionalities, creating a class that extends it:

```dart
class AppContext extends ReactterContext {}
```

> **RECOMMENDED:**
> Name class with `Context` suffix, for easy locatily

### Using `UseState` hook

`UseState` is a hook that allow to manage a state.

> **INFO:**
> The different with other management state is that not use `Stream`. We know that `Stream` consumes a lot of memory and we had decided to use the simple publish-subscribe pattern.

You can add it on any part of class, with context(`this`) argument(**recommended**):

```dart
class AppContext extends ReactterContext {
  late final count = UseState(0, this);
}
```

or add it on `listenHooks` method which `ReactterContext` exposes it:

```dart
class AppContext extends ReactterContext {
  final count = UseState(0);

  AppContext() {
    listenHooks([count]);
  }
}
```

> **NOTE:**
> If you add `UseState` with `context` argument, not need to add it on `listenHooks`, but is required declarate it as `late`

`UseState` exposes `value` property that helps to read and writter its state:

```dart
class AppContext extends ReactterContext {
  late final count = UseState(0, this);

  AppContext() {
    print("Prev state: ${count.value}");
    count.value = 10;
    print("Current state: ${count.value}")
  }
}
```

A `UseState` notifies that its state has changed when the previous state is different from the current state.

> **NOTE:**
> If its state is a `Object`, not detect internal changes, only when states is another `Object`.
>
> If you want to force notify, execute `update` method which `UseState` exposes it.

### Using `UseEffect` hook

`UseEffect` is a hook that allow to manage side-effect.

You can add it on constructor of class:

```dart
class AppContext extends ReactterContext {
  late final count = UseState(0, this);
  late final isOdd = UseState(false, this);

  AppContext() {
    UseEffect((){
      isOdd.value = count.value % 2 != 0;
    }, [count], this);
  }
}
```

> **NOTE:**
> If you don't add `context` argument to `UseEffect`, the `callback` don't execute on lifecycle `willMount`, and the `cleanup` don't execute on lifecycle `willUnmount`.

### Wrap with `ReactterProvider` and `UseContext`

`ReactterProvider` is a widget that helps exposes the `ReactterContext` which is defined on `UseContext`.

```dart
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reactter example',
      home: Scaffold(
        body: ReactterProvider(
          contexts: [
            UseContext(() => AppContext()),
          ],
          builder: (context, _) {
            final appContext = context.of<AppContext>();
            final count = appContext.count.value;
            final isOdd = appContext.isOdd.value;

            return Text("$count is ${isOdd ? 'odd' : 'even'}");
          },
        ),
      ),
    );
  }
}
```

> **RECOMMENDED:**
> Don't use class's constructor with parameters. Use `onInit` method which `UseContext` exposes for access its instance and putin data.

### Access to `ReactterContext`

Reactter provides additional methods to `BuildContext` for access your `ReactterContext`.

- **`context.of`**: Get the `ReactterContext`'s instance specify as type and watch for any state or states defined on first parameter for re-render widget on `BuildContext` scope.

```dart
final watchContext = context.of<WatchContext>();
final watchHooksContext = context.of<WatchHooksContext>(
  (ctx) => [ctx.stateA, ctx.stateB],
);
```

- **`context.ofId`**: Get the `ReactterContext`'s instance specify as type, with the id defined on first parameter and watch for any state or states defined on second parameter for re-render widget on `BuildContext` scope.

```dart
final watchIdContext = context.ofId<WatchIdContext>('id');
final watchHooksIdContext = context.ofId<WatchHooksIdContext>(
  'id',
  (ctx) => [ctx.stateA, ctx.stateB],
);
```

- **`context.ofStatic`**: Get the `ReactterContext`'s instance specify as type.

```dart
final readContext = context.ofStatic<ReadContext>();
```

- **`context.ofIdStatic`**: Get the `ReactterContext`'s instance specify as type, with the id defined on first parameter.

```dart
final readIdContext = context.ofIdStatic<ReadIdContext>('id');
```

### Lifecycle of `ReactterContext`

`ReactterContext` provides lifecycle methods that are invoked in different stages of the instance’s existence.

```dart
class AppContext extends ReactterContext {
  AppContext() {
    print('1. Initialized');
    onWillMount(() => print('2. Before mount'));
    onDidMount(() => print('3. Mounted'));
    onWillUpdate(() => print('4. Before update'));
    onDidUpdate(() => print('5. Updated'));
    onWillUnmount(() => print('6. Before unmounted'));
  }
}
```

1. **Initialized**: Class's constructor is the first one that is executed after the instance has been created.
2. **`onWillMount`**: This event will execute before the `ReactterProvider` will mount in the tree.
3. **`onDidMount`**: This event will execute after the `ReactterProvider` did mount in the tree.
4. **`onWillUpdate`**: This event will execute after the Widget which depend `BuildContext` that watch `ReactterContext` will update.
5. **`onDidUpdate`**: This event will execute after the Widget which depend `BuildContext` that watch `ReactterContext` did update.
6. **`onWillUnmount`**: This event will execute after the `ReactterProvider` will unmount in the tree.

> **NOTE:**
> `UseContext` has `onInit` parameter which is execute between constructor and `onWillMount`, you can use to access to instance and putin data before mount.

### Control re-render with `ReactterBuilder`

`ReactterBuilder` does the same functionality as `context.of` but isolates the widget which is affected by re-render.

```dart
ReactterProvider(
  contexts: [
    UseContext(() => AppContext),
  ],
  builder: (context, _) {
    // This builder is re-render when change stateA
    final appContextA = context.of<AppContext>(
      (appContextA) => [appContextA.stateA],
    );

    return Column(
      children: [
        Text("stateA: ${appContextA.stateA.value}"),
        ReactterBuilder<AppContext>(
          listenHooks: (appContextB) => [appContextB.stateB],
          builder: (_, appContextB, __){
            // This builder is re-render when change stateB
            return Text("stateB: ${appContextB.stateB.value}");
          },
        ),
      ],
    );
  },
)
```

### Create a `ReactterComponent`

```dart
class CounterComponent extends ReactterComponent<AppContext> {
  const CounterComponent({Key? key}) : super(key: key);

  @override
  get builder => () => AppContext();

  @override
  get id => 'uniqueId';

  @override
  listenHooks(appContext) => [appContext.stateA];

  @override
  Widget render(appContext, context) {
    return Text("StateA: ${appContext.stateA.value}");
  }
}
```

### Using `UseAsyncState` hook

```dart
class AppContext extends ReactterContext {
  late final state = UseAsyncState<String?>(null, _resolveState, this);

  AppContext() {
    _init();
  }

  Future<void> _init() async {
    // state.value = null;
    await state.resolve();
    // state.value = "state resolved by api"
  }

  Future<String> _resolveState() async {
    // api return => "state resolved by api"
    return await api.getState();
  }
}
```

```dart
ReactterProvider(
  contexts: [
    UseContext(() => AppContext()),
  ],
  builder: (context, child) {
    final appContext = context.of<AppContext>();

    return appContext.state.when(
      standby: (value) => Text("Standby: " + value),
      loading: () => const CircularProgressIndicator(),
      done: (value) => Text(value),
      error: (error) => const Text(
        "Ha ocurrido un error al completar la solicitud",
        style: TextStyle(color: Colors.red),
      ),
    );
  },
)
```

### Custom hook

```dart
class UseCount extends ReactterHook {
  final int _initial;

  late final _count = UseState(_initial, this);

  int get value => _count.value;

  UseCount(int initial, [ReactterContext? context])
      : _initial = initial,
        super(context);

  int increment() => _count.value += 1;
  int decrement() => _count.value -= 1;
}
```

```dart
class AppContext extends ReactterHook {
  late final count = UseCount(0, this);

  AppContext() {
    UseEffect(() {
      Future.delayed(
        const Duration(secounds: 1),
        count.increment,
      );
    }, [count], this);
  }
}
```

### Global state

```dart
class Global {
  static final flag = UseState(false);
  static final count = UseCount(0);

  static final Global _inst = Global._init();
  factory Global() => _inst;

  Global._init() {
    UseEffect(
      () async {
        await Future.delayed(const Duration(seconds: 1));
        doCount();
      },
      [count],
      UseEffect.dispatchEffect,
    );
  }

  static void doCount() {
    if (count.value <= 0) {
      flag.value = true;
    }

    if (count.value >= 10) {
      flag.value = false;
    }

    flag.value ? count.increment() : count.decrement();
  }
}
```

```dart
class AppContext extends ReactterContext {
  late final isOdd = UseState(false, this);

  AppContext() {
    Global(); // Alway invoke Global's factory

    UseEffect((){
      isOdd.value = Global.count.value % 2 != 0;
    }, [Global.count], this);
  }
}
```

# Roadmap

We are working in a documentation page aswell creating Youtube tutorials.

We want keeping adding features for `Reactter`, those are some we have in mind order by priority:

**V3**

- **Tests**

- Make `Reactter` easy to test.

**ReactterComponents (new package)**

- Buttons (Almost ready for release)

- App Bars

- Bottom Bars

- Snackbars

- Drawers

- Floating actions

- Modals

- Inputs

<br><br>

# WARNING

## **[Reactter](https://github.com/Leoocast/reactter)** has just left development status, you can use it in production with small applications but with caution, we are working to make it more testable and consider all possible situations of state management. The API could changes in the future due the [Roadmap](#Roadmap)

<br>

# Contribute

If you want to contribute don't hesitate to create an issue or pull-request in **[Reactter repository](https://github.com/Leoocast/reactter).**

You can:

- Add a new custom hook.

- Add a new widget.

- Add examples.

- Report bugs.

- Report situations difficult to implement.

- Report an unclear error.

- Report unclear documentation.

- Write articles or make videos teaching how to use **[Reactter](https://github.com/Leoocast/reactter)**.

Any idea is welcome!

<br><br>

# Authors

- **[Leo Castellanos](https://twitter.com/leoocast10)** - <leoocast.dev@gmail.com>

- **[Carlos León](_blank)** - <carleon.dev@gmail.com>

<br>

## Copyright (c) 2022 **[2devs.io](https://2devs.io/)**
