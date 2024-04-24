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

**A light, powerful and quick Reactive State Management, Dependency Injection and Event Handler.**

## Features

- ⚡️ Engineered for **Speed**.
- ⚖️ Super **Lightweight**([🥇 See benchmarks](https://github.com/CarLeonDev/state_managements#memory-size)).
- 📏 **Reduce Boilerplate Code** significantly([🥇 See benchmarks](https://github.com/CarLeonDev/state_managements#lines-number)).
- ✏️ Improve **Code Readability**.
- 💧 **Flexible** and **Adaptable** to any architecture.
- ☢️ **Reactive States** using [Signal](#signal) and Hooks.
- ♻️ **Reusable States and Logic** with [Custom hooks](#custom-hooks).
- 🎮 Fully **[Rendering Control](#rendering-control)**.
- 🧪 Fully **Testable**, 100% code coverage.
- 🪄 **Zero Configuration** and **No Code Generation** necessary.
- 💙 **Compatible with Dart and Flutter**, supports the latest version of Dart.

Let's see a small and simple example:

```dart
// Create a reactive state using `Signal`
final count = Signal(0);

void main() {
  // Change the `value` in any time(e.g., each 1 second).
  Timer.periodic(
    Duration(seconds: 1), 
    (_) => count.value++,
  );

  // Put on listen `didUpdate` event, whitout use `Stream`
  Reactter.on(
    count,
    Lifecycle.didUpdate,
    (_, __) => print('Count: $count'),
  );

  // And you can use in flutter, e.g:
  runApp(
    MaterialApp(
      home: Scaffold(
        body: ReactterWatcher(
          // Just use it, and puts it in listening mode
          // for further rendering automatically.
          builder: (_, __) => Text("Count: $count"),
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
  - [UseAsyncState](#useasyncstate)
  - [UseReducer](#usereducer)
  - [UseCompute](#usecompute)
- [Dependency injection](#dependency-injection)
  - [Builder](#builder)
  - [Factory](#factory)
  - [Singleton](#singleton)
  - [Shortcuts to manage instances](#shortcuts-to-manage-instances)
  - [UseInstance](#useinstance)
- [Event handler](#event-handler)
  - [Lifecycles](#lifecycles)
  - [Shortcuts to manage events](#shortcuts-to-manage-events)
  - [UseEffect](#useeffect)
- [Rendering control](#rendering-control) (`flutter_reactter`)
  - [ReactterProvider](#reactterprovider)
  - [ReactterProviders](#reactterproviders)
  - [ReactterComponent](#reacttercomponent)
  - [ReactterConsumer](#reactterconsumer)
  - [ReactterWatcher](#reactterwatcher)
  - [ReactterSelector](#reactterselector)
  - [BuildContext.use](#buildcontextuse)
  - [BuildContext.watch](#buildcontextwatch)
  - [BuildContext.select](#buildcontextselect)
- [Custom hooks](#custom-hooks)
- [Lazy state](#lazy-state)
- [Batch](#batch)
- [Untracked](#untracked)
- [Generic arguments](#generic-arguments)
- [Memo](#memo)
- [Difference between Signal and UseState](#difference-between-signal-and-usestate)
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

If you use Visual Studio Code, it is a good idea to use [Reactter Snippets](https://marketplace.visualstudio.com/items?itemName=CarLeonDev.reacttersnippets) for improving productivity.

## About Reactter

Reactter is a light and powerful solution for Dart and Flutter. It is composed of three main concepts that can be used together to create maintainable and scalable applications, which are:

- [State management](#state-management)
- [Dependency injection](#dependency-injection)
- [Event handler](#event-handler)

Moreover, Reactter offers an extensive collection of widgets and extensions, granting advanced [rendering control](#rendering-control) through the `flutter_reactter` package.

## State management

In Reactter, state is understood as any object that extends [`ReactterState`](https://pub.dev/documentation/reactter/latest/reactter/ReactterState-class.html), endowing it with capabilities such as the ability to store one or more values and to broadcast notifications of its changes.

Reactter offers the following several state managers:

- [Signal](#signal)
- [UseState](#usestate)
- [UseAsyncState](#useasyncstate)
- [UseReducer](#usereducer)
- [UseCompute](#usecompute)

> **NOTE:**
> The hooks (also known as [`ReactterHook`](https://pub.dev/documentation/reactter/latest/reactter/ReactterHook-class.html)) are named with the prefix `Use` according to convention.

> **RECOMMENDED:**
> See also [difference between Signal and UseState](#difference-between-signal-and-usestate) and about [custom hooks](#custom-hooks).

### Signal

[`Signal`](https://pub.dev/documentation/reactter/latest/reactter/Signal-class.html) is an object (that extends [`ReactterState`](https://pub.dev/documentation/reactter/latest/reactter/ReactterState-class.html)) which has a `value` and notifies about its changes.

It can be initialized using the constructor class `Signal<T>(T initialValue)`:

```dart
final intSignal = Signal<int>(0);
final strSignal = Signal("initial value");
final userSignal = Signal(User());
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
> When you do any arithmetic operation between two `Signal`s, it returns an `Obj`, for example: `signal(1) + Signal(2)` returns `Obj(3)`.
> An [`Obj`](https://pub.dev/documentation/reactter/latest/reactter/Obj-class.html) is like a `Signal` without reactive functionality, but you can convert it to `Signal` using `.toSignal`.

> **NOTE:**
> In flutter, using [`ReactterWatcher`](https://pub.dev/documentation/flutter_reactter/latest/flutter_reactter/ReactterWatcher-class.html), is a way to keep the widgets automatically updates, accessing the value of signal reactively.

### UseState

[`UseState`](https://pub.dev/documentation/reactter/latest/reactter/UseState-class.html) is a hook([`ReactterHook`](https://pub.dev/documentation/reactter/latest/reactter/ReactterHook-class.html)) that allows to declare state variables and manipulate its `value`, which in turn notifies about its changes.

```dart
UseState<T>(T initialValue)
```

`UseState` accepts a property:

- `initialValue`: is a unique value of any type that you use to initialize the state.

It can be declared inside a class, like this:

```dart
class CounterController {
  final count = UseState(0);
}
```

> **NOTE:**
> if your variable hook is `late` use `Reactter.lazyState`. Learn about it [here](#lazy-state).

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

### UseAsyncState

[`UseAsyncState`](https://pub.dev/documentation/reactter/latest/reactter/UseAsyncState-class.html) is a hook ([`ReactterHook`](https://pub.dev/documentation/reactter/latest/reactter/ReactterHook-class.html)) with the same feature as [`UseState`](#usestate) but its value will be lazily resolved by a function(`asyncFunction`).

```dart
UseAsyncState<T>(
  T initialValue,
  Future<T> asyncFunction(),
);
```

`UseAsyncState` accepts theses properties:

- `initialValue`: is a unique value of any type that you use to initialize the state.
- `asyncFunction`: is a function that will be called by the `resolved` method and sets the value of the state.

Use `UseAsyncState.withArg` to pass a argument to the `asyncFunction`.

```dart
UseAsyncState.withArg<T, A>(
  T initialValue,
  Future<T> asyncFunction(A) ,
)
```

> **NOTE:**
> if your variable hook is `late` use `Reactter.lazyState`. Learn about it [here](#lazy-state).

This is a translate example:

```dart
class TranslateController {
  final translateState = UseAsyncStates.withArg(
    null,
    (ArgsX3<String> args) async {
      final text = args.arg;
      final from = args.arg2;
      final to = args.arg3;
      // this is fake code, which simulates a request to API
      return await api.translate(text, from, to);
    }
  );

  TranslateController() {
    translateState.resolve(
      Args3('Hello world', 'EN','ES'),
    ).then((_) {
      print("'Hello world' translated to Spanish: '${translateState.value}'");
    });
  }
}
```

> **RECOMMENDED:**
> If you wish to optimize the state resolution, the best option is to use the memoization technique. Reactter provides this using `Memo`(Learn about it [here](#memo)), e.g:
>
> ```dart
> [...]
> final translateState = UseAsyncState.withArg<String?, ArgsX3<String>>(
>   null,
>   /// `Memo` stores the value resolved in cache,
>   /// and retrieving that same value from the cache the next time
>   /// it's needed instead of resolving it again.
>   Memo.inline(
>     (ArgsX3<String> args) async {
>       final text = args.arg;
>       final from = args.arg2;
>       final to = args.arg3;
>       // this is fake code, which simulates a request to API
>       return await api.translate(text, from, to);
>     },
>     AsyncMemoSafe(), // avoid to save in cache when throw a error
>   ),
> );
> [...]
> ```

> **RECOMMENDED:**
> In the above example uses `Args`([generic arguments](#generic-arguments)), but using [Record](https://dart.dev/language/records#record-types) instead is recommended if your project supports it.

Use the `when` method to return a computed value depending on it's state:

```dart
final computedValue = asyncState.when<String>(
  standby: (value) => "🔵 Standby: $value",
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

 ```dart
  UseReducer<T>(
    T reducer(T state, ReactterAction<dynamic> action),
    T initialState,
  );
 ```

`UseReducer` accepts two properties:

- `reducer`: is a method contains your custom state logic that calculates the new state using current state, and actions.
- `initialState`: is a unique value of any type that you use to initialize the state.

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
class IncrementAction extends ReactterActionCallable<Store, int> {
  IncrementAction([int quantity = 1]) : super(
    type: 'INCREEMNT', payload: quantity
  );

  @override
  Store call(Store state) => Store(count: state.count + payload);
}

class DecrementAction extends ReactterActionCallable<Store, int> {
  DecrementAction([int quantity = 1]) : super(
    type: 'DECREMENT', payload: quantity
  );

  @override
  Store call(Store state) => Store(count: state.count - payload);
}

Store reducer(Store state, ReactterAction action) {
  if (action is ReactterActionCallable) return action(state);

  return  UnimplementedError();
}

class CounterController {
  final useCounter = UseReducer(reducer , Store(count: 0));

  CounterController() {
    print("count: ${useCounter.value.count}"); // count: 0;
    useCounter.dispatch(IncrementAction(2));
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

[`UseCompute`](https://pub.dev/documentation/reactter/latest/reactter/UseCompute-class.html) is a hook([`ReactterHook`](https://pub.dev/documentation/reactter/latest/reactter/ReactterHook-class.html)) that keeps listening for state `dependencies` changes, to return a computed value(`T`) from a defined method(`computeValue`).

```dart
UseCompute<T>(
  T computeValue(),
  List<ReactterState> dependencies,
)
```

`UseCompute` accepts two arguments:

- `computeValue`: is a method is called whenever there is a change in any of the `dependencies`,  and it is responsible for calculating and setting the computed value.
- `dependencies`: is a list of states that `UseCompute` keeps an active watch on, listening for any changes that may occur for calling the `computeValue` function.

so, here is an example:

```dart
class MyController {
  final stateA = UseState(1);
  final stateB = UseState(7);

  late final computeState = Reactter.lazyState(
    () => UseCompute(
      // The `clamp` is a method that returns this num clamped
      // to be in the range lowerLimit-upperLimit(e.g., 10-15).
      () => addAB().clamp(10, 15),
      [stateA, stateB],
    ),
  );

  int addAB() => stateA.value + stateB.value;
  void printResult() => print("${addAB()} -> ${computeState.value}");

  MyController() {
    printResult(); // 8 -> 10
    stateA.value += 1; // Will not notify change
    printResult(); // 9 -> 10
    stateB.value += 2; // Will notify change
    printResult(); // 11 -> 11
    stateA.value += 6; // Will notify change
    printResult(); // 17 -> 15
    stateB.value -= 1; // Will not notify change
    printResult(); // 16 -> 15
    stateA.value -= 8; // Will notify change
    printResult(); // 8 -> 10
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
> `UseCompute` is read-only, meaning that its value cannot be changed, except by invoking the `computeValue` method.

> **RECOMENDED:**
> `UseCompute` does not cache the computed value, meaning it recalculates the value when its depenencies has changes, potentially impacting performance, especially if the computation is expensive. In these cases, you should consider using `Memo`(learn about it [here](#memo)) in the following manner:

```dart
  late final myUseComputeMemo = Reactter.lazyState((){
    final addAB = Memo(
      (Args2 args) => args.arg1 + args.arg2,
    );

    return UseCompute(
      () => addAB(
        Args2(stateA.value, stateB.value),
      ),
      [stateA, stateB],
    ),
  }, this);
```

## Dependency injection

With Reactter, you can create, delete and access the desired object from a single location, and you can do it from anywhere in the code, thanks to reactter's dependency injection system.

Dependency injection offers several benefits. It promotes the principle of inversion of control, where the control over object creation and management is delegated to Reactter. This improves code modularity, reusability, and testability. It also simplifies the code by removing the responsibility of creating dependencies from individual classes, making them more focused on their core functionality.

Reactter has three ways to manage an instance, which are:

- [Builder](#builder)
- [Factory](#factory)
- [Singleton](#singleton)

Reactter offers the following several instance managers:

- [Shorcuts to manage instances](#shortcuts-to-manage-instances)
- [UseInstance](#useinstance)

by `flutter_reactter`:

- [ReactterProvider](#reactterprovider)
- [ReactterProviders](#reactterproviders)
- [ReactterComponent](#reacttercomponent)
- [BuildContext.use](#buildcontextuse)

### Builder

Builder is a ways to manage an instance, which registers a builder function and creates the instance, unless it has already done so.

In builder mode, when the dependency tree no longer needs it, it is completely deleted, including deregistration (deleting the builder function).

Reactter identifies the builder mode as [`InstanceManageMode.builder`](https://pub.dev/documentation/reactter/6.0.0/InstanceManageMode/InstanceManageMode.builder.html) and it's using for default.

> **NOTE:**
> **Builder** uses less RAM than [Factory](#factory) and [Singleton](#singleton), but it consumes more CPU than the other modes.

### Factory

Factory is a ways to manage an instance, which registers a builder function only once and creates the instance if not already done.

In factory mode, when the dependency tree no longer needs it, the instance is deleted and the builder function is kept in the register.

Reactter identifies the factory mode as [`InstanceManageMode.factory`](https://pub.dev/documentation/reactter/6.0.0/InstanceManageMode/InstanceManageMode.factory.html) and to active it, set it in the `mode` argument of `Reactter.register` and `Reactter.create`, or  use `Reactter.lazyFactory`,  `Reactter.factory`.

> **NOTE:**
> **Factory** uses more RAM than [Builder](#builder) but not more than [Singleton](#singleton), and consumes more CPU than [Singleton](#singleton) but not more than [Builder](#builder).

### Singleton

Singleton is a ways to manage an instance, which registers a builder function and creates the instance only once.

The singleton mode preserves the instance and its states, even if the dependency tree stops using it.

Reactter identifies the singleton mode as [`InstanceManageMode.singleton`](https://pub.dev/documentation/reactter/6.0.0/InstanceManageMode/InstanceManageMode.singleton.html) and to active it, set it in the `mode` argument of `Reactter.register` and `Reactter.create`, or use `Reactter.lazySingleton`, `Reactter.singleton`.

> **NOTE:**
> Use `Reactter.destroy` if you want to force destroy the instance and its register.

> **NOTE:**
> **Singleton** consumes less CPU than [Builder](#builder) and [Factory](#factory), but uses more RAM than the other modes.

### Shortcuts to manage instances

Reactter offers several convenient shortcuts for managing instances:

- [`Reactter.register`](https://pub.dev/documentation/reactter/latest/reactter/ReactterInstanceManager/register.html): Registers a builder function, for creating a new instance using `[Reactter|UseInstance].[get|create|builder|factory|singleton]`.
- [`Reactter.lazyBuilder`](https://pub.dev/documentation/reactter/latest/reactter/ReactterInstanceManager/lazyBuilder.html): Registers a builder function, for creating a new instance as [Builder](#builder) mode using `[Reactter|UseInstance].[get|create|builder]`.
- [`Reactter.lazyFactory`](https://pub.dev/documentation/reactter/latest/reactter/ReactterInstanceManager/lazyFactory.html): Registers a builder function, for creating a new instance as [Factory](#factory) mode using `[Reactter|UseInstance].[get|create|factory]`.
- [`Reactter.lazySingleton`](https://pub.dev/documentation/reactter/latest/reactter/ReactterInstanceManager/lazySingleton.html): Registers a builder function, for creating a new instance as [Singleton](#singleton) mode using `[Reactter|UseInstance].[get|create|singleton]`.
- [`Reactter.create`](https://pub.dev/documentation/reactter/latest/reactter/ReactterInstanceManager/create.html): Registers, creates and returns the instance directly.
- [`Reactter.builder`](https://pub.dev/documentation/reactter/latest/reactter/ReactterInstanceManager/builder.html): Registers, creates and returns the instance as [Builder](#builder) directly.
- [`Reactter.factory`](https://pub.dev/documentation/reactter/latest/reactter/ReactterInstanceManager/factory.html): Registers, creates and returns the instance as [Factory](#factory) directly.
- [`Reactter.singleton`](https://pub.dev/documentation/reactter/latest/reactter/ReactterInstanceManager/singleton.html): Registers, creates and returns the instance as [Singleton](#singleton) directly.
- [`Reactter.get`](https://pub.dev/documentation/reactter/latest/reactter/ReactterInstanceManager/get.html): Returns a previously created instance or creates a new instance from the builder function registered by `[Reactter|UseInstance].[register|lazyBuilder|lazyFactory|lazySingleton]`.
- [`Reactter.delete`](https://pub.dev/documentation/reactter/latest/reactter/ReactterInstanceManager/delete.html): Deletes the instance but keeps the builder function.
- [`Reactter.unregister`](https://pub.dev/documentation/reactter/latest/reactter/ReactterInstanceManager/factory.html): Removes the builder function, preventing the creation of the instance.
- [`Reactter.destroy`](https://pub.dev/documentation/reactter/latest/reactter/ReactterInstanceManager/destroy.html): Destroys the instance and the builder function.
- [`Reactter.find`](https://pub.dev/documentation/reactter/latest/reactter/ReactterInstanceManager/find.html): Gets the instance.
- [`Reactter.isRegistered`](https://pub.dev/documentation/reactter/latest/reactter/ReactterInstanceManager/isRegistered.html): Checks if an instance is registered in Reactter.
- [`Reactter.getInstanceManageMode`](https://pub.dev/documentation/reactter/latest/reactter/ReactterInstanceManager/getInstanceManageMode.html): Returns the `InstanceManageMode` of the instance.

In each of the events methods shown above (except `Reactter.isRegister` and `Reactter.getInstanceManageMode`), it provides the `id` argument for managing the instances of the same type by a unique identity.

> **NOTE:**
> The scope of the registered instances is global.
> This indicates that using the [shortcuts to manage instance](#shortcuts-to-manage-events) or [`UseInstance`](#useinstance) will allow you to access them from anywhere in the project.

### UseInstance

[`UseInstance`](https://pub.dev/documentation/reactter/latest/reactter/UseInstance-class.html) is a hook([`ReactterHook`](https://pub.dev/documentation/reactter/latest/reactter/ReactterHook-class.html)) that allows to manage an instance.

```dart
UseInstance<T>([String? id]);
```

The default constructor uses `Reactter.find` to get the instance of the `T` type with or without `id` that is available.

> **NOTE:**
> The instance that you need to get, must be created by [`Dependency injection`](#dependency-injection) before.

Use `instance` getter to get the instance.

Here is an example using `UseIntance`:

```dart
class MyController {
  final useAuthController = UseInstance<AuthController>();
  // final useOtherControllerWithId = UseInstance<OtherController>("UniqueId");

  AuthController? authController = useAuthController.instance;

  MyController() {
    UseEffect(() {
      authController = useAuthController.instance;
    }, [useAuthController],
    );
  }
}
```

> **NOTE:**
> In the example above uses [`UseEffect`](#useeffect) hook, to wait for the `instance` to become available.

`UseInstance` provides some constructors and factories for managing an instance, which are:

- [`UseInstance.register`](https://pub.dev/documentation/reactter/latest/reactter/UseInstance/register.html): Registers a builder function, for creating a new instance using `[Reactter|UseInstance].[get|create|builder|factory|singleton]`.
- [`UseInstance.lazyBuilder`](https://pub.dev/documentation/reactter/latest/reactter/UseInstance/lazyBuilder.html): Registers a builder function, for creating a new instance as [Builder](#builder) mode using `[Reactter|UseInstance].[get|create|builder]`.
- [`UseInstance.lazyFactory`](https://pub.dev/documentation/reactter/latest/reactter/UseInstance/lazyFactory.html): Registers a builder function, for creating a new instance as [Factory](#factory) mode using `[Reactter|UseInstance].[get|create|factory]`.
- [`UseInstance.lazySingleton`](https://pub.dev/documentation/reactter/latest/reactter/UseInstance/lazySingleton.html): Registers a builder function, for creating a new instance as [Singleton](#singleton) mode using `[Reactter|UseInstance].[get|create|singleton]`.
- [`UseInstance.create`](https://pub.dev/documentation/reactter/latest/reactter/UseInstance/create.html): Registers, creates and returns the instance directly.
- [`UseInstance.builder`](https://pub.dev/documentation/reactter/latest/reactter/UseInstance/builder.html): Registers, creates and returns the instance as [Builder](#builder) directly.
- [`UseInstance.factory`](https://pub.dev/documentation/reactter/latest/reactter/UseInstance/factory.html): Registers, creates and returns the instance as [Factory](#factory) directly.
- [`UseInstance.singleton`](https://pub.dev/documentation/reactter/latest/reactter/UseInstance/singleton.html): Registers, creates and returns the instance as [Singleton](#singleton) directly.
- [`UseInstance.get`](https://pub.dev/documentation/reactter/latest/reactter/UseInstance/get.html): Returns a previously created instance or creates a new instance from the builder function registered by `[Reactter|UseInstance].[register|lazyBuilder|lazyFactory|lazySingleton]`.

In each of the contructors or factories above shown, it provides the `id` property for managing the instances of the same type by a unique identity.

> **NOTE:**
> The scope of the registered instances is global.
> This indicates that using the [shortcuts to manage instance](#shortcuts-to-manage-events) or [`UseInstance`](#useinstance) will allow you to access them from anywhere in the project.

## Event handler

In Reactter, event handler plays a pivotal role in facilitating seamless communication and coordination between various components within the application.
The event handler system is designed to ensure efficient handling of states and instances, fostering a cohesive ecosystem where different parts of the application can interact harmoniously.

One of the key aspects of event handler in Reactter is the introduction of [lifecycles](#lifecycles) linked to events.
These lifecycles define the different stages through which a state or instance passes, offering a structured flow and effective handling of changes.

Additionally, Reactter offers the following event managers:

- [Shortcuts to manage events](#shortcuts-to-manage-instances)
- [UseEffect](#useeffect)

by `flutter_reactter`:

- [ReactterConsumer](#reactterconsumer)
- [ReactterSelector](#reactterselector)
- [ReactterWatcher](#reactterwatcher)
- [BuildContext.watch](#buildcontextwatch)
- [BuildContext.select](#buildcontextselect)

### Lifecycles

In Reactter, both the states ([`ReactterState`](#state-management)) and the instances (managed by the [`dependency injection`](#dependency-injection)) contain different stages, also known as [`Lifecycle`](https://pub.dev/documentation/reactter/latest/reactter/Lifecycle.html).
This lifecycles linked events, which are:

- `Lifecycle.registered`: is triggered when the instance has been registered.
- `Lifecycle.unregistered`: is triggered when the instance is no longer registered.
- `Lifecycle.initialized`: is triggered when the instance has been initialized.
- `Lifecycle.willMount` (exclusive of `flutter_reactter`): is triggered when the instance is going to be mounted in the widget tree.
- `Lifecycle.didMount` (exclusive of `flutter_reactter`): is triggered after the instance has been successfully mounted in the widget tree.
- `Lifecycle.willUpdate`: is triggered anytime the instance's state is about to be updated. The event parameter is a `ReactterState`.
- `Lifecycle.didUpdate`: is triggered anytime the instance's state has been updated. The event parameter is a `ReactterState`.
- `Lifecycle.willUnmount`(exclusive of `flutter_reactter`): is triggered when the instance is about to be unmounted from the widget tree.
- `Lifecycle.didUnmount`(exclusive of `flutter_reactter`): is triggered when  the instance has been successfully unmounted from the widget tree.
- `Lifecycle.destroyed`: is triggered when the instance has been destroyed.

You can extend your instances with [`LifecycleObserver`](https://pub.dev/documentation/reactter/latest/reactter/LifecycleObserver-class.html) mixin for observing and reacting to the various lifecycle events. e.g:

```dart
class MyController with LifecycleObserver {
  final state = UseState('initial');

  @override
  void onInitialized() {
    print("MyController has been initialized");
  }

  @override
  void onDidUpdate(ReactterState? state) {
    print("$state has been changed");
  }
}

final myController = Reactter.create(() => MyController());
// MyController has been initialized
myController.state.value = "value changed";
// state has been changed
```

### Shortcuts to manage events

Reactter offers several convenient shortcuts for managing events:

- [`Reactter.on`](https://pub.dev/documentation/reactter/latest/reactter/ReactterEventManager/on.html): turns on the listen event. When the `event` of `instance` is emitted, the `callback` is called:

  ```dart
  Reactter.on<T, P>(Object instance, Enum event, callback(T inst, P params));
  ```

- [`Reactter.one`](https://pub.dev/documentation/reactter/latest/reactter/ReactterEventManager/one.html): turns on the listen event for only once. When the `event` of `instance` is emitted, the `callback` is called and then removed.

  ```dart
  Reactter.one<T, P>(Object instance, Enum event, callback(T inst, P param));
  ```

- [`Reactter.off`](https://pub.dev/documentation/reactter/latest/reactter/ReactterEventManager/off.html): removes the `callback` from `event` of `instance`.

  ```dart
  Reactter.off<T, P>(Object instance, Enum event, callback(T instance, P param));
  ```

- [`Reactter.offAll`](https://pub.dev/documentation/reactter/latest/reactter/ReactterEventManager/offAll.html): removes all events of `instance`.

  ```dart
  Reactter.offAll(Object instance);
  ```

  > **IMPORTANT**:
  > Don't use it, if you're not sure. Because it will remove all events, even those events that Reactter needs to work properly. Instead, use `Reactter.off` to remove the specific events.

- [`Reactter.emit`](https://pub.dev/documentation/reactter/latest/reactter/ReactterEventManager/emit.html): triggers an `event` of `instance` with or without the `param` given.

  ```dart
  Reactter.emit(Object instance, Enum event, [dynamic param]);
  ```

In each of the methods it receives as first parameter an `instance` that can be directly the instance object or use `ReactterInstance` instead:

```dart
void onDidUpdate(inst, state) => print("Instance: $inst, state: $state");

final myController = Reactter.get<MyController>();
// or using `ReactterIntance`
final myController = ReactterInstance<MyController>();

Reactter.on(myController, Lifecycle.didUpdate, onDidUpdate);
Reactter.emit(myController, Lifecycle.didUpdate, 'test param');
```

> **RECOMMENDED:**
> Use the instance object directly on event methods for optimal performance.

> **NOTE:**
> The `ReactterInstance` helps to find the instance for event, if the instance not exists, put it on wait. It's a good option if you're not sure that the instance has been created yet.

### UseEffect

[`UseEffect`](https://pub.dev/documentation/reactter/latest/reactter/UseEffect-class.html) is a hook([`ReactterHook`](https://pub.dev/documentation/reactter/latest/reactter/ReactterHook-class.html)) that allows to manage side-effect.

```dart
UseEffect(
  <Function cleanup> Function() callback,
  List<ReactterState> dependencies,
)
```

The side-effect logic into the `callback` function is executed when the `dependencies` argument changes or the `instance` trigger `Lifecycle.didMount` event.

If the `callback` returns a function, then `UseEffect` considers this as an effect `cleanup`.
The `cleanup` callback is executed, before `callback` is called or `instance` trigger `Lifecycle.willUnmount` event:

Let's see an example with a counter that increments every second:

```dart
class MyController {
  final count = UseState(0);

  MyController() {
    UseEffect((){
      // Execute by count state changed or 'Lifecycle.didMount' event
      print("Count: ${count.value}");
      Future.delayed(const Duration(seconds: 1), () => count.value += 1);

      return () {
        // Cleanup - Execute before count state changed or 'Lifecycle.willUnmount' event
        print("Cleanup executed");
      };
    }, [count]);
  }
}
```

Use `UseEffect.runOnInit` to execute the callback effect on initialization.

```dart
UseEffect.runOnInit(
  () => print("Excute immediately and by hook changes"),
  [someState],
);
```

## Rendering control

Rendering control provides the capability to observe specific instances or states, triggering re-renders of the widget tree as required. This methodology ensures a unified and responsive user interface, facilitating efficient updates based on changes in the application's state.

In this context, the [`flutter_reactter`](https://pub.dev/packages/flutter_reactter) package provides the following purpose-built widgets and certain `BuildContext` extension for rendering control:

- [ReactterProvider](#reactterprovider)
- [ReactterProviders](#reactterproviders)
- [ReactterComponent](#reacttercomponent)
- [ReactterConsumer](#reactterconsumer)
- [ReactterWatcher](#reactterwatcher)
- [ReactterSelector](#reactterselector)
- [BuildContext.use](#buildcontextuse)
- [BuildContext.watch](#buildcontextwatch)
- [BuildContext.select](#buildcontextselect)

### ReactterProvider

[`ReactterProvider`](https://pub.dev/documentation/flutter_reactter/latest/flutter_reactter/ReactterProvider-class.html) is a Widget (exclusive of `flutter_reactter`) that hydrates from an instance of `T` type to the Widget tree.

```dart
ReactterProvider<T>(
  T instanceBuilder(), {
  String? id,
  bool init = false,
  InstanceManageMode type = InstanceManageMode.builder,
  Widget? child,
  required Widget builder(BuilderContext context, T instance, Widget? child),
})
```

`ReactterProvider` accepts theses properties:

- `instanceBuilder`: to define a method for the creation of a new instance of `T` type.

  > **RECOMMENDED:**
  > Don't use Object with constructor parameters to prevent conflicts.

- `id`: to uniquely identify the instance.
- `init`:  to indicate that the instance must be initialized before the `ReactterProvider` is mounted.
- `mode`: to determine the instance manage mode([Builder](#builder), [Factory](#factory) or [Singleton](#singleton)).
- `child`: to pass a `Widget`  through the `builder` method that it will be built only once.
- `builder`: to define a method that contains the builder logic of the widget that will be embedded in the widget tree. This method exposes the `instance`(`T`) created, a new `context`(`BuildContext`) and a `child`(`Widget`) defined in the `child` property.

Here is an example:

```dart
ReactterProvider<CounterController>(
  () => CounterController(),
  child: const Text('This widget is rendered once'),
  builder: (context, counterController, child) {
    // `context.watch` listens any CounterController changes for rebuild this widget tree.
    context.watch<CounterController>();

    // Change the `value` each 1 second.
    Future.delayed(Duration(seconds: 1), (_) => counterController.count.value++);

    return Column(
      children: [
        child!, // The child widget has already been built in `child` property.
        Text("count: ${counterController.count.value}"),
      ],
    );
  },
)
```

Use [`ReactterProvider.lazy`](https://pub.dev/documentation/flutter_reactter/latest/flutter_reactter/ReactterProvider/ReactterProvider.lazy.html) to enable lazy-loading of the instance, ensuring it is only instantiated when necessary. While this feature enhances performance by deferring instantiation until required, it's important to note that it may result in the loss of lifecycle tracing.

> **NOTE:**
> `ReactteProvider` is "scoped". So, the `builder` method will be rebuild when the instance or any `ReactterState` specified in [`BuildContext.watch`](#buildcontextwatch) or [`BuildContext.select`](#buildcontextselect)  changes.

### ReactterProviders

[`ReactterProviders`](https://pub.dev/documentation/flutter_reactter/latest/flutter_reactter/ReactterProviders-class.html) is a Widget (exclusive of `flutter_reactter`) that allows to use multiple [`ReactterProvider`](#reactterprovider) in a nested way.

```dart
ReactterProviders(
  [
    ReactterProvider(
      () => MyController(),
    ),
    ReactterProvider(
      () => ConfigController(),
      id: 'App',
    ),
    ReactterProvider(
      () => ConfigController(),
      id: 'Dashboard'
    ),
  ],
  builder: (context, child) {
    final myController = context.use<MyController>();
    final appConfigController = context.use<ConfigController>('App');
    final dashboardConfigController = context.use<ConfigController>('Dashboard');
    ...
  },
)
```

> **RECOMMENDED:**
> Don't use Object with constructor parameters to prevent conflicts.

> **NOTE:**
> `ReactteProvider` is "scoped". So, the `builder` method will be rebuild when the instance or any `ReactterState` specified in [`BuildContext.watch`](#buildcontextwatch) or [`BuildContext.select`](#buildcontextselect)  changes.

### ReactterComponent

[`ReactterComponent`](https://pub.dev/documentation/flutter_reactter/latest/widgets/ReactterComponent-class.html) is a abstract `StatelessWidget` (exclusive of `flutter_reactter`) that provides [`ReactterProvider`](#reactterprovider) features, whose instance of `T` type is exposed trough `render` method.

```dart
class CounterComponent extends ReactterComponent<CounterController> {
  const CounterComponent({Key? key}) : super(key: key);

  @override
  get builder => () => CounterController();

  @override
  void listenStates(counterController) => [counterController.count];

  @override
  Widget render(context, counterController) {
    return Text("Count: ${counterController.count.value}");
  }
}
```

Use `builder` getter to define the instance builder function.

> **RECOMMENDED:**
> Don't use Object with constructor parameters to prevent conflicts.

> **NOTE:**
> If you don't use `builder` getter, the instance will not be created. Instead, an attempt will be made to locate it within the closest ancestor where it was initially created.

Use the `id` getter to identify the instance of `T`:

Use the `listenStates` getter to define the states that will rebuild the tree of the widget defined in the `render` method whenever it changes.

Use the `listenAll` getter as `true` to listen to all the instance changes to rebuild the Widget tree defined in the `render` method.

### ReactterConsumer

[`ReactterConsumer`](https://pub.dev/documentation/flutter_reactter/latest/flutter_reactter/ReactterConsumer-class.html) is a Widget (exclusive of `flutter_reactter`) that allows to access the instance of `T` type from `ReactterProvider`'s nearest ancestor and can listen all or specified states to rebuild the Widget when theses changes occur:

```dart
ReactterConsumer<T>({
  String? id,
  bool listenAll = false,
  List<ReactterState> listenStates(T instance)?,
  Widget? child,
  required Widget builder(BuildContext context, T instance, Widget? child),
});
```

`ReactterConsumer` accepts theses properties:

- `id`: to uniquely identify the instance.
- `listenAll`: to listen to all events emitted by the instance or its states(`ReactterState`).
- `listenStates`: to listen to states(`ReactterState`) defined in it.
- `child`: to pass a `Widget`  through the `builder` method that it will be built only once.
- `builder`: to define a method that contains the builder logic of the widget that will be embedded in the widget tree. This method exposes the `instance`(`T`) created, a new `context`(`BuildContext`) and a `child`(`Widget`) defined in the `child` property.

Here is an example:

```dart
class ExampleWidget extends StatelessWidget {
  ...
  Widget build(context) {
    return ReactterConsumer<MyController>(
      listenStates: (inst) => [inst.stateA, inst.stateB],
      child: const Text('This widget is rendered once'),
      builder: (context, myController, child) {
        // This is built when stateA or stateB has changed.
        return Column(
          children: [
            Text("My instance: $d"),
            Text("StateA: ${d.stateA.value}"),
            Text("StateB: ${d.stateB.value}"),
            child!, // The child widget has already been built in `child` property.
          ],
        );
      }
    );
  }
}
```

> **NOTE:**
> `ReactteConsumer` is "scoped". So, the `builder` method will be rebuild when the instance or any `ReactterState` specified get change.

> **NOTE:**
> Use [`ReactterSelector`](#reactterselector) for more specific conditional state when you want the widget tree to be re-rendered.

### ReactterSelector

[`ReactterSelector`](https://pub.dev/documentation/flutter_reactter/latest/flutter_reactter/ReactterSelector-class.html) is a Widget (exclusive of `flutter_reactter`) that allows to control the rebuilding of widget tree by selecting the states([`ReactterState`](https://pub.dev/documentation/reactter/latest/reactter/ReactterState-class.html)) and a computed value.

```dart
ReactterSelector<T, V>(
  V selector(
    T inst,
    ReactterState $(ReactterState state),
  ),
  String? id,
  Widget? child,
  Widget builder(
    BuildContext context,
    T inst,
    V value,
    Widget? child
  ),
)
```

`ReactterSelector` accepts four properties:

- `selector`: to define a method that contains the computed value logic and determined when to be rebuilding the widget tree which defined in `build` property. It returns a value of `V` type and exposes the following arguments:
  - `inst`: the found instance of `T` type and by `id` if specified it.
  - `$`: a method that allows to wrap to the state(`ReactterState`) to put it in listening.
- `id`: to uniquely identify the instance.
- `child`: to pass a `Widget` through the `builder` method that it will be built only once.
- `builder`: to define a method that contains the builder logic of the widget that will be embedded in the widget tree. It exposes the following arguments:
  - `context`: a new `BuilContext`.
  - `inst`: the found instance of `T` type and by `id` if specified it.
  - `value`: the computed value of `V` type. It is computed by `selector` method.
  - `child`: a `Widget` defined in the `child` property.

`ReactterSelector` determines if the widget tree of `builder` needs to be rebuild again by comparing the previous and new result of `selector`.
This evaluation only occurs if one of the selected states(`ReactterState`) gets updated, or by the instance if the `selector` does not have any selected states(`ReactterState`). e.g.:

```dart
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget? build(BuildContext context) {
    return ReactterProvider<MyController>(
      () => MyController(),
      builder: (context, inst, child) {
        return OtherWidget();
      }
    );
  }
}

class OtherWidget extends StatelessWidget {
  const OtherWidget({Key? key}) : super(key: key);

  @override
  Widget? build(BuildContext context) {
    return ReactterSelector<MyController, int>(
      selector: (inst, $) => $(inst.stateA).value % $(inst.stateB).value,
      builder: (context, inst, value, child) {
        // This is rebuilt every time that the result of selector is different to previous result.
        return Text("${inst.stateA.value} mod ${inst.stateB.value}: ${value}");
      },
    );
  }
}
```

`ReactterSelector` typing can be ommited, but the app must be wrapper by `ReactterScope`. e.g.:

```dart
[...]
ReactterScope(
  child: MyApp(),
)
[...]

class OtherWidget extends StatelessWidget {
  const OtherWidget({Key? key}) : super(key: key);

  @override
  Widget? build(BuildContext context) {
    final myController = context.use<MyController>();

    return ReactterSelector(
      selector: (_, $) => $(myController.stateA).value % $(myController.stateB).value,
      builder: (context, _, value, child) {
        // This is rebuilt every time that the result of selector is different to previous result.
        return Text("${myController.stateA.value} mod ${myController.stateB.value}: ${value}");
      },
    );
}
```

### ReactterWatcher

[`ReactterWatcher`](https://pub.dev/documentation/flutter_reactter/latest/flutter_reactter/ReactterWatcher-class.html) is a Widget (exclusive of `flutter_reactter`) that allows to listen all `Signal`s contained in `builder` property and rebuilt the Widget when it changes:

```dart
ReactterWatcher({
  Widget? child,
  required Widget builder(BuildContext context, Widget? child),
})
```

`ReactterWatcher` accepts two properties:

- `child`: to pass a `Widget`  through the `builder` method that it will be built only once.
- `builder`: to define a method that contains the builder logic of the widget that will be embedded in the widget tree. It exposes the following arguments:
  - `context`: a new `BuilContext`.
  - `child`: a `Widget` defined in the `child` property.

```dart
final count = Signal(0);
final flag = Signal(false);

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
            child!,  // Takes the Widget from the `child` property in each rebuild.
          ],
        );
      },
    );
  }
}
```

### BuildContext.use

[`BuildContext.use`](https://pub.dev/documentation/flutter_reactter/latest/flutter_reactter/ReactterBuildContextExtension/use.html) is an extension method of the `BuildContext`, that allows to access to instance of `T` type from the closest ancestor [`ReactterProvider`](https://pub.dev/documentation/flutter_reactter/latest/flutter_reactter/ReactterProvider-class.html).

```dart
T context.use<T>([String? id])
```

Here is an example:

```dart
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget? build(BuildContext context) {
    return ReactterProvider<MyController>(
      () => MyController(),
      builder: (context, inst, child) {
        return OtherWidget();
      }
    );
  }
}

class OtherWidget extends StatelessWidget {
  const OtherWidget({Key? key}) : super(key: key);

  @override
  Widget? build(BuildContext context) {
    final myController = context.use<MyController>();

    return Text("value: ${myController.stateA.value}");
  }
}
```

Use the first argument for obtaining the instance by `id`. e.g.:

```dart
  final myControllerById = context.use<MyController>('uniqueId');
```

Use the nullable type to safely get the instance, avoiding exceptions if the instance is not found, and get `null` instead. e.g.:

```dart
  final myController = context.use<MyController?>();
```

>**NOTE:**
> If `T` is non-nullable and the instance is not found, it will throw `ProviderNullException`.

### BuildContext.watch

[`BuildContext.watch`](https://pub.dev/documentation/flutter_reactter/latest/flutter_reactter/ReactterBuildContextExtension/watch.html) is an extension method of the `BuildContext`, that allows to access to instance of `T` type from the closest ancestor [`ReactterProvider`](https://pub.dev/documentation/flutter_reactter/latest/flutter_reactter/ReactterProvider-class.html), and listen to the instance or [`ReactterState`](https://pub.dev/documentation/reactter/latest/reactter/ReactterState-class.html) list for rebuilding the widget tree in the scope of `BuildContext`.

```dart
T context.watch<T>(
  List<ReactterState> listenStates(T inst)?,
)
```

Here is an example, that shows how to listen an instance and react for rebuild:

```dart
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget? build(BuildContext context) {
    return ReactterProvider<MyController>(
      () => MyController(),
      builder: (context, inst, child) {
        return OtherWidget();
      }
    );
  }
}

class OtherWidget extends StatelessWidget {
  const OtherWidget({Key? key}) : super(key: key);

  @override
  Widget? build(BuildContext context) {
    final myController = context.watch<MyController>();
    // This is rebuilt every time any states in the instance are updated
    return Text("value: ${myController.stateA.value}");
  }
}
```

Use the first argument(`listenStates`) to specify the states that are to be listen on for rebuild. e.g.:

```dart
[...]
  @override
  Widget? build(BuildContext context) {
    final myController = context.watch<MyController>(
      (inst) => [inst.stateA, inst.stateB],
    );
    // This is rebuilt every time any defined states are updated
    return Text("value: ${myController.stateA.value}");
  }
[...]
```

Use [`BuildContext.watchId`](https://pub.dev/documentation/flutter_reactter/latest/flutter_reactter/ReactterBuildContextExtension/watchId.html) for obtaining the instance of `T` type by `id`, and listens the instance or [`ReactterState`](https://pub.dev/documentation/reactter/latest/reactter/ReactterState-class.html) list for rebuilding the widget tree in the scope of `BuildContext`.

```dart
T context.watchId<T>(
  String id,
  List<ReactterState> listenStates(T inst)?,
)
```

It is used as follows:

```dart
// for listening the instance
final myControllerById = context.watchId<MyController>('uniqueId');
// for listening the states
final myControllerById = context.watchId<MyController>(
  'uniqueId',
  (inst) => [inst.stateA, inst.stateB],
);
```

### BuildContext.select

[`BuildContext.select`](https://pub.dev/documentation/flutter_reactter/latest/flutter_reactter/ReactterBuildContextExtension/select.html) is an extension method of the `BuildContext`, that allows to control the rebuilding of widget tree by selecting the states([`ReactterState`](https://pub.dev/documentation/reactter/latest/reactter/ReactterState-class.html)) and a computed value.

```dart
V context.select<T, V>(
  V selector(
    T inst,
    ReactterState $(ReactterState state),
  ),
  [String? id],
)
```

`BuildContext.select` accepts two argtuments:

- `selector`: to define a method that computed value logic and determined when to be rebuilding the widget tree of the `BuildContext`. It returns a value of `V` type and exposes the following arguments:
  - `inst`: the found instance of `T` type and by `id` if specified it.
  - `$`: a method that allows to wrap to the state(`ReactterState`) to put it in listening.
- `id`: to uniquely identify the instance.

`BuildContext.select` determines if the widget tree in scope of `BuildContext` needs to be rebuild again by comparing the previous and new result of `selector`.
This evaluation only occurs if one of the selected states(`ReactterState`) gets updated, or by the instance if the `selector` does not have any selected states(`ReactterState`). e.g.:

```dart
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget? build(BuildContext context) {
    return ReactterProvider<MyController>(
      () => MyController(),
      builder: (context, inst, child) {
        return OtherWidget();
      }
    );
  }
}

class OtherWidget extends StatelessWidget {
  const OtherWidget({Key? key}) : super(key: key);

  @override
  Widget? build(BuildContext context) {
    final value = context.select<MyController, int>(
      (inst, $) => $(inst.stateA).value % $(inst.stateB).value,
    );
    // This is rebuilt every time that the result of selector is different to previous result.
    return Text("stateA mod stateB: ${value}");
  }
}
```

`BuildContext.select` typing can be ommited, but the app must be wrapper by `ReactterScope`. e.g.:

```dart
[...]
ReactterScope(
  child: MyApp(),
)
[...]

class OtherWidget extends StatelessWidget {
  const OtherWidget({Key? key}) : super(key: key);

  @override
  Widget? build(BuildContext context) {
    final myController = context.use<MyController>();
    final value = context.select(
      (_, $) => $(myController.stateA).value % $(myController.stateB).value,
    );
    // This is rebuilt every time that the result of selector is different to previous result.
    return Text("stateA mod stateB: ${value}");
  }
}
```

## Custom hooks

Custom hooks are classes that extend [`ReactterHook`](https://pub.dev/documentation/reactter/latest/reactter/ReactterHook-class.html) that follow a special naming convention with the `use` prefix and can contain state logic, effects or any other custom code.

There are several advantages to using Custom Hooks:

- **Reusability**: to use the same hook again and again, without the need to write it twice.
- **Clean Code**: extracting part of code into a hook will provide a cleaner codebase.
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

> **NOTE:**
> `ReactterHook` provides an `update` method which notifies about its changes.

You can then call that custom hook from anywhere in the code and get access to its shared logic:

```dart
class MyController {
  final count = UseCount(0);

  MyController() {
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

## Lazy state

A lazy state is a `ReactterState`([`Signal`](#signal) or [`ReactterHook`](https://pub.dev/documentation/reactter/latest/reactter/ReactterHook-class.html)) that is loaded lazily using `Reactter.lazyState`.

```dart
T Reactter.lazyState<T extends ReactterState>(T stateFn(), Object instance);
```

`Reactter.lazyState` is generally used in states declared with the `late` keyword.
> In dart, `late` keyword is used to declare a variable or field that will be initialized at a later time. It is used to declare a non-nullable variable that is not initialized at the time of declaration.

For example, when the a state declared in a class requires some variable or methods immediately:

```dart
class MyController {
  final String initialValue = 'test';
  dynamic resolveValue() async => [...];

  /// late final state = UseAsyncState(
  ///   initialValue,
  ///   resolveValue
  /// ); <- to use `Reactter.lazyState` is required, like:

  late final state = Reactter.lazyState(
    () => UseAsyncState(initialValue, resolveValue),
    this,
  );

  ...
}
```

> **IMPORTANT**:
> A state(`ReactterState`) declared with the `late` keyword and not using `Reactter.lazyState` is outside the context of the instance where it was declared, and therefore the instance does not notice about its changes.

## Batch

```dart
T Reactter.batch<T>(T Function() callback)
```

The [`batch`](https://pub.dev/documentation/reactter/latest/reactter/ReactterInterface/batch.html) function allows you to combine multiple state changes to be grouped together, ensuring that any associated side effects are only triggered once, improving performance and reducing unnecessary re-renders. e.g.:

```dart
final stateA = UseState(0);
final stateB = UseState(0);
final computed = UseCompute(
  () => stateA.value + stateB.value,
  [stateA, stateB],
);

final batchReturned = Reactter.batch(() {
  stateA.value = 1;
  stateB.value = 2;

  print(computed.value); // 0 -> because the batch operation is not completed yet.

  return stateA.value + stateB.value;
});

print(batchReturned); // 3
print(computed.value); // 3 -> because the batch operation is completed.
```

Batches can be nested and updates will be flushed when the outermost batch call completes. e.g.:

```dart
final stateA = UseState(0);
final stateB = UseState(0);
final computed = UseCompute(
  () => stateA.value + stateB.value,
  [stateA, stateB],
);

Reactter.batch(() {
  stateA.value = 1;
  print(computed.value); // 0;

  Reactter.batch(() {
    stateB.value = 2;
    print(computed.value); // 0;
  });

  print(computed.value); // 0;
});

print(computed.value); // 3;
```

## Untracked

```dart
T Reactter.untracked<T>(T Function() callback)
```

The [`untracked`](https://pub.dev/documentation/reactter/latest/reactter/ReactterInterface/untracked.html) function helps you to execute the given `callback` function without tracking any state changes. This means that any state changes that occur inside the `callback` function will not trigger any side effects. e.g.:

```dart
final state = UseState(0);
final computed = UseCompute(() => state.value + 1, [state]);

Reactter.untracked(() {
  state.value = 2;

  print(computed.value); // 1 -> because the state change is not tracked
});

print(computed.value); // 1 -> because the state change is not tracked
```

## Generic arguments

Generic arguments are objects of the `Args` class that represent the arguments of the specified types.
It is used to define the arguments that are passed through a `Function` and allows to type the `Function` appropriately.

> **RECOMMENDED**:
> If your project supports [`Record`](https://dart.dev/language/records#record-types), it is recommended to use it instead of the generic arguments.

Reactter provides theses generic arguments classes:

- [`Args<A>`](https://pub.dev/documentation/reactter/6.0.0/reactter/Args-class.html): represents one or more arguments of `A` type.
- [`Args1<A>`](https://pub.dev/documentation/reactter/6.0.0/reactter/Args1-class.html) : represents a argument of `A` type.
- [`Args2<A, A2>`](https://pub.dev/documentation/reactter/6.0.0/reactter/Args2-class.html): represents two arguments of `A`, `A2` type consecutively.
- [`Args3<A, A2, A3>`](https://pub.dev/documentation/reactter/6.0.0/reactter/Args3-class.html): represents three arguments of `A`, `A2`, `A3` type consecutively.
- [`ArgsX2<A>`](https://pub.dev/documentation/reactter/6.0.0/reactter/ArgsX2.html): represents two arguments of `A` type.
- [`ArgsX3<A>`](https://pub.dev/documentation/reactter/6.0.0/reactter/ArgsX3.html): represents three arguments of `A` type.

In each of the methods it provides theses methods and properties:

- `arguments`: gets the list of arguments.
- `toList<T>()`: gets the list of arguments `T` type.
- `arg1`: gets the first argument.
- `arg2`(`Args2`, `Args3`, `ArgsX2`, `ArgsX3` only): gets the second argument.
- `arg3`(`Args3`, `ArgsX3` only): gets the third argument.

> **NOTE:**
> If you need a generic argument class with more arguments, then create a new class following pattern:
>
> ```dart
> class Args+n<A, (...), A+n> extends Args+(n-1)<A, (...), A+(n-1)> {
>   final A+n arg+n;
>
>   const Args+n(A arg1, (...), A+(n-1) arg+(n-1), this.arg+n) : super(arg1, (...), arg+(n-1));
>
>   @override
>   List get arguments => [...super.arguments, arg+n];
> }
>
> typedef ArgX+n<T> = Args+n<T, (...), T>;
> ```
>
> e.g. 4 arguments:
>
> ```dart
> class Args4<A, A2, A3, A4> extends Args3<A, A2, A3> {
>   final A4 arg4;
>
>   const Args4(A arg1, A2 arg2, A3 arg3, this.arg4) : super(arg1, arg2, arg3);
>
>   @override
>   List get arguments => [...super.arguments, arg4];
> }
>
> typedef ArgX4<T> = Args4<T, T, T, T>;
> ```

> **NOTE:**
> Use `ary` Function extention to convert any `Function` with positional arguments to `Function` with generic argument, e.g.:
>
> ```dart
> int addNum(int num1, int num2) => num1 + num2;
> // convert to `int Function(Args2(int, int))`
> final addNumAry = myFunction.ary;
> addNumAry(Arg2(1, 1));
> // or call directly
> addNum.ary(ArgX2(2, 2));
> ```

### Memo

[`Memo`](https://pub.dev/documentation/reactter/latest/reactter/Memo-class.html) is a class callable with memoization logic which it stores computation results in cacbe, and retrieve that same information from the cache the next time it's needed instead of computing it again.

> **NOTE:**
> Memoization is a powerful trick that can help speed up our code, especially when dealing with repetitive and heavy computing functions.

```dart
Memo<T, A>(
  T computeValue(A arg), [
  MemoInterceptor<T, A>? interceptor,
]);
```

`Memo` accepts theses properties:

- `computeValue`: represents a method that takes an argument of type `A` and returns a value of  `T` type. This is the core function that will be memoized.
- `interceptor`: receives a [`MemoInterceptor`](https://pub.dev/documentation/reactter/6.0.0/reactter/MemoInterceptor-class.html) that allows you to intercept the memoization function calls and modify the memoization process.
  Reactter providers some interceptors:
  - [`MemoInterceptors`](https://pub.dev/documentation/reactter/6.0.0/reactter/MemoInterceptors-class.html): allows multiple memoization interceptors to be used together.
  - [`MemoInterceptorWrapper`](https://pub.dev/documentation/reactter/6.0.0/reactter/MemoInterceptorWrapper-class.html): a wrapper for a memoized function that allows you to define callbacks for initialization, successful completion, error handling, and finishing.
  - [`AsyncMemoSafe`](https://pub.dev/documentation/reactter/6.0.0/reactter/AsyncMemoSafe-class.html): prevents saving in cache if the `Future` calculation function throws an error during execution.
  - [`TemporaryCacheMemo`](https://pub.dev/documentation/reactter/6.0.0/reactter/TemporaryCacheMemo-class.html): removes memoized values from the cache after a specified duration.

Here an factorial example using `Memo`:

```dart
late final factorialMemo = Memo(calculateFactorial);

/// A factorial(n!) represents the multiplication of all numbers between 1 and n.
/// So if you were to have 3!, for example, you'd compute 3 x 2 x 1 (which = 6).
BigInt calculateFactorial(int number) {
  if (number == 0) return BigInt.one;
  return BigInt.from(number) * factorialMemo(number - 1);
}

void main() {
  // Returns the result of multiplication of 1 to 50.
  final f50 = factorialMemo(50);
  // Returns the result immediately from cache
  // because it was resolved in the previous line.
  final f10 = factorialMemo(10);
  // Returns the result of the multiplication of 51 to 100
  // and 50! which is obtained from the cache(as computed previously by f50).
  final f100 = factorialMemo(100);

  print(
    'Results:\n'
    '\t10!: $f10\n'
    '\t50!: $f50\n'
    '\t100!: $f100\n'
  );
}
```

> **NOTE**:
> The `computeValue` of `Memo` accepts one argument only. If you want to add more arguments, you can supply it using the `Record`(`if your proyect support`) or `generic arguments`(learn more [here](#generic-arguments)).

> **NOTE:**
> Use [`Memo.inline`](https://pub.dev/documentation/reactter/6.0.0/reactter/Memo/inline.html) in case there is a typing conflict, e.g. with the `UseAsynState` and `UseCompute` hooks which a `Function` type is required.

`Memo` provides the following methods that will help you manipulate the cache as you wish:

- `T? get(A arg)`: returns the cached value by `arg`.
- `T? remove(A arg)`: removes the cached value by `arg`.
- `clear`: removes all cached data.

## Difference between Signal and UseState

Both `UseState` and `Signal` represent a state (`ReactterState`). However, it possesses distinct features that set them apart.

`UseState` is a `ReactterHook`, giving it the unique ability to be extended and enriched with new capabilities, which sets it apart from `Signal`.

In the case of `UseState`, it necessitates the use of the `value` attribute whenever state is read or modified. On the other hand, `Signal` streamlines this process, eliminating the need for explicit `value` handling, thus enhancing code clarity and ease of understanding.

In the context of Flutter, when implementing `UseState`, it is necessary to expose the parent class containing the state to the widget tree via a `ReactterProvider` or `ReactterComponent`, and subsequently access it through `BuildContext`. Conversely, with `Signal`, which is inherently reactive, you can conveniently employ `ReactterWatcher`.

It's important to note that while `Signal` offers distinct advantages, particularly for managing global states and enhancing code readability, it can introduce potential antipatterns and may complicate the debugging process. Nevertheless, these concerns are actively being addressed and improved in upcoming versions of the package.

Ultimately, the choice between `UseState` and `Signal` lies in your hands. They can coexist seamlessly, and you have the flexibility to transition from `UseState` to `Signal`, or vice versa, as your project's requirements evolve.

## Resources

- [Github](https://github.com/2devs-team/reactter)
- [Examples](https://github.com/2devs-team/reactter/tree/master/packages/flutter_reactter/example)
- [Examples in zapp](https://zapp.run/pub/flutter_reactter)
- [Reactter doccumentation](https://pub.dev/documentation/reactter/latest)
- [Flutter Reactter documentation](https://pub.dev/documentation/flutter_reactter/latest)
- [Reactter Lint](https://pub.dev/packages/reactter_lint)
- [Reactter Snippets](https://marketplace.visualstudio.com/items?itemName=CarLeonDev.reacttersnippets)

## Contribute

If you want to contribute don't hesitate to create an [issue](https://github.com/2devs-team/reactter/issues/new) or [pull-request](https://github.com/2devs-team/reactter/pulls) in [Reactter repository](https://github.com/2devs-team/reactter).

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
- Write articles or make videos teaching how to use [Reactter](https://github.com/2devs-team/reactter).

Any idean is welcome!

## Authors

- **[Carlos León](https://twitter.com/CarLeonDev)** - <carleon.dev@gmail.com>
- **[Leo Castellanos](https://twitter.com/leoocast10)** - <leoocast.dev@gmail.com>
