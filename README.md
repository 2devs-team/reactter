<p align="center">
  <img src="https://raw.githubusercontent.com/2devs-team/reactter_assets/main/reactter_logo_full.png" height="100" alt="Reactter" />
</p>

____

[![Pub Publisher](https://img.shields.io/pub/publisher/reactter?color=013d6d&labelColor=01579b)](https://pub.dev/publishers/2devs.io/packages)
[![Reactter](https://img.shields.io/pub/v/reactter?color=1d7fac&labelColor=29b6f6&label=reactter&logo=dart)](https://pub.dev/packages/reactter)
[![Flutter Reactter](https://img.shields.io/pub/v/flutter_reactter?color=1d7fac&labelColor=29b6f6&label=flutter_reactter&logo=flutter)](https://pub.dev/packages/flutter_reactter)
[![Pub points](https://img.shields.io/pub/points/reactter?color=196959&labelColor=23967F&logo=dart)](https://pub.dev/packages/reactter/score)
[![MIT License](https://img.shields.io/github/license/2devs-team/reactter?color=a85f00&labelColor=F08700&logoColor=fff&logo=Open%20Source%20Initiative)](https://github.com/2devs-team/reactter/blob/master/LICENSE)
[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/2devs-team/reactter/Test?logo=github)](https://github.com/2devs-team/reactter/actions)
[![Codecov](https://img.shields.io/codecov/c/github/2devs-team/reactter?logo=codecov)](https://app.codecov.io/gh/2devs-team/reactter)

**A light, powerful and reactive state management.**

## Features

- ⚡️ **Build for speed**.
- 📏 **Reduce boilerplate code** significantly.
- 📝 **Improve code readability**.
- 🪃 **Unidirectional** data flow.
- ♻️ **Reuse state** using custom hooks.
- 🪄 **No configuration** necessary.
- 🎮 **Total control** to re-render widget tree.
- 💙 **Flutter or Dart only**, you can use in any Dart project.

## Contents

- [Quickstart](#quickstart)
- [Usage](#usage)
  - [Create a `ReactterContext`](#create-a-reacttercontext)
  - [Lifecycle of `ReactterContext`](#lifecycle-of-reacttercontext)
  - [Manage instance with `ReactterInstanceManage`](#manage-instance-with-reactterinstancemanage)
  - [Using `UseContext` hook](#using-usecontext-hook)
  - [Using `UseEvent` hook](#using-useevent-hook)
  - [Using `UseState` hook](#using-usestate-hook)
  - [Using `UseAsyncState` hook](#using-useasyncstate-hook)
  - [Using `UseEffect` hook](#using-useeffect-hook)
  - [Create a `ReactterHook`](#create-a-reactterhook)
  - [Global state](#global-state)
- [Usage with `flutter_reactter`](#usage-with-flutter_reactter)
  - [Wrap with `ReactterProvider`](#wrap-with-reactterprovider)
  - [Access to `ReactterContext`](#access-to-reacttercontext)
  - [Control re-render with `ReactterScope`](#control-re-render-with-reactterscope)
  - [Control re-render with `ReactterBuilder`](#control-re-render-with-reactterbuilder)
  - [Mutiple `ReactterProvider` with `ReactterProviders`](#multiple-reactterprovider-with-reactterproviders)
  - [Create a `ReactterComponent`](#create-a-reacttercomponent)
- [Resources](#resources)
- [Roadmap](#roadmap)
- [Contribute](#contribute)
- [Authors](#authors)

## Quickstart

Before anything, you need to be aware that Reactter is distributed on two packages, with slightly different usage.

The package of Reactter that you will want to install depends on the project type you are making.

Select one of the following options to know how to install it:

<details close>
  <summary>
    <h4 style="display: inline;">Dart only&ensp;</h4>
    <a href="https://pub.dev/packages/reactter" style="vertical-align: middle;">
      <img src="https://img.shields.io/pub/v/reactter?color=1d7fac&amp;labelColor=29b6f6&amp;label=reactter&amp;logo=dart" alt="Reactter">
    </a>
  </summary>

Add the package on your project.

- Using command:

  ```shell
  dart pub add reactter
  ```

- Or put directly into `pubspec.yaml` file:

  ```yaml
    dependencies:
      reactter: #add version here
  ```

  and run `dart pub get`.

Now in your Dart code, you can use:

```dart
import 'package:reactter/reactter.dart';
```

</details>

<details close>
  <summary>
    <h4 style="display: inline;">Flutter&ensp;</h4>
    <a href="https://pub.dev/packages/flutter_reactter"  style="vertical-align: middle;">
      <img src="https://img.shields.io/pub/v/flutter_reactter?color=1d7fac&amp;labelColor=29b6f6&amp;label=flutter_reactter&amp;logo=flutter" alt="Flutter Reactter">
    </a>
  </summary>

Add the package on your project.

- Using command:

  ```shell
  flutter pub add flutter_reactter
  ```

- Or put directly into `pubspec.yaml` file:

  ```yaml
    dependencies:
      flutter_reactter: #add version here
  ```

  and run `flutter pub get`.

Now in your Dart code, you can use:

```dart
import 'package:flutter_reactter/flutter_reactter.dart';
```

</details>

## Usage

### Create a `ReactterContext`

[`ReactterContext`](https://pub.dev/documentation/reactter/latest/reactter/ReactterContext-class.html) is a abstract class that allows to manages [`ReactterHook`](https://pub.dev/documentation/reactter/latest/reactter/ReactterHook-class.html) and provides life-cycle events.

You can use it's functionalities, creating a class that extends it:

```dart
class AppContext extends ReactterContext {}
```

> **RECOMMENDED:**
> Name class with `Context` suffix, for easy locatily.

### Lifecycle of `ReactterContext`

`ReactterContext` has the following [Lifecycle](https://pub.dev/documentation/reactter/latest/reactter/Lifecycle.html) events:

- **`Lifecycle.registered`**: Event when the instance has registered by `ReactterInstanceManager`.

- **`Lifecycle.unregistered`**: Event when the instance has unregistered by `ReactterInstanceManager`.

- **`Lifecycle.inicialized`**: Event when the instance has inicialized by `ReactterInstanceManager`.

- **`Lifecycle.willMount`**: Event when the instance will be mount in the widget tree (it use with `flutter_reactter` only).

- **`Lifecycle.didMount`**: Event when the instance did be mount in the widget tree (it use with `flutter_reactter` only).

- **`Lifecycle.willUpdate`**: Event when any instance's hooks will be update. Event param is a `ReactterHook`.

- **`Lifecycle.didUpdate`**: Event when any instance's hooks did be update. Event param is a `ReactterHook`.

- **`Lifecycle.willUnmount`**: Event when the instance will be unmount in the widget tree(it use with `flutter_reactter` only).

- **`Lifecycle.destroyed`**: Event when the instance did be destroyed by `ReactterInstanceManager`.

You can put it on listen, using `UseEvent`, for example:

```dart
  UseEvent<AppContext>().on<ReactterHook>(
    Lifecycle.didUpdate,
    (inst, hook) => print("Instance: $inst, hook: $hook"),
  );
```

### Manage instance with `ReactterInstanceManage`

[`ReactterInstanceManager`](https://pub.dev/documentation/reactter/latest/reactter/ReactterInstanceManager.html) is a instance of `Reactter` that exposes some methods to helps to manages instance. These are some methods:

**`Reactter.register`**: Registers a `builder` function to allows to create the instance using `Reactter.get`.

```dart
Reactter.register(builder: () => AppContext());
Reactter.register(id: "uniqueId", builder: () => AppContext());
```

**`Reactter.unregister`**: Removes the `builder` function to avoid create the instance.

```dart
Reactter.unregister<AppContext>();
Reactter.unregister<AppContext>("uniqueId");
```

**`Reactter.get`**: Gets the previously instance created or create a new instance from the `build` registered using `reactter.register`.

```dart
final appContext = Reactter.get<AppContext>();
final appContextWithId = Reactter.get<AppContext>(id: 'uniqueId');
```

**`Reactter.create`**: Registers, creates and gets the instance directly.

```dart
final appContext = Reactter.create(build: () => AppContext());
final appContextWithId = Reactter.create(id: 'uniqueId', build: () => AppContext());
```

**`Reactter.delete`**: Deletes the instance but still keep the `build` function.

```dart
Reactter.delete<AppContext>();
Reactter.delete<AppContext>('uniqueId');
```

> **NOTE:**
> The registered instances have a global scope. This means that you can access them anywhere in the project just by using `Reactter.get` or through [`UseContext`](https://pub.dev/documentation/reactter/latest/reactter/UseContext-class.html).

### Using `UseContext` hook

[`UseContext`](https://pub.dev/documentation/reactter/latest/reactter/UseContext-class.html) is a `ReactterHook` that allows to get `ReactterContext`'s instance when it's ready.

```dart
class AppContext extends ReactterContext {
  late final otherContextHook = UseContext<OtherContext>(context: this);
  // final otherContextHookWithId = UseContext<OtherContext>(id: "uniqueId", context: this);
  late otherContext = otherContext.instance;

  AppContext() {
    UseEffect(() {
      otherContext = otherContextHook.instance;
    }, [otherContextHook]);
  }
}
```

> **NOTE:** If you're not sure that you got the instance from the beginning, you need to use the `UseEffect` as shown in the example above.
>
> **NOTE:** The context that you need to get, must be created by `ReactterInstanceManager`.

### Using `UseEvent` hook

[`UseEvent`](https://pub.dev/documentation/reactter/latest/reactter/UseEvent-class.html) is a hook that manages events.

You can listen to event using `on` method:

```dart
enum Events { SomeEvent };

void _onSomeEvent(inst, param) {
  print("$inst's Events.SomeEvent emitted with param: $param.");
}

UseEvent<AppContext>().on(Events.SomeEvent, _onSomeEvent);
```

use `off` method to stop listening event:

```dart
UseEvent<AppContext>().off(Events.SomeEvent, _onSomeEvent);
```

If you want to listen event only once, use `one` method:

```dart
UseEvent<AppContext>().one(Events.SomeEvent, _onSomeEvent);
```

And use `emit` method to trigger event:

```dart
UseEvent<AppContext>().emit(Events.SomeEvent, 'Parameter');
```

> **IMPORTANT:** Don't forget to remove event using `off` or using `dispose` to remove all instance's events.
> Failure to do so could increase memory usage or have unexpected behaviors, such as events in permanent listening.
>
> **RECOMMENDED:** If you have the instance, use directly with `UseEvent.withInstance(Instance)`.

### Using `UseState` hook

[`UseState`](https://pub.dev/documentation/reactter/latest/reactter/UseState-class.html) is a `ReactterHook` that manages a state.

You can add it on any part of class, with the context argument(`this`) to put this hook on listen:

```dart
class AppContext extends ReactterContext {
  late final count = UseState(0, this);
}
```

or add it into `listenHooks` method which is exposed by `ReactterContext`:

```dart
class AppContext extends ReactterContext {
  final count = UseState(0);

  AppContext() {
    listenHooks([count]);
  }
}
```

> **NOTE:** If you don't add context argument or use `listenHook`, the `ReactterContext` won't be able to react to hook's changes.

`UseState` has `value` property that allows to read and write its state:

```dart
class AppContext extends ReactterContext {
  late final count = UseState(0, this);

  AppContext() {
    print("Prev state: ${count.value}");
    count.value = 10;
    print("Current state: ${count.value}");
  }
}
```

> **NOTE:** `UseState` notifies that its state has changed when the previous state is different from the current state.
> If its state is a `Object`, not detect internal changes, only when states is setted another `Object`.

If you want to force notify, execute `update` method, which is exposed by `UseState`.

```dart
class Todo {
  String name;

  Todo(this.name);
}

class AppContext extends ReactterContext {
  final todoState = UseState(Todo('Do this'), this);

  AppContext() {
    todoState.update(() {
      todoState.value.name = 'Do this other';
    });
  }
}
```

### Using `UseAsyncState` hook

[`UseAsyncState`](https://pub.dev/documentation/reactter/latest/reactter/UseAsyncState-class.html) is a `ReactterHook` with the same functionality as `UseState` but provides a `asyncValue` method, which will be obtained when `resolve` method is executed.

```dart
class TranslateArgs {
  final String to;
  final String from;
  final String text;

  TranslateArgs({ this.to, this.from, this.text });
}

class AppContext extends ReactterContext {
  late final translateState = UseAsyncStates<String, TranslateArgs>(
    'Hello world',
    translate,
    this,
  );

  AppContext() {
    _init();
  }

  Future<void> _init() async {
    await translateState.resolve(
      TranslateArgs({
        to: 'ES',
        from: 'EN',
        text: translateState.value,
      }),
    );

    print("'Hello world' translated to Spanish: '${translateState.value}'");
  }

  Future<String> translate([TranslateArgs args]) async {
    return await api.translate(args);
  }
}
```

> **NOTE:**
> If you want to send argument to `asyncValue` method, need to define a type argument which be send through `resolve` method. Like the example shown above, the argument type send is `TranslateArgs` class.

It also has `when` method that returns a new value depending on it's state:

```dart
final valueComputed = asyncState.when<String>(
  standby: (value) => "⚓️ Standby: $value",
  loading: (value) => "⏳ Loading...",
  done: (value) => "✅ Resolved: $value",
  error: (error) => "❌ Error: $error",
);
```

### Using `UseEffect` hook

[`UseEffect`](https://pub.dev/documentation/reactter/latest/reactter/UseEffect-class.html) is a `ReactterHook` that manages side-effect.

You can add it on constructor of class:

```dart
class AppContext extends ReactterContext {
  late final count = UseState(0, this);

  AppContext() {
    UseEffect((){
      // Execute by count state changed or 'didMount' event
      print("Count: ${count.value}");

      Future.delayed(
        const Duration(seconds: 1),
        () => count.value += 1,
      );

      return () {
        // Cleanup - Execute Before count state changed or 'willUnmount' event
        print("Cleanup executed");
      };
    }, [count], this);
  }
}
```

If you want to execute a `UseEffect` immediately, use `UseEffect.dispatchEffect` instead of the `context` argument:

```dart
UseEffect(
  () => print("Excute immediately or by hook's changes"),
  [someHook],
  UseEffect.dispatchEffect
);
```

> **NOTE:**
> If you don't add `context` argument to `UseEffect`, the `callback` don't execute on lifecycle `didMount`, and the `cleanup` don't execute on lifecycle `willUnmount`(theses lifecycle events are used with `flutter_reactter` only).

### Create a `ReactterHook`

[`ReactterHook`](https://pub.dev/documentation/reactter/latest/reactter/ReactterHook-class.html) is a abstract class that allows to create a custom hook.

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
        const Duration(seconds: 1),
        count.increment,
      );

      print("Count: ${count.value}");
    }, [count], this);
  }
}
```

### Global state

The reactter's hooks can be defined as static to access its as global way:

```dart
class Global {
  static final flag = UseState(false);
  static final count = UseCount(0);

  // Create a class factory to run it as singleton way.
  // This way, the initial logic can be executed.
  static final Global _inst = Global._init();
  factory Global() => _inst;

  Global._init() {
    UseEffect(() {
      Future.delayed(const Duration(seconds: 1), changeCount);
    }, [count], UseEffect.dispatchEffect);
  }

  static void changeCount() {
    if (count.value <= 0) {
      flag.value = true;
    }

    if (count.value >= 10) {
      flag.value = false;
    }

    flag.value ? count.increment() : count.decrement();
  }
}

// It's need to create the instance it to be able
// to execute Global._init(This executes only once).
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

## Usage with `flutter_reactter`

![Concept Diagram](https://raw.githubusercontent.com/2devs-team/reactter_assets/main/concept_diagram.png)

### Wrap with `ReactterProvider`

[`ReactterProvider`](https://pub.dev/documentation/flutter_reactter/latest/flutter_reactter/ReactterProvider-class.html) is a wrapper `StatelessWidget` that provides a
`ReactterContext`'s instance to widget tree that can be access through the `BuildContext`.

```dart
ReactterProvider(
  () => AppContext(),
  builder: (context, child) {
    final appContext = context.watch<AppContext>();
    return Text("count: ${appContext.count.value}");
  },
)
```

If you want to create a different `ReactterContext`'s instance, use `id` parameter.

```dart
ReactterProvider(
  () => AppContext(),
  id: "uniqueId",
  builder: (context, child) {
    final appContext = context.watchId<AppContext>("uniqueId");
    return Text("count: ${appContext.count.value}");
  },
)
```

> **IMPORTANT:** Don's use `ReactterContext` with constructor parameters to prevent conflicts.
> Instead use `onInit` method to access its instance and put the data you need.
>
> **NOTE:** `ReactteProvider` is a "scoped". So it contains a `ReactterScope` which the `builder` callback will be rebuild, when the `ReactterContext` changes.
> For this to happen, the `ReactterContext` should put it on listens for `BuildContext`'s `watch`ers.

### Access to `ReactterContext`

Reactter provides additional methods to `BuildContext` to access your `ReactterContext`. These are following:

- [**`context.watch`**](https://pub.dev/documentation/flutter_reactter/latest/flutter_reactter/ReactterBuildContextExtension/watch.html): Gets the `ReactterContext`'s instance from the closest ancestor of  `ReactterProvider` and watch all `ReactterHook` or `ReactterHook` defined in first paramater.

```dart
final watchContext = context.watch<WatchContext>();
final watchHooksContext = context.watch<WatchHooksContext>(
  (ctx) => [ctx.stateA, ctx.stateB],
);
```

- [**`context.watchId`**](https://pub.dev/documentation/flutter_reactter/latest/flutter_reactter/ReactterBuildContextExtension/watchId.html): Gets the `ReactterContext`'s instance with `id` from the closest ancestor of  `ReactterProvider` and watch all `ReactterHook` or `ReactterHook` defined in second paramater.

```dart
final watchIdContext = context.watchId<WatchIdContext>('id');
final watchHooksIdContext = context.watchId<WatchHooksIdContext>(
  'id',
  (ctx) => [ctx.stateA, ctx.stateB],
);
```

- [**`context.use`**](https://pub.dev/documentation/flutter_reactter/latest/flutter_reactter/ReactterBuildContextExtension/use.html): Gets the `ReactterContext`'s instance with/without `id` from the closest ancestor of  `ReactterProvider`.

```dart
final readContext = context.use<ReadContext>();
final readIdContext = context.use<ReadIdContext>('id');
```

> **NOTE:**
> These methods mentioned above uses [`ReactterProvider.contextOf`](https://pub.dev/documentation/flutter_reactter/latest/flutter_reactter/ReactterProvider/contextOf.html)
>
> **NOTE:**
> `context.watch` and `context.watchId` watch all or some of the specified `ReactterHook` dependencies and when it will change, re-render widgets in the scope of `ReactterProviders`, `ReactterBuilder` or `ReactterScope`.

### Control re-render with `ReactterScope`

[`ReactterScope`](https://pub.dev/documentation/flutter_reactter/latest/flutter_reactter/ReactterScope-class.html) is a wrapeer `StatelessWidget` that helps to control re-rendered of widget tree.

```dart
ReactterScope<AppContext>(
  builder: (context, child) {
    final appContext = context.watch<AppContext>();
    return Text("Count: ${appContext.count.value}");
  },
)
```

> **NOTE:** The `builder` callback will be rebuild, when the `ReactterContext` changes.
> For this to happen, the `ReactterContext` should put it on listens for `BuildContext`'s `watch`ers.

### Control re-render with `ReactterBuilder`

[`ReactterBuilder`](https://pub.dev/documentation/flutter_reactter/latest/flutter_reactter/ReactterBuilder-class.html) is a wrapper `StatelessWidget` that helps to get the `ReactterContext`'s instance from the closest ancestor of `ReactterProvider` and exposes it through the first parameter of `builder` callback.

```dart
ReactterBuilder<AppContext>(
  listenAllHooks: true,
  builder: (appContext, context, child) {
    return Text("Count: ${appContext.count.value}");
  },
)
```

> **NOTE:** `ReactterBuilder` is read-only by default(`listenAllHooks: false`), this means it only renders once.
> Instead use `listenAllHooks` as `true` or use `listenHooks` with the `ReactterHook`s specific and then the `builder` callback will be rebuild with every `ReactterContext`'s `ReactterHook` changes.
>
> **NOTE:** `ReactterBuilder` is a "scoped". So it contains a `ReactterScope` which the `builder` callback will be rebuild, when the `ReactterContext` changes.
> For this to happen, the `ReactterContext` should put it on listens for `BuildContext`'s `watch`ers.

### Multiple `ReactterProvider` with `ReactterProviders`

[`ReactterProviders`](https://pub.dev/documentation/flutter_reactter/latest/flutter_reactter/ReactterProviders-class.html) is a wrapper `StatelessWidget` that allows to use multiple `ReactterProvider` as nested way.

```dart
ReactterProviders(
  [
    ReactterProvider(() => AppContext()),
    ReactterProvider(
      () => ConfigContext(),
      id: 'App',
      onInit: (appConfigContext) {
        appConfigContext.config.value = 'new state';
      },
    ),
    ReactterProvider(
      () => ConfigContext(),
        id: 'User'
    ),
  ],
  builder: (context, child) {
    final appContext = context.watch<AppContext>();
    final appConfigContext = context.watchId<ConfigContext>('App');
    final userConfigContext = context.watchId<ConfigContext>('User');
    ...
  },
)
```

### Create a `ReactterComponent`

[`ReactterComponent`](https://pub.dev/documentation/flutter_reactter/latest/flutter_reactter/ReactterComponent-class.html) is a abstract `StatelessWidget` class that provides the functionality of `ReactterProvider` with a `ReactterContext` and exposes it through `render` method.

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

## Resources

- [Documentation](https://pub.dev/documentation/reactter/latest)
- [Examples](https://github.com/2devs-team/reactter/tree/master/examples)
  - [Counter example](https://github.com/2devs-team/reactter/tree/master/examples/lib/counter)
  - [Todos example](https://github.com/2devs-team/reactter/tree/master/examples/lib/todos)
  - [Shopping cart example](https://github.com/2devs-team/reactter/tree/master/examples/lib/shopping_cart)
  - [Tree widget example](https://github.com/2devs-team/reactter/tree/master/examples/lib/tree)
  - [Git search example](https://github.com/2devs-team/reactter/tree/master/examples/lib/api)
  - [Animate widget example](https://github.com/2devs-team/reactter/tree/master/examples/lib/animation)

## Roadmap

We want to keeping adding features for `Reactter`, those are some we have in mind order by priority:

- Widget to control re-render using only hooks
- Async context.
- Structure proposal for large projects.
- Do benchmarks and improve performance.

# Contribute

If you want to contribute don't hesitate to create an [issue](https://github.com/2devs-team/reactter/issues/new) or [pull-request](https://github.com/2devs-team/reactter/pulls) in **[Reactter repository](https://github.com/2devs-team/reactter).**

You can:

- Provide new features.
- Report bugs.
- Report situations difficult to implement.
- Report an unclear error.
- Report unclear documentation.
- Add a new custom hook.
- Add a new widget.
- Add examples.
- Write articles or make videos teaching how to use **[Reactter](https://github.com/2devs-team/reactter)**.

Any idea is welcome!

# Authors

- **[Leo Castellanos](https://twitter.com/leoocast10)** - <leoocast.dev@gmail.com>
- **[Carlos León](_blank)** - <carleon.dev@gmail.com>
