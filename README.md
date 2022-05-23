<p align="center">
<img src="https://raw.githubusercontent.com/Leoocast/reactter/documentation/assets/reactter_logo_full.png" height="100" alt="Reactter" />
</p>

**A light, powerful and reactive state management.**

By using `Reactter` you get:

## Features

- Use familiarized React syntax such as [UseState](#UseState), [UseEffect](#UseEffect), [UseContext](#ReactterProvider-and-UseContext), [Custom hooks](#Custom-hooks) and more.
- Create custom hooks to reuse functionality.
- Reduce significantly boilerplate code.
- Improve code readability.
- Unidirectional data flow.
- An easy way to share global information in the application.
- Control re-render widget tree.

## Usage

### Create a `ReactterContext`

`ReactterContext` is a abstract class with functionality to manages hooks(like `UseState`, `UseEffect`) and lifecycle events.

You can use it's functionalities, creating a class that extends it:

```dart
class AppContext extends ReactterContext {}
```

> **RECOMMENDED:**
> Name class with `Context` suffix, for easy locatily.

### Using `UseState` hook

`UseState` is a hook that allow to manage a state.

> **INFO:**
> The different with other management state is that not use `Stream`. We know that `Stream` consumes a lot of memory and we had decided to use the simple publish-subscribe pattern.

You can add it on any part of class, with context(`this`) argument(**RECOMMENDED**):

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
> If you add `UseState` with `context` argument, not need to add it on `listenHooks`, but is required declarate it as `late`.

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
> **NOTE:**
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
>
> **NOTE:**
> If you want to execute a `UseEffect` immediately, use `UseEffect.dispatchEffect` instead of the `context` argument.

### Wrap with `ReactterProvider` and `UseContext`

`ReactterProvider` is a widget that helps exposes the `ReactterContext` that are defined using `UseContext` on `contexts` parameter.

```dart
class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactterProvider(
      contexts: [
        UseContext(
          () => AppContext(),
        ),
        UseContext(
          () => ConfigContext(),
          id: 'App',
          onInit: (appConfigContext) {
            appConfigContext.config.value = 'new state';
          },
        ),
        UseContext(
          () => ConfigContext(),
          id: 'User'
        ),
      ],
      builder: (context, _) {
        final appContext = context.of<AppContext>();
        final appConfigContext = context.ofId<ConfigContext>('App');
        final userConfigContext = context.ofId<ConfigContext>('User');

        return [...]
      },
    );
  }
}
```

> **RECOMMENDED:**
> Don't use `ReactterContext` class with parameters to prevent conflicts. Instead of it, use `onInit` method which `UseContext` exposes for access its instance and put the data you need.
>
> **NOTE:**
> You can use `id` parameter of `UseContext` for create a different instance of same `ReactterContext` class.

### Access to `ReactterContext`

Reactter provides additional methods to `BuildContext` for access your `ReactterContext`. These are:

- **`context.of<T>`**: Get the `ReactterContext` instance of the specified type and watch context's states or states defined on first parameter to control the widget re-render within the `BuildContext` scope.

```dart
final watchContext = context.of<WatchContext>();
final watchHooksContext = context.of<WatchHooksContext>(
  (ctx) => [ctx.stateA, ctx.stateB],
);
```

- **`context.ofId<T>`**: Get the `ReactterContext` instance of the specified type and id defined on first parameter and watch context's states or states defined on second parameter to control the widget re-render within the `BuildContext` scope.

```dart
final watchIdContext = context.ofId<WatchIdContext>('id');
final watchHooksIdContext = context.ofId<WatchHooksIdContext>(
  'id',
  (ctx) => [ctx.stateA, ctx.stateB],
);
```

- **`context.ofStatic<T>`**: Get the `ReactterContext` instance of the specified type.

```dart
final readContext = context.ofStatic<ReadContext>();
```

- **`context.ofIdStatic<T>`**: Get the `ReactterContext` instance of the specified type and id defined on first parameter.

```dart
final readIdContext = context.ofIdStatic<ReadIdContext>('id');
```

> **NOTE:**
> These methods mentioned above uses `ReactterProvider.contextOf<T>`

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
2. **`onWillMount`**: Will trigger before the `ReactterContext` instance will mount in the tree by `ReactterProvider`.
3. **`onDidMount`**: Will trigger after the `ReactterContext` instance did mount in the tree by `ReactterProvider`.
4. **`onWillUpdate`**: Will trigger before the `ReactterContext` instance will update by any `ReactterHook`.
5. **`onDidUpdate`**: Will trigger after the `ReactterContext` instance did update by any `ReactterHook`.
6. **`onWillUnmount`**: Will trigger before the `ReactterContext` instance will unmount in the tree by `ReactterProvider`.

> **NOTE:**
> `UseContext` has `onInit` parameter which is execute between constructor and `onWillMount`, you can use to access to instance and putin data before mount.

### Control re-render with `ReactterBuilder`

`ReactterBuilder` has the same functionality as `context.of[...]` but isolates the widget which is affected by re-render.

```dart
ReactterProvider(
  contexts: [
    UseContext(() => AppContext()),
  ],
  builder: (context, child) {
    // This builder is re-render when change stateA
    final appContextA = context.of<AppContext>(
      (appContextA) => [appContextA.stateA],
    );

    return Column(
      children: [
        Text("stateA: ${appContextA.stateA.value}"),
        ReactterBuilder<AppContext>(
          listenHooks: (appContextB) => [appContextB.stateB],
          builder: (appContextB, _, __){
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

`ReactterComponent` is a `StatelessWidget` class that wrap `render` with `ReactterProvider` and `UseContext`.

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

`UseAsyncState` is a hook with the same functionality as `UseState` but providing a `asyncValue` which it will be obtain when execute `resolve` method.

This is a example:

```dart
class AppContext extends ReactterContext {
  late final state = UseAsyncState<String?, Data>(null, _resolveState, this);

  AppContext() {
    _init();
  }

  Future<void> _init() async {
    await state.resolve(Data(prop: true, prop2: "test"));
    print("State resolved with: ${state.value}");
  }

  Future<String> _resolveState([Data arg]) async {
    return await api.getState(arg.prop, arg.prop2);
  }
}
```

> **NOTE:**
> If you want send argument to `asyncValue` method, need to defined a type arg which its send from `resolve` method. Like example shown above, which type argument send is `Data` class.

`UseAsyncState` provides `when` method, which can be used for get a widget depending of it's state, like that:

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

For create a custom hook, you should be crear a class that extends of `ReactterHook`.

This is a example:

```dart
class UseCount extends ReactterHook {
  bool _count = 0;

  int get value => _count;

  UseCount(int initial, [ReactterContext? context])
      : _count = initial,
        super(context);

  int increment() => update(() => _count += 1);
  int decrement() => update(() => _count -= 1);
}
```

> **RECOMMENDED:**
> Name class with `Use` preffix, for easy locatily.
>
> **NOTE:**
> `ReactterHook` provides `update` method which notify to `context` that has changed.

and use it like that:

```dart
class AppContext extends ReactterContext {
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

The reactter's hooks can be defined as static for access its as global way:

```dart
class Global {
  static final flag = UseState(false);
  static final count = UseCount(0);

  // Create a class factory for run it as singleton way.
  // This way, the initial logic can be executed.
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

This is a example that how you could use it:

```dart
class AppContext extends ReactterContext {
  late final isOdd = UseState(false, this);

  AppContext() {
    // It's need to instance it for can execute Global._init
    Global();

    UseEffect((){
      isOdd.value = Global.count.value % 2 != 0;
    }, [Global.count], this);
  }
}
```

> **NOTE:**
> If you want to execute some logic when initialize the global class you need to use the class factory and then instance it to run as singleton way.

## Roadmap

We want keeping adding features for `Reactter`, those are some we have in mind order by priority:

### V3

- Async context.
- Make `Reactter` easy for debugging.
- Structure proposal for large projects.
- Improve performance and do benchmark.

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

# Authors

- **[Leo Castellanos](https://twitter.com/leoocast10)** - <leoocast.dev@gmail.com>

- **[Carlos León](_blank)** - <carleon.dev@gmail.com>

## Copyright (c) 2022 **[2devs.io](https://2devs.io/)**
