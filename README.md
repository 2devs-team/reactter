<p align="center">
  <img src="https://raw.githubusercontent.com/2devs-team/reactter_assets/main/reactter_logo_full.png" height="100" alt="Reactter" />
</p>

____

[![Pub Publisher](https://img.shields.io/pub/publisher/reactter?color=013d6d&labelColor=01579b)](https://pub.dev/publishers/2devs.io/packages)
[![Pub package](https://img.shields.io/pub/v/reactter?color=1d7fac&labelColor=29b6f6&label=pub.dev&logo=flutter)](https://pub.dev/packages/reactter)
[![Pub points](https://img.shields.io/pub/points/reactter?color=196959&labelColor=23967F&logo=dart)](https://pub.dev/packages/reactter/score)
[![MIT License](https://img.shields.io/github/license/2devs-team/reactter?color=a85f00&labelColor=F08700&logoColor=fff&logo=Open%20Source%20Initiative)](https://github.com/2devs-team/reactter/blob/master/LICENSE)
[![MIT License](https://img.shields.io/static/v1?label=Discord&message=Reactter&color=5a52b3&labelColor=8075FF&logoColor=fff&logo=discord)](https://discord.gg/RDPGyATS5J)

**A light, powerful and reactive state management.**

By using `Reactter` you get:

- Reduce significantly boilerplate code.
- Improve code readability.
- Unidirectional data flow.
- Control re-render widget tree.
- Reuse state using custom hooks.

## Contents

- [Quickstart](#quickstart)
- [Usage](#usage)
  - [Create a `ReactterContext`](#create-a-reacttercontext)
  - [Using `UseState` hook](#using-usestate-hook)
  - [Using `UseEffect` hook](#using-useeffect-hook)
  - [Wrap with `ReactterProvider` and `UseContext`](#wrap-with-reactterprovider-and-usecontext)
  - [Control re-render with `ReactterBuilder`](#control-re-render-with-reactterbuilder)
  - [Access to `ReactterContext`](#access-to-reacttercontext)
  - [Lifecycle of `ReactterContext`](#lifecycle-of-reacttercontext)
  - [Create a `ReactterComponent`](#create-a-reacttercomponent)
  - [Using `UseAsyncState` hook](#using-useasyncstate-hook)
  - [Create a custom hook](#create-a-custom-hook)
  - [Global state](#global-state)
- [Resources](#resources)
- [Roadmap](#roadmap)
- [Contribute](#contribute)
- [Authors](#authors)

## Quickstart

In your flutter project add the dependency:

Run this command with Flutter:

```shell
flutter pub add reactter
```

or add a line like this to your package's `pubspec.yaml`:

```yaml
  dependencies:
    reactter: ^2.3.2
```

Now in your Dart code, you can use:

```dart
import 'package:reactter/reactter.dart';
```

## Usage

### Create a `ReactterContext`

[`ReactterContext`](https://pub.dev/documentation/reactter/latest/reactter/ReactterContext-class.html) is a abstract class with functionality to manages hooks  (like `UseState`, `UseEffect`) and lifecycle events.

You can use it's functionalities, creating a class that extends it:

```dart
class AppContext extends ReactterContext {}
```

> **RECOMMENDED:**
> Name class with `Context` suffix, for easy locatily.

### Using `UseState` hook

[`UseState`](https://pub.dev/documentation/reactter/latest/reactter/UseState-class.html) is a hook that allow to manage a state.

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

[`UseEffect`](https://pub.dev/documentation/reactter/latest/reactter/UseEffect-class.html) is a hook that allow to manage side-effect.

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

[`ReactterProvider`](https://pub.dev/documentation/reactter/latest/reactter/ReactterProvider-class.html) is a wrapper widget of a [`InheritedWidget`](https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html) witch helps exposes the `ReactterContext` that are defined using [`UseContext`](https://pub.dev/documentation/reactter/latest/reactter/UseContext-class.html) on `contexts` parameter.

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
        final appContext = context.watch<AppContext>();
        final appConfigContext = context.watchId<ConfigContext>('App');
        final userConfigContext = context.watchId<ConfigContext>('User');

        return [...]
      },
    );
  }
}
```

*For more information about `context.watch[...]` go to [here](#access-to-reacttercontext).*

> **RECOMMENDED:**
> Don't use `ReactterContext` class with parameters to prevent conflicts. Instead of it, use `onInit` method which `UseContext` exposes for access its instance and put the data you need.
>
> **NOTE:**
> You can use `id` parameter of `UseContext` for create a different instance of same `ReactterContext` class.

### Control re-render with `ReactterBuilder`

[`ReactterBuilder`](https://pub.dev/documentation/reactter/2.1.1-dev/reactter/ReactterBuilder-class.html) create a scope where isolates the widget tree which will be re-rendering when all or some of the specified `ReactterHook` dependencies on `listenHooks` has changed.

```dart
ReactterProvider(
  contexts: [
    UseContext(() => AppContext()),
  ],
  builder: (context, child) {
    // This builder is render only one time.
    // But if you use context.watch<T> or context.watchId<T> here,
    // it forces re-render this builder together ReactterBuilder's builder.
    final appContext = context.read<AppContext>();

    return Column(
      children: [
        Text("stateA: ${appContext.stateA.value}"),
        ReactterBuilder<AppContext>(
          listenHooks: (appContext) => [appContext.stateB],
          builder: (appContext, context, child){
            // This builder is re-render when only stateB changes
            return Text("stateB: ${appContext.stateB.value}");
          },
        ),
        ReactterBuilder<AppContext>(
          listenHooks: (appContext) => [appContext.stateC],
          builder: (appContext, context, child){
            // This builder is re-render when only stateC changes
            return Text("stateC: ${appContext.stateC.value}");
          },
        ),
      ],
    );
  },
)
```

### Access to `ReactterContext`

Reactter provides additional methods to `BuildContext` for access your `ReactterContext`. These are:

- [**`context.watch<T>`**](https://pub.dev/documentation/reactter/latest/reactter/ReactterBuildContextExtension/watch.html): Get the `ReactterContext` instance of the specified type and watch context's states or states defined on first parameter.

```dart
final watchContext = context.watch<WatchContext>();
final watchHooksContext = context.watch<WatchHooksContext>(
  (ctx) => [ctx.stateA, ctx.stateB],
);
```

- [**`context.watchId<T>`**](https://pub.dev/documentation/reactter/latest/reactter/ReactterBuildContextExtension/watchId.html): Get the `ReactterContext` instance of the specified type and id defined on first parameter and watch context's states or states defined on second parameter.

```dart
final watchIdContext = context.watchId<WatchIdContext>('id');
final watchHooksIdContext = context.watchId<WatchHooksIdContext>(
  'id',
  (ctx) => [ctx.stateA, ctx.stateB],
);
```

- [**`context.read<T>`**](https://pub.dev/documentation/reactter/latest/reactter/ReactterBuildContextExtension/read.html): Get the `ReactterContext` instance of the specified type.

```dart
final readContext = context.read<ReadContext>();
```

- [**`context.readId<T>`**](https://pub.dev/documentation/reactter/latest/reactter/ReactterBuildContextExtension/readId.html): Get the `ReactterContext` instance of the specified type and id defined on first parameter.

```dart
final readIdContext = context.readId<ReadIdContext>('id');
```

> **NOTE:**
> `context.watch<T>` and `context.watchId<T>` watch all or some of the specified `ReactterHook` dependencies and when it will change, re-render widgets in the scope of `ReactterProvider` or `ReactterBuilder`.
>
> **NOTE:**
> These methods mentioned above uses [`ReactterProvider.contextOf<T>`](https://pub.dev/documentation/reactter/latest/reactter/ReactterProvider/contextOf.html)

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
2. [**`onWillMount`**](https://pub.dev/documentation/reactter/latest/reactter/ReactterContext/onWillMount.html): Will trigger before the `ReactterContext` instance will mount in the tree by `ReactterProvider`.
3. [**`onDidMount`**](https://pub.dev/documentation/reactter/latest/reactter/ReactterContext/onDidMount.html): Will trigger after the `ReactterContext` instance did mount in the tree by `ReactterProvider`.
4. [**`onWillUpdate`**](https://pub.dev/documentation/reactter/latest/reactter/ReactterContext/onWillUpdate.html): Will trigger before the `ReactterContext` instance will update by any `ReactterHook`.
5. [**`onDidUpdate`**](https://pub.dev/documentation/reactter/latest/reactter/ReactterContext/onDidUpdate.html): Will trigger after the `ReactterContext` instance did update by any `ReactterHook`.
6. [**`onWillUnmount`**](https://pub.dev/documentation/reactter/latest/reactter/ReactterContext/onWillUnmount.html): Will trigger before the `ReactterContext` instance will unmount in the tree by `ReactterProvider`.

> **NOTE:**
> `UseContext` has `onInit` parameter which is execute between constructor and `onWillMount`, you can use to access to instance and putin data before mount.

### Create a `ReactterComponent`

[`ReactterComponent`](https://pub.dev/documentation/reactter/2.1.1-dev/reactter/ReactterComponent-class.html) is a `StatelessWidget` class that wrap `render` with `ReactterProvider` and `UseContext`.

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

[`UseAsyncState`](https://pub.dev/documentation/reactter/2.1.1-dev/reactter/UseAsyncState-class.html) is a hook with the same functionality as `UseState` but providing a `asyncValue` which it will be obtain when execute `resolve` method.

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
    final appContext = context.watch<AppContext>();

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

### Create a custom hook

For create a custom hook, you should be create a class that extends of [`ReactterHook`](https://pub.dev/documentation/reactter/2.1.1-dev/reactter/ReactterHook-class.html).

This is a example:

```dart
class UseCount extends ReactterHook {
  int _count = 0;

  int get value => _count;

  UseCount(int initial, [ReactterContext? context])
      : _count = initial,
        super(context);

  void increment() => update(() => _count += 1);
  void decrement() => update(() => _count -= 1);
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

// It's need to instance it for can execute Global._init(This executes one time only).
final global = Global();
```

This is a example that how you could use it:

```dart
class AppContext extends ReactterContext {
  late final isOdd = UseState(false, this);

  AppContext() {
    UseEffect((){
      isOdd.value = Global.count.value % 2 != 0;
    }, [Global.count], this);
  }
}
```

> **NOTE:**
> If you want to execute some logic when initialize the global class you need to use the class factory and then instance it to run as singleton way.

## Resources

- [Documentation](https://pub.dev/documentation/reactter/latest)
- [Examples](https://github.com/2devs-team/reactter/tree/master/example)
  - [Counter example](https://github.com/2devs-team/reactter/tree/master/example/lib/examples/counter)
  - [Todos example](https://github.com/2devs-team/reactter/tree/master/example/lib/examples/todos)
  - [Shopping cart example](https://github.com/2devs-team/reactter/tree/master/example/lib/examples/shopping_cart)
  - [Tree widget example](https://github.com/2devs-team/reactter/tree/master/example/lib/examples/tree)
  - [Git search example](https://github.com/2devs-team/reactter/tree/master/example/lib/examples/api)
  - [Animate widget example](https://github.com/2devs-team/reactter/tree/master/example/lib/examples/animation)

## Roadmap

We want keeping adding features for `Reactter`, those are some we have in mind order by priority:

### V3

- Async context.
- Make `Reactter` easy for debugging.
- Structure proposal for large projects.
- Improve performance and do benchmark.

# Contribute

If you want to contribute don't hesitate to create an [issue](https://github.com/2devs-team/reactter/issues/new) or [pull-request](https://github.com/2devs-team/reactter/pulls) in **[Reactter repository](https://github.com/2devs-team/reactter).**

You can:

- Add a new custom hook.
- Add a new widget.
- Add examples.
- Provide new features.
- Report bugs.
- Report situations difficult to implement.
- Report an unclear error.
- Report unclear documentation.
- Write articles or make videos teaching how to use **[Reactter](https://github.com/2devs-team/reactter)**.

Any idea is welcome!

# Authors

- **[Leo Castellanos](https://twitter.com/leoocast10)** - <leoocast.dev@gmail.com>
- **[Carlos León](_blank)** - <carleon.dev@gmail.com>

## Copyright (c) 2022 **[2devs.io](https://2devs.io)**
