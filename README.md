<p align="center">
  <img src="https://raw.githubusercontent.com/2devs-team/reactter_assets/main/reactter_logo_full.png" height="100" alt="Reactter" />
</p>

____

[![Pub Publisher](https://img.shields.io/pub/publisher/reactter?color=013d6d&labelColor=01579b)](https://pub.dev/publishers/2devs.io/packages)
[![Reactter](https://img.shields.io/pub/v/reactter?color=1d7fac&labelColor=29b6f6&label=reactter&logo=dart)](https://pub.dev/packages/reactter)
[![Flutter Reactter](https://img.shields.io/pub/v/flutter_reactter?color=1d7fac&labelColor=29b6f6&label=flutter_reactter&logo=flutter)](https://pub.dev/packages/flutter_reactter)
[![Pub points](https://img.shields.io/pub/points/reactter?color=196959&labelColor=23967F&logo=dart)](https://pub.dev/packages/reactter/score)
[![MIT License](https://img.shields.io/github/license/2devs-team/reactter?color=a85f00&labelColor=F08700&logoColor=fff&logo=Open%20Source%20Initiative)](https://github.com/2devs-team/reactter/blob/master/LICENSE)
[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/2devs-team/reactter/dart.yml?branch=master)](https://github.com/2devs-team/reactter/actions)
[![Codecov](https://img.shields.io/codecov/c/github/2devs-team/reactter?logo=codecov)](https://app.codecov.io/gh/2devs-team/reactter)

**A light, powerful and quick Reactive State Management, Dependency Injection and Event Management.**

## Features

- ⚡️ Build for **speed**.
- ⚖️ Super **lightweight**([🥇 See benchmarks](https://github.com/CarLeonDev/state_managements#memory-size)).
- 📏 **Reduce boilerplate code** significantly([🥇 See benchmarks](https://github.com/CarLeonDev/state_managements#lines-number)).
- 📝 **Improve code readability**.
- 💧 **Adaptable** to any architecture.
- ☢️ **Reactive state** using [Signal](#signal).
- ♻️ **Reuse state** creating [custom hooks](#custom-hooks).
- 🪄 **No configuration** and **no code generation** necessary.
- 🎮 **Total control** to re-render widget tree.
- 💙 **Dart or Flutter**, supports the latest version of Dart.

Let's see a small and simple example:

```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

// Create a reactive state using `Signal`
final count = 0.signal;

void main() {
  // Put on listen `didUpdate` event, whitout use `Stream`
  Reactter.on(count, Lifecycle.didUpdate, (_, __) => print('Count: $count'));

  // Change the `value` in any time.
  Timer.periodic(Duration(seconds: 1), (_) => count.value++);

  // And you can use in flutter like this:
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: ReactterWatcher(
            builder: (context, child) {
              // This will be re-built, at each count change.
              return Text(
                "$count",
                style: Theme.of(context).textTheme.headline3,
              );
            },
          ),
        ),
      ),
    ),
  );
}
```

Clean and easy!

See more examples [here](https://zapp.run/pub/flutter_reactter)!

## Contents

- [Quickstart](#quickstart)
- [About Reactter](#about-reactter)
- [State management](#state-management)
  - [Signal](#signal)
  - [UseState](#usestate)
  - [Difference between Signal and UseState](#difference-between-signal-and-usestate)
  - [UseAsyncState](#useasyncstate)
  - [UseReducer](#usereducer)
  - [UseCompute](#usecompute)
  - [Custom hooks](#custom-hooks)
- [Dependency injection](#dependency-injection)
  - [Shortcuts to manage instances](#shortcuts-to-manage-instances)
  - [UseContext](#usecontext)
  - [ReactterProvider](#reactterprovider) (`flutter_reactter`)
  - [ReactterProviders](#reactterproviders) (`flutter_reactter`)
  - [ReactterComponent](#reacttercomponent) (`flutter_reactter`)
- [LifeCycle and event management](#lifecycle-and-event-management)
  - [Shortcuts to manage events](#shortcuts-to-manage-events)
  - [UseEvent](#useevent)
  - [UseEffect](#useeffect)
  - [ReactterConsumer](#reactterconsumer) (`flutter_reactter`)
  - [ReactterWatcher](#reactterwatcher) (`flutter_reactter`)
  - [BuildContext extension](#buildcontext-extension) (`flutter_reactter`)
- [Resources](#resources)
- [Contribute](#contribute)
- [Authors](#authors)

## Quickstart

Before anything, you need to be aware that Reactter is distributed on two packages, with slightly different usage.

The package of Reactter that you will want to install depends on the type of project you are working on.

Select one of the following options to know how to install it:

<details close>
  <summary>
    <b>Dart only&ensp;</b>
    <a href="https://pub.dev/packages/reactter">
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

<p><p/>

<details close>
  <summary>
    <b>Flutter&ensp;</b>
    <a href="https://pub.dev/packages/flutter_reactter">
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

And it is recommended to use
[![Reactter Lint](https://img.shields.io/pub/v/reactter_lint?color=1d7fac&labelColor=29b6f6&label=reactter_lint&logo=dart)](https://pub.dev/packages/reactter_lint)
which will help to encourage good coding practices and prevent frequent problems using the Reactter convensions.

If you use Visual Studio Code, it is a good idea to use [Reactter Snippets](
https://marketplace.visualstudio.com/items?itemName=CarLeonDev.reacttersnippets) for improving productivity.

## About Reactter

Reactter is a light and powerful solution for Dart and Flutter. It is composed of three main concepts that can be used together to create maintainable and scalable applications, which are:

- [State management](#state-management)
- [Dependency injection](#dependency-injection)
- [Event management](#lifecycle-and-event-management)

## State management

In Reactter, state is understood as any object that extends [`ReactterState`](https://pub.dev/documentation/reactter/latest/reactter/ReactterState-class.html), which gives it features such as being able to store one or more values and to notify of its changes.

Reactter offers the following several state managers:

- [Signal](#signal)
- [UseState](#usestate)
- [UseAsyncState](#useasyncstate)
- [UseReducer](#usereducer)
- [UseCompute](#usecompute)

> **NOTE:**
> The hooks (also known as [`ReactterHook`](https://pub.dev/documentation/reactter/latest/reactter/ReactterHook-class.html)) are named with the prefix `Use` according to convention.
>
> **RECOMMENDED:**
> See also [difference between Signal and UseState](#difference-between-signal-and-usestate) and about [custom hooks](#custom-hooks).

### Signal

[`Signal`](https://pub.dev/documentation/reactter/latest/reactter/Signal-class.html) is an object (that extends [`ReactterState`](https://pub.dev/documentation/reactter/latest/reactter/ReactterState-class.html)) which has a `value` and notifies about its changes.

It can be initialized using the extension `.signal`:

```dart
final strSignal = "initial value".signal;
final intSignal = 0.signal;
final userSignal = User().signal;
```

or using the constructor class `Signal<Type>(InitialValue)`:

```dart
final strSignal = Signal<String>("initial value");
final intSignal = Signal<int>(0);
final userSignal = Signal<User>(User());
```

`Signal` has a `value` property that allows to read and write its state:

```dart
intSignal.value = 10;
print("Current state: ${intSignal.value}");
```

or also can use the callable function:

```dart
intSignal(10);
print("Current state: ${intSignal()}");
```

or simply use `.toString()` implicit to get its `value` as String:

```dart
print("Current state: $intSignal");
```

> **NOTE:**
> `Signal` notifies that its `value` has changed when the previous `value` is different from the current `value`.
> If its `value` is an `Object`, it does not detect internal changes, only when `value` is setted to another `Object`.

Use `update` method to notify changes after run a set of instructions:

```dart
userSignal.update((user) {
  user.firstname = "Firstname";
  user.lastname = "Lastname";
});
```

Use `refresh` method to force to notify changes.

```dart
userSignal.refresh();
```

When `value` has changed, the `Signal` will emit the following events(learn about it [here](#lifecycle-and-event-management)):

- `Lifecycle.willUpdate` event is triggered before the `value` change or `update`, `refresh` methods have been invoked.
- `Lifecycle.didUpdate` event is triggered after the `value` change or `update`, `refresh` methods have been invoked.

> **NOTE:**
> When you do any arithmetic operation between two `Signal`s, it returns an `Obj`, for example: `1.signal + 2.signal` returns `3.obj`.
> An [`Obj`](https://pub.dev/documentation/reactter/latest/reactter/Obj-class.html) is like a `Signal` without reactive functionality, but you can convert it to `Signal` using `.toSignal`.

> **NOTE:**
> In flutter, using [`ReactterWatcher`](https://pub.dev/documentation/flutter_reactter/latest/flutter_reactter/ReactterWatcher-class.html), is a way to keep the widgets automatically updates, accessing the value of signal reactively.

### UseState

[`UseState`](https://pub.dev/documentation/reactter/latest/reactter/UseState-class.html) is a hook([`ReactterHook`](https://pub.dev/documentation/reactter/latest/reactter/ReactterHook-class.html)) that allows to declare state variables and manipulate its `value`, which in turn notifies about its changes.

It can be declared inside a class, like this:

```dart
class CounterController {
  final count = UseState(0);
}
```

`UseState` has a `value` property that allows to read and write its state:

```dart
class CounterController {
  final count = UseState(0);

  CounterController() {
    print("Prev state: ${count.value}");
    count.value = 10;
    print("Current state: ${count.value}");
  }
}
```

> **NOTE:**
> `UseState` notifies that its `value` has changed when the previous `value` is different from the current `value`.
> If its `value` is an `Object`, it does not detect internal changes, only when `value` is setted to another `Object`.

Use `update` method to notify changes after run a set of instructions:

```dart
userState.update((user) {
  user.firstname = "Firstname";
  user.lastname = "Lastname";
});
```

Use `refresh` method to force to notify changes.

```dart
userState.refresh();
```

When `value` has changed, the `UseState` will emitted the following events(learn about it [here](#lifecycle-and-event-management)):

- `Lifecycle.willUpdate` event is triggered before the `value` change or `update`, `refresh` methods have been invoked.
- `Lifecycle.didUpdate` event is triggered after the `value` change or `update`, `refresh` methods have been invoked.

### Difference between Signal and UseState

Both `UseState` and `Signal` represent a state (`ReactterState`). But there are a few features that are different between them.

`UseState` is a `ReactterHook`, therefore unlike a `Signal`, it can be extended and given new capabilities.
Use of the `value` attribute is required each time `UseState` reads or writes its state. However, `Signal` eliminates the need for it, making the code easier to understand.

In Flutter, when you want to use `UseState`, you must expose the containing parent class to the widget tree through a `ReactterProvider` or `ReactterComponent` and access it using `BuildContext`. Instead, with `Signal` which is reactive, you simply use `ReactterWatcher`.

But it is not all advantages for `Signal`, although it is good for global states and for improving code readability, it is prone to antipatterns and makes debugging difficult (This will be improved in the following versions).

The decision between which one to use is yours. You can use one or both without them getting in the way. And you can even replace a `UseState` with a `Signal` at any time.

### UseAsyncState

[`UseAsyncState`](https://pub.dev/documentation/reactter/latest/reactter/UseAsyncState-class.html) is a hook ([`ReactterHook`](https://pub.dev/documentation/reactter/latest/reactter/ReactterHook-class.html)) with the same feature as [`UseState`](#usestate) but provides an `asyncValue` method, which will be obtained when `resolve` method is executed.

This is a translate example:

```dart
class TranslateArgs {
  final String text;
  final String from;
  final String to;

  TranslateArgs({ this.text, this.from, this.to, });
}

class TranslateController {
  late final translateState = UseAsyncStates<String?, TranslateArgs>(
    null,
    translate
  );

  TranslateController() {
    translateState.resolve(
      TranslateArgs({
        text: 'Hello world',
        from: 'EN',
        to: 'ES',
      }),
    ).then((_) {
      print("'Hello world' translated to Spanish: '${translateState.value}'");
    });
  }

  Future<String> translate([TranslateArgs args]) async {
    // this is fake code, which simulates a request to API
    return await api.translate(args);
  }
}
```

> **NOTE:**
> If you want to send arguments to the `asyncValue` method, you need to define an argument type which will be send through the `resolve` method. Like the example shown above, the argument type sent is `TranslateArgs` class.

Use the `when` method to return a computed value depending on it's state:

```dart
final computedValue = asyncState.when<String>(
  standby: (value) => "⚓️ Standby: $value",
  loading: (value) => "⏳ Loading...",
  done: (value) => "✅ Resolved: $value",
  error: (error) => "❌ Error: $error",
);
```

When `value` has changed, the `UseAsyncState` will emit the following events (learn about it [here](#lifecycle-and-event-management)):

- `Lifecycle.willUpdate` event is triggered before the `value` change or `update`, `refresh` methods have been invoked.
- `Lifecycle.didUpdate` event is triggered after the `value` change or `update`, `refresh` methods have been invoked.

### UseReducer

[`UseReducer`](https://pub.dev/documentation/reactter/latest/reactter/UseReducer-class.html) is a hook([`ReactterHook`](https://pub.dev/documentation/reactter/latest/reactter/ReactterHook-class.html)) that manages state using reducer method. An alternative to [`UseState`](#usestate).

> **RECOMMENDED:**
> `UseReducer` is usually preferable over `UseState` when you have complex state logic that involves multiple sub-values or when the next state depends on the previous one.

`UseReducer` accepts two arguments:

 ```dart
  UseReducer(<reducer>, <initialState>);
 ```

- The `reducer` method contains your custom state logic that calculates the new state using current state, and actions.
- The `initialState` is a unique value of any type that you use to initialize the state.

`UseReducer` exposes a `dispatch` method that allows you to invoke the `reducer` method sending a `ReactterAction`.

The current state can be accessed through the `value` property.

Here's the counter example using `UseReducer`:

 ```dart
class Store {
  final int count;

  Store({this.count = 0});
}

Store reducer(Store state, ReactterAction<int?> action) {
  switch (action.type) {
    case 'INCREMENT':
      return Store(count: state.count + (action.payload ?? 1));
    case 'DECREMENT':
      return Store(count: state.count + (action.payload ?? 1));
    default:
      throw UnimplementedError();
  }
}

class CounterController {
  final useCounter = UseReducer(reducer, Store(count: 0));

  CounterController() {
    print("count: ${useCounter.value.count}"); // count: 0;
    useCounter.dispatch(ReactterAction(type: 'INCREMENT', payload: 2));
    print("count: ${useCounter.value.count}"); // count: 2;
    useCounter.dispatch(ReactterAction(type: 'DECREMENT'));
    print("count: ${useCounter.value.count}"); // count: 1;
  }
}
 ```

The actions can be created as a callable class, extending from [`ReactterActionCallable`](https://pub.dev/documentation/reactter/latest/reactter/ReactterActionCallable-class.html) and used as follows:

```dart
class Store {
  final int count;

  Store({this.count = 0});
}

class IncrementAction extends ReactterActionCallable<Store, int> {
  IncrementAction({int quantity = 1}) : super(type: 'INCREEMNT', payload: quantity);

  @override
  Store call(Store state) => Store(count: state.count + payload);
}

class DecrementAction extends ReactterActionCallable<Store, int> {
  DecrementAction({int quantity = 1}) : super(type: 'DECREMENT', payload: quantity);

  @override
  Store call(Store state) => Store(count: state.count - payload);
}

Store reducer(Store state, ReactterAction action) =>
  action is ReactterActionCallable ? action(state) : UnimplementedError();

class CounterController {
  final useCounter = UseReducer(reducer , Store(count: 0));

  CounterController() {
    print("count: ${useCounter.value.count}"); // count: 0;
    useCounter.dispatch(IncrementAction(quantity: 2));
    print("count: ${useCounter.value.count}"); // count: 2;
    useCounter.dispatch(DecrementAction());
    print("count: ${useCounter.value.count}"); // count: 1;
  }
}
```

When `value` has changed, the `UseReducer` will emit the following events (learn about it [here](#lifecycle-and-event-management)):

- `Lifecycle.willUpdate` event is triggered before the `value` change or `update`, `refresh` methods have been invoked.
- `Lifecycle.didUpdate` event is triggered after the `value` change or `update`, `refresh` methods have been invoked.

### UseCompute

[`UseCompute`](https://pub.dev/documentation/reactter/latest/reactter/UseCompute-class.html) is a hook([`ReactterHook`](https://pub.dev/documentation/reactter/latest/reactter/ReactterHook-class.html)) that keeps listening for state dependencies changes, to return a computed value from a defined method.

An example is shown below:

```dart
class AppController {
  final stateA = UseState(1);
  final stateB = UseState(7);
  late final computeState = UseCompute(
    () => (stateA + stateB).clamp(10, 15),
    [stateA, stateB],
  );

  AppController() {
    print(computeState.value); // 10;

    // will print: 11, 15, 11
    Reactter.on(
      computeState,
      Lifecycle.didUpdate,
      (_, __) => print(computeState.value),
    );

    stateA.value += 1; // computeState doesn't change, its value is 10
    stateB.value += 2; // computeState changes, its value is 11
    stateA.value += 4; // computeState changes, its value is 15
    stateB.value += 8; // computeState doesn't change, its value is 15
    stateA.value -= 8; // computeState doesn't change, its value is 15
    stateB.value -= 4; // computeState changes, its value is 11
  }
}
```

`UseCompute` has a `value` property which represents the computed value.

> **NOTE:**
> `UseCompute` notifies that its `value` has changed when the previous `value` is different from the current `value`.

When `value` has changed, the `UseState` will emit the following events (learn about it [here](#lifecycle-and-event-management)):

- `Lifecycle.willUpdate` event is triggered before the `value` change or `update`, `refresh` methods have been invoked.
- `Lifecycle.didUpdate` event is triggered after the `value` change or `update`, `refresh` methods have been invoked.

> **NOTE:**
> `UseCompute` is read-only, meaning that its value cannot be changed, except by invoking the `UseCompute` method.

### Custom hooks

Custom hooks are classes that extend [`ReactterHook`](https://pub.dev/documentation/reactter/latest/reactter/ReactterHook-class.html) that follow a special naming convention with the `use` prefix and can contain state logic, effects or any other custom code.

There are several advantages to using Custom Hooks:

- **Reusability**: you can use the same hook again and again, without the need to write it twice.
- **Clean Code**: extracting part of context logic into a hook will provide a cleaner codebase.
- **Maintainability**: easier to maintain. if you need to change the logic of the hook, you only need to change it once.

Here's the counter example:

```dart
class UseCount extends ReactterHook {
  final $ = ReactterHook.$register;

  int _count = 0;
  int get value => _count;

  UseCount(int initial) : _count = initial;

  void increment() => update(() => _count += 1);
  void decrement() => update(() => _count -= 1);
}
```

> **IMPORTANT:**
> To create a `ReactterHook`, you need to register it by adding the following line:
> `final $ = ReactterHook.$register;`
>
> **NOTE:**
> `ReactterHook` provides an `update` method which notifies about its changes.

You can then call that custom hook from anywhere in the code and get access to its shared logic:

```dart
class AppController {
  final count = UseCount(0);

  AppController() {
    Timer.periodic(Duration(seconds: 1), (_) => count.increment());

    // Print count value every second
    Reactter.on(
      count,
      Lifecycle.didUpdate,
      (_, __) => print("Count: ${count.value}",
    );
  }
}
```

## Dependency injection

With Reactter, you can create, delete and access the desired object from a single location, and you can do it from anywhere in the code, thanks to reactter's dependency injection system.

Dependency injection offers several benefits. It promotes the principle of inversion of control, where the control over object creation and management is delegated to Reactter. This improves code modularity, reusability, and testability. It also simplifies the code by removing the responsibility of creating dependencies from individual classes, making them more focused on their core functionality.

Reactter offers the following several instance managers:

- [Shorcuts to manage instances](#shortcuts-to-manage-instances)
- [UseContext](#usecontext)
- [ReactterProvider](#reactterprovider)
- [ReactterProviders](#reactterproviders)
- [ReactterComponent](#reacttercomponent)

### Shortcuts to manage instances

Reactter offers several convenient shortcuts for managing instances:

- **`Reactter.register`**: This method registers a `builder` function, enabling the creation of an instance using `Reactter.get`.

  ```dart
  Reactter.register(builder: () => AppController());
  Reactter.register(id: "uniqueId", builder: () => AppController());
  ```

- **`Reactter.unregister`**: This method removes the `builder` function, preventing the creation of the instance.

  ```dart
  Reactter.unregister<AppController>();
  Reactter.unregister<AppController>("uniqueId");
  ```

- **`Reactter.get`**: This method retrieves a previously created instance or creates a new instance from the `build` registered with `reactter.register`.

  ```dart
  final appController = Reactter.get<AppController>();
  final appControllerWithId = Reactter.get<AppController>('uniqueId');
  ```

- **`Reactter.create`**: This method registers, creates and retrieves the instance directly.

  ```dart
  final appController = Reactter.create(builder: () => AppController());
  final appControllerWithId = Reactter.create(id: 'uniqueId', builder: () => AppController());
  ```

- **`Reactter.delete`**: This method deletes the instance but keeps the `builder` function.

  ```dart
  Reactter.delete<AppController>();
  Reactter.delete<AppController>('uniqueId');
  ```

> **NOTE:**
> The scope of the registered instances is global.
> This indicates that using `Reactter.get` or [`UseContext`](#usecontext) will allow you to access them from anywhere in the project.

### UseContext

[`UseContext`](https://pub.dev/documentation/reactter/latest/reactter/UseContext-class.html) is a hook([`ReactterHook`](https://pub.dev/documentation/reactter/latest/reactter/ReactterHook-class.html)) that allows to get the `T` instance with/without `id` from the dependency store when it's ready.

```dart
class AppController {
  final useAuthController = UseContext<AuthController>();
  // final useOtherControllerWithId = UseContext<OtherController>("UniqueId");

  AuthController? authController = useAuthController.instance;

  AppController() {
    UseEffect(() {
      authController = useAuthController.instance;
    }, [useAuthController]);
  }
}
```

Use `instance` getter to get the `T` instance.

Use [`UseEffect`](#useeffect) hook as shown in the example above, to wait for the `instance` to be created.

> **NOTE:**
> The instance that you need to get, must be created by [`Dependency injection`](#dependency-injection) before.

### ReactterProvider

[`ReactterProvider`](https://pub.dev/documentation/flutter_reactter/latest/flutter_reactter/ReactterProvider-class.html) is a Widget (exclusive of `flutter_reactter`) that hydrates from an `T` instance to the Widget tree. The `T` instance can be accessed through methods [BuildContext extension](#buildcontext-extension):

```dart
ReactterProvider<CounterController>(
  () => CounterController(),
  builder: (counterController, context, child) {
    context.watch<CounterController>();
    // `context.watch` listens any CounterController changes for rebuild
    return Text("count: ${counterController.count.value}");
  },
)
```

Uses `id` property to identify the `T` instance.

Use the `child` property to pass a Widgetthat will be built only once.
It will be sent through the `builder` method, so you can incorporate it into your build.

> **RECOMMENDED:**
> Don't use Object with constructor parameters to prevent conflicts.
>
> **NOTE:** `ReactteProvider` is "scoped". So, the `builder` method will be rebuild when the instance or any `ReactterState` specified using the watch methods of [BuildContext extension](#buildcontext-extension) changes.

### ReactterProviders

[`ReactterProviders`](https://pub.dev/documentation/flutter_reactter/latest/flutter_reactter/ReactterProviders-class.html) is a Widget (exclusive of `flutter_reactter`) that allows to use multiple [`ReactterProvider`](#reactterprovider) in a nested way.

```dart
ReactterProviders(
  [
    ReactterProvider(
      () => AppController(),
    ),
    ReactterProvider(
      () => ConfigContext(),
      id: 'App',
    ),
    ReactterProvider(
      () => ConfigContext(),
        id: 'Dashboard'
    ),
  ],
  builder: (context, child) {
    final appController = context.use<AppController>();
    final appConfigContext = context.use<ConfigContext>('App');
    final dashboardConfigContext = context.use<ConfigContext>('Dashboard');
    ...
  },
)
```

> **RECOMMENDED:**
> Don't use Object with constructor parameters to prevent conflicts.
>
> **NOTE:** `ReactteProviders` is "scoped". So, the `builder` method will be rebuild, when the instance or any `ReactterState` specified using the watch methods of [BuildContext extension](#buildcontext-extension) changes.

### ReactterComponent

[`ReactterComponent`](https://pub.dev/documentation/flutter_reactter/latest/widgets/ReactterComponent-class.html) is a Widget (exclusive of `flutter_reactter`) that provides [`ReactterProvider`](#reactterprovider) features, whose `T` instance defined is exposed trough render method.

```dart
class CounterComponent extends ReactterComponent<CounterController> {
  const CounterComponent({Key? key}) : super(key: key);

  @override
  get builder => () => CounterController();

  @override
  void listenStates(counterController) => [counterController.count];

  @override
  Widget render(counterController, context) {
    return Text("Count: ${counterController.count.value}");
  }
}
```

Use `builder` getter to define the instance creating method.

> **NOTE:**
> If you don't use `builder` getter, the instance `T` is not created. Instead, an attempt will be made to locate it within the closest ancestor where it was initially created.
> **RECOMMENDED:**
> Don't use Object with constructor parameters to prevent conflicts.

Use `id` getter to identify the `T` instance:

Use `listenStates` getter to define the states and with its changes rebuild the Widget tree defined in the `render` method.

Use `listenAll` getter as `true` to listen to all the `T` instance changes to rebuild the Widget tree defined in the `render` method.

## LifeCycle and event management

In Reactter, the states ([`ReactterState`](#state-management)) and the instances (managed by the [`dependency injection`](#dependency-injection)) contain different stages, also known as [`LifeCycle`](https://pub.dev/documentation/reactter/latest/reactter/Lifecycle.html). This lifecycles linked events are as follows:

- **`Lifecycle.registered`**: This event is triggered when the instance has been registered.
- **`Lifecycle.unregistered`**: This event is triggered when the instance is no longer registered.
- **`Lifecycle.initialized`**: This event is triggered when the instance has been initialized.
- **`Lifecycle.willMount`**: This event(exclusive of `flutter_reactter`) happens when the instance is going to be mounted in the widget tree.
- **`Lifecycle.didMount`**: This event(exclusive of `flutter_reactter`) happens after the instance has been successfully mounted in the widget tree.
- **`Lifecycle.willUpdate`**: This event is triggered anytime the instance's state is about to be updated. The event parameter is a `ReactterState`.
- **`Lifecycle.didUpdate`**: This event is triggered anytime the instance's state has been updated. The event parameter is a `ReactterState`.
- **`Lifecycle.willUnmount`**: This event(exclusive of `flutter_reactter`) happens when the instance is about to be unmounted from the widget tree.
- **`Lifecycle.destroyed`**: This event is triggered when the instance has been destroyed.

Reactter offers the following several event managers:

- [Shortcuts to manage events](#shortcuts-to-manage-instances)
- [UseEvent](#useevent)
- [UseEffect](#useeffect)
- [ReactterConsumer](#reactterconsumer)
- [ReactterWatcher](#reactterwatcher)
- [BuildContext extension](#buildcontext-extension)

### Shortcuts to manage events

Reactter offers several convenient shortcuts for managing events:

- **`Reactter.on(<Object inst>, <enum event>, <Fuction callback>)`**: Turns on the listen event. When the event(`enum`) of instance(`Object`) is emitted, the `callback` is called:

  ```dart
  void onDidUpdate(inst, state) => print("Instance: $inst, state: $state");

  final appController = Reactter.get<AppController>();
  Reactter.on(appController, Lifecycle.didUpdate, onDidUpdate);
  // or
  Reactter.on(ReactterInstance<AppController>(), Lifecycle.didUpdate, onDidUpdate);
  ```

- **`Reactter.one(<Object inst>, <enum event>, <Fuction callback>)`**: Turns on the listen event for only once. After the event(`enum`) of instance(`Object`) is emitted, the `callback` is called and ended.

  ```dart
  void onDidUpdate(inst, state) => print("Instance: $inst, state: $state");

  final appController = Reactter.get<AppController>();
  Reactter.on(appController, Lifecycle.didUpdate, onDidUpdate);
  // or
  Reactter.on(ReactterInstance<AppController>(), Lifecycle.didUpdate, onDidUpdate);
  ````

- **`Reactter.off(<Object inst>, <enum event>, <Fuction callback>)`**: Removes the `callback` from event(`enum`) of instance(`Object`).

  ```dart
  Reactter.off(appController, Lifecycle.didUpdate, onDidUpdate);
  // or
  Reactter.off(ReactterInstance<AppController>(), Lifecycle.didUpdate, onDidUpdate);
  ```

- **`Reactter.emit(<Object inst>, <enum event>, <dynamic param>)`**: Triggers an event(`enum`) of instance(`Object`) with or without the `param` given.

  ```dart
  Reactter.emit(appController, CustomEnum.EventName, "test param");
  // or
  Reactter.emit(ReactterInstance<AppController>(), CustomEnum.EventName, "test param");
  ```

- **`Reactter.emitAsync(<Object inst>, <enum event>, <dynamic param>)`**: Triggers an event(`enum`) of instance(`Object`) with or without the `param` given as async way.

  ```dart
  await Reactter.emitAsync(appController, CustomEnum.EventName, "test param");
  // or
  await Reactter.emitAsync(ReactterInstance<AppController>(), CustomEnum.EventName, "test param");
  ```

> **NOTE:**
> The `ReactterInstance` helps to find the instance for event.
>
> **RECOMMENDED:**
> Use the instance directly on event methods for optimal performance.

### UseEvent

[`UseEvent`](https://pub.dev/documentation/reactter/latest/reactter/UseEvent-class.html) is a hook ([`ReactterHook`](https://pub.dev/documentation/reactter/latest/reactter/ReactterHook-class.html)) that allows to manager events.

Use the `on` method to listen for instance's event:

```dart
enum Events { SomeEvent };

void onSomeEvent(inst, param) {
  print("$inst's Events.SomeEvent emitted with param: $param.");
}

UseEvent<AppController>().on(Events.SomeEvent, onSomeEvent);
```

Use the `off` method to stop listening to instance's event:

```dart
UseEvent<AppController>().off(Events.SomeEvent, onSomeEvent);
```

Use the `one` method to listen for instance's event once:

```dart
UseEvent<AppController>().one(Events.SomeEvent, onSomeEvent);
```

Use the `emit` method to trigger an instance event:

```dart
UseEvent<AppController>().emit(Events.SomeEvent, 'Parameter');
```

> **IMPORTANT:** Don't forget to remove event using `off` or using `dispose` to remove all instance's events.
> Failure to do so could increase memory usage or have unexpected behaviors, such as events in permanent listening.
>
> **RECOMMENDED:** If you have the instance, use it directly with `UseEvent.withInstance(<instance>)` for optimal performance.

### UseEffect

[`UseEffect`](https://pub.dev/documentation/reactter/latest/reactter/UseEffect-class.html) is a hook([`ReactterHook`](https://pub.dev/documentation/reactter/latest/reactter/ReactterHook-class.html)) that allows to manage side-effect.

```dart
UseEffect(
  <<Function cleanup> Function callback>,
  <ReactterState dependencies>[],
  <Object instance>,
)
```

The side-effect logic into the `callback` function is executed when `dependencies` (List of `ReactterState`) argument changes or `instance` (Object) trigger `LifeCycle.didMount` event.

If the `callback` returns a function, then `UseEffect` considers this as an `effect cleanup`.
The `cleanup` callback is executed, before `callback` is called or `instance`(Object) trigger `LifeCycle.willUnmount` event:

Let's see an example with a counter that increments every second:

```dart
class AppController {
  final count = UseState(0);

  AppController() {
    UseEffect((){
      // Execute by count state changed or 'LifeCycle.didMount' event
      print("Count: ${count.value}");
      Future.delayed(const Duration(seconds: 1), () => count.value += 1);

      return () {
        // Cleanup - Execute before count state changed or 'LifeCycle.willUnmount' event
        print("Cleanup executed");
      };
    }, [count], this);
  }
}
```

Use `UseEffect.dispatchEffect` instead of instance argument to execute a `UseEffect` immediately.

```dart
UseEffect(
  () => print("Excute immediately or by hook changes"),
  [someState],
  UseEffect.dispatchEffect
);
```

> **NOTE:**
> If you don't add an `instance` argument to `UseEffect`, the `callback` won't execute on lifecycle `didMount`, and the `cleanup` won't execute on lifecycle `willUnmount` (theses `LifeCycle` events are used with `flutter_reactter` only).

### ReactterConsumer

[`ReactterConsumer`](https://pub.dev/documentation/flutter_reactter/latest/flutter_reactter/ReactterConsumer-class.html) is a Widget (exclusive of `flutter_reactter`) that allows to access the `T` instance from `ReactterProvider`'s nearest ancestor and can listen all or specified states to rebuild the Widget when theses changes occur:

```dart
class SomeWidget extends StatelessWidget {
  ...
  Widget build(context) {
    return ReactterConsumer<AppController>(
      builder: (appController, context, child) {
        // This is built once only.
        return Text("My instance: $appContoller");
      }
    );
  }
}
```

Use `listenAll` property as `true` to listen all the `T` instance changes to rebuild the Widget tree defined in `builder` method:

```dart
class SomeWidget extends StatelessWidget {
  ...
  Widget build(context) {
    return ReactterConsumer<AppController>(
      listenAll: true,
      builder: (appController, context, child) {
        // This is built every change that occurs.
        return Text("My instance: $appContoller  - ${DateTime.now()}");
      }
    );
  }
}
```

Use `listenStates` property to define the states and with its changes rebuild the Widget tree defined in `builder` method:

```dart
class SomeWidget extends StatelessWidget {
  ...
  Widget build(context) {
    return ReactterConsumer<AppController>(
      listenStates: (inst) => [inst.stateA, inst.stateB],
      builder: (appController, context, child) {
        // This is built when stateA or stateB has changed.
        return Column(
          children: [
            Text("My instance: $appContoller"),
            Text("StateA: ${appContoller.stateA.value}"),
            Text("StateB: ${appContoller.stateB.value}"),
          ],
        );
      }
    );
  }
}
```

> **NOTE:** You can use [`List<ReactterState>.when`](https://pub.dev/documentation/flutter_reactter/latest/flutter_reactter/ReactterStateListExtension/when.html) extension for more specific conditional state when you want the widget tree to be re-rendered. For example:

```dart

class SomeWidget extends StatelessWidget {
  ...
  Widget build(context) {
    return ReactterConsumer<AppController>(
      listenStates: (inst) => [inst.stateA, inst.stateB].when(
        () => inst.stateA.value == inst.stateB.value, // condition
        // The following condition functions as `or` like:
        // condition || condition2 || condition3
        () => inst.stateA.value == 'X', // condition2
        () => inst.stateB.value == 'Y', // condition3
      ),
      builder: (appController, context, child) {
        // This is built according to the above conditions.
        return Column(
          children: [
            Text("My instance: $appContoller"),
            Text("StateA: ${appContoller.stateA.value}"),
            Text("StateB: ${appContoller.stateB.value}"),
          ],
        );
      }
    );
  }
}
```

Uses `id` property to identify the `T` instance.

Use `child` property to pass a Widget which to be built once only.
It will be sent through the `builder` method, so you can incorporate it into your build.

### ReactterWatcher

[`ReactterWatcher`](https://pub.dev/documentation/flutter_reactter/latest/flutter_reactter/ReactterWatcher-class.html) is a Widget (exclusive of `flutter_reactter`) that allows to listen all `Signal`s contained in `builder` property and rebuilt the Widget when it changes:

```dart
final count = 0.signal;
final flag = false.signal;

void increase() => count.value += 1;
void toggle() => flag(!flag.value);

class App extends StatelessWidget {
  ...
  Widget build(context) {
    return ReactterWatcher(
      // This widget is rendered once only and passed through the `builder` method.
      child: Row(
        children: const [
          ElevatedButton(
            onPressed: increase,
            child: Text("Increase"),
          ),
          ElevatedButton(
            onPressed: toggle,
            child: Text("Toogle"),
          ),
        ],
      ),
      builder: (context, child) {
        // Rebuilds the Widget tree returned when `count` or `flag` are updated.
        return Column(
          children: [
            Text("Count: $count"),
            Text("Flag is: $flag"),
            // Takes the Widget from the `child` property in each rebuild.
            child,
          ],
        );
      },
    );
  }
}
```

### BuildContext extension

Reactter provides additional methods through `BuildContext` to access to instance. These are following:

- **`context.watch`**: Gets the `T` instance from `ReactterProvider`'s nearest ancestor and listens any instance changes or `ReactterState` changes declared in first paramater.

```dart
// listens any `AppController` changes
final appController = context.watch<AppController>();
// listens the states changes declared in first paramater.
final appController = context.watch<AppController>(
  (inst) => [inst.stateA, inst.stateB],
);
```

> **NOTE:** You can use [`List<ReactterState>.when`](https://pub.dev/documentation/flutter_reactter/latest/flutter_reactter/ReactterStateListExtension/when.html) extension for more specific conditional state when you want the widget tree to be re-rendered. For example:

```dart
final appController = context.watch<AppController>(
  (inst) => [inst.stateA, inst.stateB].when(
    () => inst.stateA.value == inst.stateB.value, // condition
    // The following condition functions as `or` like:
    // condition || condition2 || condition3
    () => inst.stateA.value == 'X', // condition2
    () => inst.stateB.value == 'Y', // condition3
  ),
);
```


- **`context.watchId`**: Gets the `T` instance by `id` from `ReactterProvider`'s nearest ancestor and listens instance changes or `ReactterState` changes declared in second paramater.

```dart
// listens any `ResourceController` by `id` changes
final resourceController = context.watchId<ResourceController>('UniqueId');
// listens the states changes declared in second paramater.
final resourceController = context.watchId<ResourceController>(
  'UniqueId',
  (inst) => [inst.stateA, inst.stateB],
);
```

- **`context.use`**: Gets the `T` instance with/without `id` from `ReactterProvider`'s nearest ancestor.

```dart
final appController = context.use<AppController>();
final resourceController = context.use<ResourceController>('UniqueId');
```

> **NOTE:**
> These methods mentioned above uses [`ReactterProvider.contextOf`](https://pub.dev/documentation/flutter_reactter/latest/flutter_reactter/ReactterProvider/contextOf.html)
>
> **NOTE:**
> `context.watch` and `context.watchId` watch all or some of the specified [`ReactterState`](https://pub.dev/documentation/reactter/latest/reactter/ReactterState-mixin.html) dependencies, when any it will changes, re-built the Widgets tree in the scope of [`ReactterProvider`](#reactterprovider), [`ReactterComponent`](#reacttercomponent) or any Widget that exposes the `BuildContext` like `Build`, `StatelessWidget`, `StatefulWidget`.
>
> **NOTE:**
> A [`ReactterState`](#state-management) can be a [`Signal`](#signal) or [`ReactterHook`](https://pub.dev/documentation/reactter/latest/reactter/ReactterHook-class.html) (like [`UseState`](#usestate), [`UseAsynState`](#useasyncstate), [`UseReducer`](#usereducer) or another [Custom hooks](#custom-hooks)).

## Resources

- Documentation
  - [Reactter](https://pub.dev/documentation/reactter/latest)
  - [Flutter Reactter](https://pub.dev/documentation/flutter_reactter/latest)
- [Examples](https://github.com/2devs-team/reactter/tree/master/packages/flutter_reactter/example)

## Contribute

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
- Translate documentation.
- Write articles or make videos teaching how to use **[Reactter](https://github.com/2devs-team/reactter)**.

Any idea is welcome!

## Authors

- **[Carlos León](https://twitter.com/CarLeonDev)** - <carleon.dev@gmail.com>
- **[Leo Castellanos](https://twitter.com/leoocast10)** - <leoocast.dev@gmail.com>
