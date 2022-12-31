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

**A light, powerful and reactive state management.**

## Features

- ⚡️ **Build for speed**.
- 📏 **Reduce boilerplate code** significantly.
- 📝 **Improve code readability**.
- 🪃 **Unidirectional** data flow.
- ☢️ **Reactive state** using [Signal](#using-signal).
- ♻️ **Reuse state** creating [custom hooks](#custom-hook-with-reactterhook).
- 🪄 **No configuration** necessary.
- 🎮 **Total control** to re-render widget tree.
- 💙 **Flutter or Dart only**, you can use in any Dart project.

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

See more examples [here](https://github.com/2devs-team/reactter/tree/master/examples)!

## Contents

- [Quickstart](#quickstart)
- [Usage](#usage)
  - [Create a `ReactterContext`](#create-a-reacttercontext)
  - [Lifecycle of `ReactterContext`](#lifecycle-of-reacttercontext)
  - [Shortcuts to manage instances](#shortcuts-to-manage-instances)
  - [Shortcuts to manage events](#shortcuts-to-manage-events)
  - [Using `UseContext` hook](#using-usecontext-hook)
  - [Using `UseEvent` hook](#using-useevent-hook)
  - [Using `Signal`](#using-signal)
  - [Using `UseState` hook](#using-usestate-hook)
  - [Different between `UseState` and `Signal`](#different-between-usestate-and-signal)
  - [Using `UseAsyncState` hook](#using-useasyncstate-hook)
  - [Using `UseReducer` hook](#using-usereducer-hook)
  - [Using `UseEffect` hook](#using-useeffect-hook)
  - [Custom hook with `ReactterHook`](#custom-hook-with-reactterhook)
- [Usage with `flutter_reactter`](#usage-with-flutter_reactter)
  - [Wrap with `ReactterProvider`](#wrap-with-reactterprovider)
  - [Access to `ReactterContext`](#access-to-reacttercontext)
  - [React to `Signal`s with `ReactterWatcher`](#react-to-signals-with-reactterwatcher)
  - [Control re-render with `ReactterBuilder`](#control-re-render-with-reactterbuilder)
  - [Mutiple `ReactterProvider` with `ReactterProviders`](#multiple-reactterprovider-with-reactterproviders)
  - [Create a `ReactterComponent`](#create-a-reacttercomponent)
- [Resources](#resources)
  - Documentation
  - Examples
- [Roadmap](#roadmap)
- [Contribute](#contribute)
- [Authors](#authors)

## Quickstart

Before anything, you need to be aware that Reactter is distributed on two packages, with slightly different usage.

The package of Reactter that you will want to install depends on the project type you are making.

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

## Usage

### Create a `ReactterContext`

[`ReactterContext`](https://pub.dev/documentation/reactter/latest/core/ReactterContext-class.html) is a abstract class that allows to manages [`ReactterHook`](https://pub.dev/documentation/reactter/latest/core/ReactterHook-class.html) and provides life-cycle events.

You can use it's functionalities, creating a class that extends it:

```dart
class AppContext extends ReactterContext {}
```

You can use the [shortcuts to manage instances](#shortcuts-to-manage-instances) or [using `UseContext` hook](#using-usecontext-hook) to access it.

> **RECOMMENDED:**
> Name class with `Context` suffix, for easy locatily.

> **NOTE:**
> In flutter, using [`ReactterProvider`](https://pub.dev/documentation/flutter_reactter/latest/widgets/ReactterProvider-class.html), it's a way to share the state between widgets without having to explicitly pass a property through every level of the tree.

### Lifecycle of `ReactterContext`

`ReactterContext` has the following [Lifecycle](https://pub.dev/documentation/reactter/latest/core/Lifecycle.html) events:

- **`Lifecycle.registered`**: Event when the instance has registered by `ReactterInstanceManager`.

- **`Lifecycle.unregistered`**: Event when the instance has unregistered by `ReactterInstanceManager`.

- **`Lifecycle.inicialized`**: Event when the instance has inicialized by `ReactterInstanceManager`.

- **`Lifecycle.willMount`**: Event when the instance will be mount in the widget tree (it use with `flutter_reactter` only).

- **`Lifecycle.didMount`**: Event when the instance did be mount in the widget tree (it use with `flutter_reactter` only).

- **`Lifecycle.willUpdate`**: Event when any instance's states will be update. Event param is a `ReactterState`.

- **`Lifecycle.didUpdate`**: Event when any instance's states did be update. Event param is a `ReactterState`.

- **`Lifecycle.willUnmount`**: Event when the instance will be unmount in the widget tree(it use with `flutter_reactter` only).

- **`Lifecycle.destroyed`**: Event when the instance did be destroyed by `ReactterInstanceManager`.

You can use the [shortcuts](#shortcuts-to-manage-events) or [`UseEvent` hook](#using-useevent-hook) to listen to these events.

### Shortcuts to manage instances

Reactter provides a some shortcuts to manage instances, these are:

- **`Reactter.register`**: Registers a `builder` function to allows to create the instance using `Reactter.get`.

  ```dart
  Reactter.register(builder: () => AppContext());
  Reactter.register(id: "uniqueId", builder: () => AppContext());
  ```

- **`Reactter.unregister`**: Removes the `builder` function to avoid create the instance.

  ```dart
  Reactter.unregister<AppContext>();
  Reactter.unregister<AppContext>("uniqueId");
  ```

- **`Reactter.get`**: Gets the previously instance created or creates a new instance from the `build` registered using `reactter.register`.

  ```dart
  final appContext = Reactter.get<AppContext>();
  final appContextWithId = Reactter.get<AppContext>(id: 'uniqueId');
  ```

- **`Reactter.create`**: Registers, creates and gets the instance directly.

  ```dart
  final appContext = Reactter.create(builder: () => AppContext());
  final appContextWithId = Reactter.create(id: 'uniqueId', builder: () => AppContext());
  ```

- **`Reactter.delete`**: Deletes the instance but still keep the `builder` function.

  ```dart
  Reactter.delete<AppContext>();
  Reactter.delete<AppContext>('uniqueId');
  ```

> **NOTE:**
> The registered instances have a global scope. This means that you can access them anywhere in the project just by using `Reactter.get` or through [`UseContext`](https://pub.dev/documentation/reactter/latest/hooks/UseContext-class.html).

### Shortcuts to manage events

Reactter provides a some shortcuts to manage events, these are:

- **`Reactter.on`**: Puts on to listen event. When the event is emitted, the `callback` is called:

  ```dart
  void _onDidUpdate(inst, state) {
    print("Instance: $inst, state: $state");
  }

  final appContext = Reactter.get<AppContext>();
  Reactter.on(appContext, Lifecycle.didUpdate, _onDidUpdate);
  // or
  Reactter.on(ReactterInstance<AppContext>(), Lifecycle.didUpdate, _onDidUpdate);
  ```

- **`Reactter.one`**: Puts on to listen event only once. When the event is emitted, the `callback` is called and after removes event.

  ```dart
  void _onDestroyed(inst, _) {
    print("$inst was destroyed.");
  }

  Reactter.one(appContext, Lifecycle.destroyed, _onDestroyed);
  // or
  Reactter.one(ReactterInstance<AppContext>(), Lifecycle.destroyed, _onDestroyed);
  ````

- **`Reactter.off`**: Removes the `callback` of event.

  ```dart
  Reactter.off(appContext, Lifecycle.didUpdate, _onDidUpdate);
  // or
  Reactter.off(ReactterInstance<AppContext>(), Lifecycle.didUpdate, _onDidUpdate);
  ```

- **`Reactter.emit`**: Trigger event with or without the `param` given.

  ```dart
  Reactter.emit(appContext, CustomEnum.EventName, "test param");
  // or
  Reactter.emit(ReactterInstance<AppContext>(), CustomEnum.EventName, "test param");
  ```

- **`Reactter.emitAsync`**: Trigger event with or without the `param` given as async way.

  ```dart
  await Reactter.emitAsync(appContext, CustomEnum.EventName, "test param");
  // or
  await Reactter.emitAsync(ReactterInstance<AppContext>(), CustomEnum.EventName, "test param");
  ```

> **NOTE:**
> The `ReactterInstance` helps to find the instance for event. This instance must have been created earlier in the Reactter context.
>
> **RECOMMENDED:**
> Use the instance directly on event methods for optimal performance.

### Using `UseContext` hook

[`UseContext`](https://pub.dev/documentation/reactter/latest/hooks/UseContext-class.html) is a `ReactterHook` that allows to get `ReactterContext`'s instance when it's ready.

```dart
class AppContext extends ReactterContext {
  late final otherContextHook = UseContext<OtherContext>(context: this);
  // late final otherContextHookWithId = UseContext<OtherContext>(id: "uniqueId", context: this);
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
> **NOTE:** The context that you need to get, must be created by [`ReactterInstanceManager`](https://pub.dev/documentation/reactter/latest/core/ReactterInstanceManager-mixin.html).

### Using `UseEvent` hook

[`UseEvent`](https://pub.dev/documentation/reactter/latest/hooks/UseEvent-class.html) is a `ReactterHook` that manages events.

You can listen to event using `on` method:

```dart
enum Events { SomeEvent };

void _onSomeEvent(inst, param) {
  print("$inst's Events.SomeEvent emitted with param: $param.");
}

UseEvent<AppContext>().on(Events.SomeEvent, _onSomeEvent);
```

Use `off` method to stop listening event:

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
> **RECOMMENDED:** If you have the instance, use directly with `UseEvent.withInstance(<instance>)` for optimal performance.

### Using `Signal`

[`Signal`](https://pub.dev/documentation/reactter/latest/core/Signal-class.html) is a class that store a `value` of any type and notify the listeners when the `value` is updated.

> **NOTE:**
> In flutter, using [`ReactterWatcher`](https://pub.dev/documentation/flutter_reactter/latest/widgets/ReactterWatcher-class.html), it's a way to keep the widgets automatically updates, accessing the value of signal reactively.

You can create a new `Signal`, like so:

```dart
// usign `.signal` extension
final strSignal = "initial value".signal;
final intSignal = 0.signal;
final userSignal = User().signal;
// or usign the constructor class
final strSignal = Signal<String>("initial value");
final intSignal = Signal<int>(0);
final userSignal = Signal<User>(User());
```

`Signal` has `value` property that allows to read and write its state:

```dart
intSignal.value = 10;
print("Current state: ${intSignal.value}");
```

Or you can use it as a callable function:

```dart
intSignal(10);
print("Current state: ${intSignal()}");
```

Also, you can use `toString` implict to access its state:

```dart
print("Current state: ${intSignal}");
```

> **NOTE:** `Signal` notifies that its state has changed when the previous state is different from the current state.
> If its state is a `Object`, not detect internal changes, only when states is setted another `Object`.

If you want to notify changes after run a set of instructions, use `update` method:

```dart
userSignal.update((user) {
  user.firstname = "Leo";
  user.lastname = "Leon";
});
```

If you want to force to notify changes, use `refresh` method.

```dart
userSignal.refresh();
```

When `value` is changed, the `Signal` will emitted the following events:

- `Lifecycle.willUpdate` event is triggered before the `value` change or `update`, `refresh` methods have been invoked.
- `Lifecicle.didUpdate` event is triggered after the `value` change or `update`, `refresh` methods have been invoked.

> **NOTE:**
> When you do any arithmetic operation between two `Signal`s, its return a `Obj`, for example: `1.signal + 2.signal` return `3.obj`.
> A [`Obj`](https://pub.dev/documentation/reactter/latest/core/Obj-class.html) is like a `Signal` without reactive functionality, but you can convert it to `Signal` using `.toSignal`.

### Using `UseState` hook

[`UseState`](https://pub.dev/documentation/reactter/latest/hooks/UseState-class.html) is a `ReactterHook` that manages a state.

You can declarate it into the class, with the context argument(`this`) to put this hook on listen, like so:

```dart
class AppContext extends ReactterContext {
  late final count = UseState(0, this);
}
```

Or add it using the `listenHooks` method, which is exposed by `ReactterContext`:

```dart
class AppContext extends ReactterContext {
  final count = UseState(0);

  AppContext() {
    listenHooks([count]);
  }
}
```

> **NOTE:** If you don't add context argument or use `listenHooks`, the `ReactterContext` won't be able to react to hook's changes.

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

If you want to notify changes after run a set of instructions, use `update` method:

```dart
userState.update(() {
  userState.value.firstname = "Leo";
  userState.value.lastname = "Leon";
});
```

If you want to force to notify changes, use `refresh` method.

```dart
userState.refresh();
```

When `value` is changed, the `UseState` will emitted the following events:

- `Lifecycle.willUpdate` event is triggered before the `value` change or `update`, `refresh` methods have been invoked.
- `Lifecicle.didUpdate` event is triggered after the `value` change or `update`, `refresh` methods have been invoked.

### Different between `UseState` and `Signal`

Both `UseState` and `Signal` represent a state(`ReactterState`). But there are a few featues that are different between them.

`UseState` is a `ReactterHook`. This means that it doesn't work outside of `ReactterContext`. Instead a `Signal` can work both outside and inside a `ReactterContext`. This is good for maintaining a global state or internal state if you use it into a `ReactterContext`.

With `UseState` is necessary use `value` property every time for read or write its state. But with `Signal` it is not necessary, improving code readability.

In Flutter, to use `UseState` you need to provide its `ReactterContext` to the Widget tree, with `ReactterProvider` or `ReactterComponent` and access it through of `BuildContext`. With `Signal` use `ReactterWatcher` only, it's very simple.

But it is not all advantages for `Signal`, although it is good for global states and for improving code readability, it is prone to antipatterns and makes debugging difficult(This will be improved in the following versions).

The decision between which one to use is yours. You can use one or both without them getting in the way. And you can even replace a `UseState` with a `Signal` into a `ReactterContext`.

### Using `UseAsyncState` hook

[`UseAsyncState`](https://pub.dev/documentation/reactter/latest/hooks/UseAsyncState-class.html) is a `ReactterHook` with the same functionality as `UseState` but provides a `asyncValue` method, which will be obtained when `resolve` method is executed.

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
    translate
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

### Using `UseReducer` hook

[`UseReducer`](https://pub.dev/documentation/reactter/latest/hooks/UseReducer-class.html) is a `ReactterHook` that manages state using reducer method. An alternative to `UseState`.

> **RECOMMENDED:**
> `UseReducer` is usually preferable to `UseState` when you have complex state logic that involves multiple sub-values or when the next state depends on the previous one.

`UseReducer` accepts three arguments:

 ```dart
  UseReducer(<reducer>, <initialState>, <context>);
 ```

- The `reducer` method contains your custom state logic that calculates the new state using current state, and actions.
- The `initialState` is a unique value of any type with which you initialize the state.
- The `context` represents any instance of the `ReactterContext` which is notified of any change in state.

`UseReducer` exposes a `dispatch` method that allows to invoke the `reducer` method sending a `ReactterAction`.

The current state can be access through `value` property.

Here's the counter example:

 ```dart
class Store {
  final int count;

  Store({this.count = 0});
}

Store _reducer(Store state, ReactterAction<String, int?> action) {
  switch (action.type) {
    case 'INCREMENT':
      return Store(count: state.count + (action.payload ?? 1));
    case 'DECREMENT':
      return Store(count: state.count + (action.payload ?? 1));
    default:
      throw UnimplementedError();
  }
}

class AppContext extends ReactterContext {
  late final state = UseReducer(_reducer, Store(count: 0), this);

  AppContext() {
    print("count: ${state.value.count}"); // count: 0;
    state.dispatch(ReactterAction(type: 'INCREMENT', payload: 2));
    print("count: ${state.value.count}"); // count: 2;
    state.dispatch(ReactterAction(type: 'DECREMENT'));
    print("count: ${state.value.count}"); // count: 1;
  }
}
 ```

Also, you can create the actions as a callable class, extending from `ReactterActionCallable` and use them like this:

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

Store _reducer(Store state, ReactterAction action) =>
  action is ReactterActionCallable ? action(state) : UnimplementedError();

class AppContext extends ReactterContext {
  late final state = UseReducer(_reducer , Store(count: 0), this);

  AppContext() {
    print("count: ${state.value.count}"); // count: 0;
    state.dispatch(IncrementAction(quantity: 2));
    print("count: ${state.value.count}"); // count: 2;
    state.dispatch(DecrementAction());
    print("count: ${state.value.count}"); // count: 1;
  }
}
```

### Using `UseEffect` hook

[`UseEffect`](https://pub.dev/documentation/reactter/latest/hooks/UseEffect-class.html) is a `ReactterHook` that manages side-effect.

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
        // Cleanup - Execute before count state changed or 'willUnmount' event
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
  [someState],
  UseEffect.dispatchEffect
);
```

> **NOTE:**
> If you don't add `context` argument to `UseEffect`, the `callback` don't execute on lifecycle `didMount`, and the `cleanup` don't execute on lifecycle `willUnmount`(theses lifecycle events are used with `flutter_reactter` only).

### Custom hook with `ReactterHook`

[`ReactterHook`](https://pub.dev/documentation/reactter/latest/core/ReactterHook-class.html) is a abstract class that allows to create a Custom Hook.

There are several advantages to using Custom Hooks:

- **Reusability**: you can use the same hook again and again, without the need to write it twice.
- **Clean Code**: extracting part of context logic into a hook will provide a cleaner codebase.
- **Maintainability**: easier to maintain. if you need to change the logic of the hook, you only need to change it once.

Here's the counter example:

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

## Usage with `flutter_reactter`

### Wrap with `ReactterProvider`

[`ReactterProvider`](https://pub.dev/documentation/flutter_reactter/latest/widgets/ReactterProvider-class.html) is a wrapper `StatelessWidget` that provides a
`ReactterContext`'s instance to widget tree that can be access through the `BuildContext`.

```dart
ReactterProvider<AppContext>(
  () => AppContext(),
  builder: (appContext, context, child) {
    context.watch<AppContext>();
    return Text("count: ${appContext.count.value}");
  },
)
```

If you want to create a different `ReactterContext`'s instance, use `id` parameter.

```dart
ReactterProvider<AppContext>(
  () => AppContext(),
  id: "uniqueId",
  builder: (appContext, context, child) {
    context.watchId<AppContext>("uniqueId");
    return Text("count: ${appContext.count.value}");
  },
)
```

> **IMPORTANT:** Dont's use `ReactterContext` with constructor parameters to prevent conflicts.
>
> **NOTE:** `ReactteProvider` is a "scoped". So, the `builder` callback will be rebuild, when the `ReactterContext` changes or any `ReactterHook` specified.
> For this to happen, the `ReactterContext` should put it on listens for `BuildContext`'s `watch`ers.

### Access to `ReactterContext`

Reactter provides additional methods to `BuildContext` to access your `ReactterContext`. These are following:

- **`context.watch`**: Gets the `ReactterContext`'s instance from the closest ancestor of  `ReactterProvider` and watch all `ReactterHook` or `ReactterHook` defined in first paramater.

```dart
final watchContext = context.watch<WatchContext>();
final watchHooksContext = context.watch<WatchHooksContext>(
  (ctx) => [ctx.stateA, ctx.stateB],
);
```

- **`context.watchId`**: Gets the `ReactterContext`'s instance with `id` from the closest ancestor of  `ReactterProvider` and watch all `ReactterHook` or `ReactterHook` defined in second paramater.

```dart
final watchIdContext = context.watchId<WatchIdContext>('id');
final watchHooksIdContext = context.watchId<WatchHooksIdContext>(
  'id',
  (ctx) => [ctx.stateA, ctx.stateB],
);
```

- **`context.use`**: Gets the `ReactterContext`'s instance with/without `id` from the closest ancestor of  `ReactterProvider`.

```dart
final readContext = context.use<ReadContext>();
final readIdContext = context.use<ReadIdContext>('id');
```

> **NOTE:**
> These methods mentioned above uses [`ReactterProvider.contextOf`](https://pub.dev/documentation/flutter_reactter/latest/widgets/ReactterProvider/contextOf.html)
>
> **NOTE:**
> `context.watch` and `context.watchId` watch all or some of the specified `ReactterHook` dependencies and when it will change, re-render widgets in the scope of `ReactterProviders`, `ReactterBuilder` or any Widget that exposes the `BuildContext` like `Build`, `StatelessWidget`, `StatefulWidget`.

### React to `Signal`s with `ReactterWatcher`

[`ReactterWatcher`](https://pub.dev/documentation/flutter_reactter/latest/widgets/ReactterWatcher-class.html) is a `Statefulwidget` that listens for `Signal`s and re-build when any `Signal` is changed.

```dart
final count = 0.signal;
final flag = false.signal;

void increase() => count.value += 1;
void toggle() => flag(!flag.value);

class Example extends StatelessWidget {
  ...
  Widget build(context) {
    return ReactterWatcher(
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
        // This rebuild the widget tree when `count` or `flag` are updated.
        return Column(
          children: [
            Text("Count: $count"),
            Text("Flag is: $flag"),
            // This takes the widget from the `child` property in each rebuild.
            child,
          ],
        );
      },
    );
  }
}
```

### Control re-render with `ReactterBuilder`

[`ReactterBuilder`](https://pub.dev/documentation/flutter_reactter/latest/widgets/ReactterBuilder-class.html) is a `StatelessWidget` that  to to get the `ReactterContext`'s instance from the closest ancestor of `ReactterProvider` and exposes it through the first parameter of `builder` callback.

```dart
ReactterBuilder<AppContext>(
  listenAll: true,
  builder: (appContext, context, child) {
    return Text("Count: ${appContext.count.value}");
  },
)
```

> **NOTE:** `ReactterBuilder` is read-only by default(`listenAll: false`), this means it only renders once.
> Instead use `listenAll` as `true` or use `listenStates` with the `ReactterHook`s specific and then the `builder` callback will be rebuild with every `ReactterContext`'s `ReactterHook` changes.
>
> **NOTE:** `ReactterBuilder` is a "scoped". So, the `builder` callback will be rebuild, when the `ReactterContext` changes or any `ReactterHook` specified.
> For this to happen, the `ReactterContext` should put it on listens for `BuildContext`'s `watch`ers.

### Multiple `ReactterProvider` with `ReactterProviders`

[`ReactterProviders`](https://pub.dev/documentation/flutter_reactter/latest/widgets/ReactterProviders-class.html) is a wrapper `StatelessWidget` that allows to use multiple `ReactterProvider` as nested way.

```dart
ReactterProviders(
  [
    ReactterProvider(
      () => AppContext(),
    ),
    ReactterProvider(
      () => ConfigContext(),
      id: 'App',
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

[`ReactterComponent`](https://pub.dev/documentation/flutter_reactter/latest/widgets/ReactterComponent-class.html) is a abstract `StatelessWidget` class that provides the functionality of `ReactterProvider` with a `ReactterContext` and exposes it through `render` method.

```dart
class CounterComponent extends ReactterComponent<AppContext> {
  const CounterComponent({Key? key}) : super(key: key);

  @override
  get builder => () => AppContext();

  @override
  get id => 'uniqueId';

  @override
  listenStates(appContext) => [appContext.stateA];

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
  - [Calculator example](https://github.com/2devs-team/reactter/tree/master/examples/lib/calculator)
  - [Todos example](https://github.com/2devs-team/reactter/tree/master/examples/lib/todos)
  - [Shopping cart example](https://github.com/2devs-team/reactter/tree/master/examples/lib/shopping_cart)
  - [Tree widget example](https://github.com/2devs-team/reactter/tree/master/examples/lib/tree)
  - [Git search example](https://github.com/2devs-team/reactter/tree/master/examples/lib/api)
  - [Animate widget example](https://github.com/2devs-team/reactter/tree/master/examples/lib/animation)

## Roadmap

We want to keeping adding features for `Reactter`, those are some we have in mind order by priority:

- Widget to control re-render using only hooks.
- Async context.
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
- Translate documentation.
- Write articles or make videos teaching how to use **[Reactter](https://github.com/2devs-team/reactter)**.

Any idea is welcome!

# Authors

- **[Carlos León](https://twitter.com/CarLeonDev)** - <carleon.dev@gmail.com>
- **[Leo Castellanos](https://twitter.com/leoocast10)** - <leoocast.dev@gmail.com>
