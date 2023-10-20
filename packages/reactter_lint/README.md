<p align="center">
  <img src="https://raw.githubusercontent.com/2devs-team/reactter_assets/main/reactter_logo_full.png" height="100" alt="Reactter" />
</p>

____

[![Pub Publisher](https://img.shields.io/pub/publisher/reactter?color=013d6d&labelColor=01579b)](https://pub.dev/publishers/2devs.io/packages)
[![Reactter Lint](https://img.shields.io/pub/v/reactter_lint?color=1d7fac&labelColor=29b6f6&label=reactter_lint&logo=dart)](https://pub.dev/packages/reactter_lint)
[![Pub points](https://img.shields.io/pub/points/reactter_lint?color=196959&labelColor=23967F&logo=dart)](https://pub.dev/packages/reactter_lint/score)
[![MIT License](https://img.shields.io/github/license/2devs-team/reactter?color=a85f00&labelColor=F08700&logoColor=fff&logo=Open%20Source%20Initiative)](https://github.com/2devs-team/reactter/blob/master/LICENSE)

`Reactter_lint` is an analytics tool for [Reactter](https://pub.dev/packages/reactter) that helps developers to encourage good coding practices and preventing frequent problems using the conventions Reactter.

## Contents

- [Quickstart](#quickstart)
- [Lints](#lints)
  - [hook_late_convention](#hook_late_convention)
  - [hook_name_convention](#hook_name_convention)
  - [invalid_hook_position](#invalid_hook_position)
  - [invalid_hook_register](#invalid_hook_register)

## Quickstart

Run this command in your root project:

```sh
dart pub add -d reactter_lint custom_lint
```

And then include these lines of code into `analysis_options.yaml`:

```yaml
analyzer:
  plugins:
    - custom_lint
```

Then you can see suggestions in your IDE or you can run checks manually:

```sh
dart run custom_lint
```

## Lints

### hook_late_convention

The hook late must be attached an instance.

#### Bad

Cause: `ReactterHook` cannot be late without attaching an instance.

```dart
class AppController {
  final otherState = UseState(0);
  late final stateLate = UseState(otherState.value);
  ...
}
```

#### Good

Fix: Use `Reactter.lazyState` for attaching a instance.

```dart
class AppController {
  final otherState = UseState(0);
  late final stateLate = Reactter.lazyState(
    () => UseState(otherState.value),
    this,
  );
  ...
}
```

### hook_name_convention

The hook name should be prefixed with `use`.

#### Bad

Cause: The hook name is not prefixed with `use`.

```dart
class MyHook extends ReactterHook {
  ...
}
```

#### Good

Fix: Name hook using `use` preffix.

```dart
class UseMyHook extends ReactterHook {
  ...
}
```

### invalid_hook_position

The hook must be defined after the hook register.

#### Bad

Cause: The hook cannot be defined before the hook register.

```dart
class UseMyHook extends ReactterHook {
  final stateHook = UseState(0);
  final $ = ReactterHook.$register;
  ...
}
```

#### Good

Fix: Define it after the hook register.

```dart
class UseMyHook extends ReactterHook {
  final $ = ReactterHook.$register;
  final stateHook = UseState(0);
  ...
}
```

### invalid_hook_register

The hook register('$' field) must be final only.

#### Bad

Cause: The hook register cannot be defined using getter.

```dart
class MyHook extends ReactterHook {
  get $ => ReactterHook.$register;
  ...
}
```

Cause: The hook register cannot be defined using setter.

```dart
class UseMyHook extends ReactterHook {
  set $(_) => ReactterHook.$register;
  ...
}
```

Cause: The hook register cannot be defined using `var` keyword.

```dart
class UseMyHook extends ReactterHook {
  var $ = ReactterHook.$register;
  ...
}
```

Cause: The hook register cannot be defined using a type.

```dart
class UseMyHook extends ReactterHook {
  Object $ = ReactterHook.$register;
  ...
}
```

#### Good

Fix: Define it using `final` keyword.

```dart
class UseMyHook extends ReactterHook {
  final $ = ReactterHook.$register;
  ...
}
```
