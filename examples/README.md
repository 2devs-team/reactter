# Reactter examples

This page contains several examples with different feature of reactter.

And you can also view the examples online using [zapp](https://zapp.run/github/2devs-team/reactter/tree/master/examples).

## Quickstart

Run next commands:

```shell
flutter create .
flutter run
```

for [Github search example](#github-search), add http permission:

- [Android](https://docs.flutter.dev/development/data-and-backend/networking#android)
- [IOS](https://guides.codepath.com/ios/Internet-Permissions)

## Counter

Increase and decrease the counter.

> Learn how to use signal.

[![Counter example](https://raw.githubusercontent.com/2devs-team/reactter_assets/main/examples/counter_example.gif)](https://github.com/2devs-team/reactter/tree/master/example/lib/examples/counter)

Implements: `ReactterWatcher`, `Signal`.

## Calculator

Performs simple arithmetic operations on numbers

> Learn how to use multiple signal.

[![Counter example](https://raw.githubusercontent.com/2devs-team/reactter_assets/main/examples/calculator_example.png)](https://github.com/2devs-team/reactter/tree/master/example/lib/examples/calculator)

Implements: `ReactterContext`, `ReactterProvider`, `ReactterWatcher`, `Signal`.

## Todos

Add and remove to-do, mark and unmark to-do as done and filter to-do list.

> Learn how to use the reducer hook like Redux.

[![Todos example](https://raw.githubusercontent.com/2devs-team/reactter_assets/main/examples/todos_example.gif)](https://github.com/2devs-team/reactter/tree/master/example/lib/examples/todos)

Implements: `ReactterActionCallable`, `ReactterContext`, `ReactterProvider`, `UseReducer`.

## Shopping cart

Add, remove product to cart and checkout.

> Learn how to access to other context and keep its state.

[![Shopping cart example](https://raw.githubusercontent.com/2devs-team/reactter_assets/main/examples/cart_example.gif)](https://github.com/2devs-team/reactter/tree/master/example/lib/examples/shopping_cart)

Implements: `ReactterComponent`, `ReactterContext`, `ReactterProvider`, `ReactterProviders`, `UseState`.

## Tree widget

Add, remove and hide child widget with counter.

> Learn how to add or remove context dynamic and keep its state.

[![Tree widget example](https://raw.githubusercontent.com/2devs-team/reactter_assets/main/examples/tree_example.gif)](https://github.com/2devs-team/reactter/tree/master/example/lib/examples/tree)

Implements: `ReactterComponent`, `ReactterContext`, `ReactterProvider`, `UseState`.

## Github search

Search user or repository and show info about it.

> Learn how to manage state in async way.

[![Github search example](https://raw.githubusercontent.com/2devs-team/reactter_assets/main/examples/api_example.gif)](https://github.com/2devs-team/reactter/tree/master/example/lib/examples/api)

Implements: `ReactterContext`, `ReactterComponent`, `ReactterProvider`, `UseAsyncState`, `UseState`.

## Animate widget

Change size, shape and color using animations.

> Learn how to create a custom hook.

[![Animate widget example](https://raw.githubusercontent.com/2devs-team/reactter_assets/main/examples/animation_example.gif)](https://github.com/2devs-team/reactter/tree/master/example/lib/examples/animation)

Implements: `ReactterContext`, `ReactterHook`, `ReactterProvider`, `UseEvent`.
