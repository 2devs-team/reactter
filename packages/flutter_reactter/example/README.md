# Reactter examples

This page contains several examples with different feature of Reactter.

And you can also view the examples online using [zapp](https://zapp.run/pub/flutter_reactter).

## Quickstart

Run next commands:

```shell
flutter create .
flutter run
```

for [Github search example](#github-search), add http permission(This is the documented [here](https://docs.flutter.dev/data-and-backend/networking))

## Counter

Increase and decrease the counter.

> Learn how to use reactive state using UseState.

[![Counter example](https://raw.githubusercontent.com/2devs-team/reactter_assets/main/examples/counter_example.gif)](https://github.com/2devs-team/reactter/tree/master/packages/flutter_reactter/example/lib/counter)

Implements: `RtWatcher`, `UseState`.

## Calculator

Performs simple arithmetic operations on numbers

> Learn how to provide and consume a dependency

[![Counter example](https://raw.githubusercontent.com/2devs-team/reactter_assets/main/examples/calculator_example.png)](https://github.com/2devs-team/reactter/tree/master/packages/flutter_reactter/example/lib/calculator)

Implements: `BuildContext.use`, `RtProvider`, `RtSelector`, `RtWatcher`, `UseState`.

## Shopping cart

Add, remove product to cart and checkout.

> Learn how to access to other dependency and keep its state.

[![Shopping cart example](https://raw.githubusercontent.com/2devs-team/reactter_assets/main/examples/cart_example.gif)](https://github.com/2devs-team/reactter/tree/master/packages/flutter_reactter/example/lib/shopping_cart)

Implements: `ReactterComponent`, `RtConsumer`, `RtProvider`, `RtProviders`, `RtSelector`, `UseDependencycy`, `UseState`.

## Tree widget

Add, remove and hide child widget with counter.

> Learn how to add or remove dependency dynamic and keep its state.

[![Tree widget example](https://raw.githubusercontent.com/2devs-team/reactter_assets/main/examples/tree_example.gif)](https://github.com/2devs-team/reactter/tree/master/packages/flutter_reactter/example/lib/tree)

Implements: `BuilContext.use`, `BuilContext.watchId`, `Reactter.lazyState`, `ReactterComponent`, `RtProvider`, `UseEffect`, `UseState`.

## Github search

Search user or repository and show info about it.

> Learn how to manage state in async way.

[![Github search example](https://raw.githubusercontent.com/2devs-team/reactter_assets/main/examples/api_example.png)](https://github.com/2devs-team/reactter/tree/master/packages/flutter_reactter/example/lib/api)

Implements: `Memo`, `RtConsumer`, `RtProvider`, `UseAsyncState`.

## To-Do List

Add and remove to-do, mark and unmark to-do as done and filter to-do list.

> Learn how to use the reducer hook like Redux.

[![To-Do List example](https://raw.githubusercontent.com/2devs-team/reactter_assets/main/examples/todos_example.png)](https://github.com/2devs-team/reactter/tree/master/packages/flutter_reactter/example/lib/todo)

Implements: `Reactter.lazyState`, `ReactterActionCallable`, `ReactterCompontent`, `RtConsumer`, `RtProvider`, `RtSelector`, `UseCompute`, `UseReducer`.

## Animate widget

Change size, shape and color using animations.

> Learn how to create a custom hook.

[![Animate widget example](https://raw.githubusercontent.com/2devs-team/reactter_assets/main/examples/animation_example.gif)](https://github.com/2devs-team/reactter/tree/master/packages/flutter_reactter/example/lib/animation)

Implements: `Reactter.lazyState`, `RtConsumer`, `ReactterHook`, `RtProvider`, `RtSelector`, `UseCompute`, `UseEffect`, `UseState`.
