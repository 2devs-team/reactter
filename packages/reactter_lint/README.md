<p align="center">
  <img src="https://raw.githubusercontent.com/2devs-team/reactter_assets/main/reactter_logo_full.png" height="100" alt="Reactter" />
</p>

____

[![Pub Publisher](https://img.shields.io/pub/publisher/reactter?color=013d6d&labelColor=01579b)](https://pub.dev/publishers/2devs.io/packages)
[![Reactter Lint](https://img.shields.io/pub/v/reactter_lint?color=1d7fac&labelColor=29b6f6&label=reactter_lint&logo=dart)](https://pub.dev/packages/reactter_lint)
[![Pub points](https://img.shields.io/pub/points/reactter_lint?color=196959&labelColor=23967F&logo=dart)](https://pub.dev/packages/reactter_lint/score)
[![MIT License](https://img.shields.io/github/license/2devs-team/reactter?color=a85f00&labelColor=F08700&logoColor=fff&logo=Open%20Source%20Initiative)](https://github.com/2devs-team/reactter/blob/master/LICENSE)

`Reactter_lint` is an analytics tool for [Reactter](https://pub.dev/packages/reactter) that helps developers to encourage good coding practices and preventing frequent problems using the conventions Rt.

### Contents

- [Quickstart](#quickstart)
- [Lints](#lints)
  - [rt\_hook\_name\_convention](#rt_hook_name_convention)
    - [Bad](#bad)
    - [Good](#good)
  - [rt\_invalid\_hook\_position](#rt_invalid_hook_position)
    - [Bad](#bad-1)
    - [Good](#good-1)
  - [rt\_invalid\_hook\_register](#rt_invalid_hook_register)
    - [Bad](#bad-2)
    - [Good](#good-2)
  - [rt\_invalid\_state\_creation](#rt_invalid_state_creation)
    - [Bad](#bad-3)
    - [God](#god)
  - [rt\_no\_logic\_in\_create\_state](#rt_no_logic_in_create_state)
    - [Bad](#bad-4)
    - [God](#god-1)
  - [rt\_state\_late\_convention](#rt_state_late_convention)
    - [Bad](#bad-5)
    - [Good](#good-3)

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

### rt_hook_name_convention

The hook name should be prefixed with `use`.

#### Bad

Cause: The hook name is not prefixed with `use`.

```dart
> class MyHook extends RtHook {
  ...
}
```

#### Good

Fix: Name hook using `use` preffix.

```dart
class UseMyHook extends RtHook {
  ...
}
```

### rt_invalid_hook_position

The hook must be defined after the hook register.

#### Bad

Cause: The hook cannot be defined before the hook register.

```dart
class UseMyHook extends RtHook {
  final stateHook = UseState(0);
>  final $ = RtHook.$register;
  ...
}
```

#### Good

Fix: Define it after the hook register.

```dart
class UseMyHook extends RtHook {
  final $ = RtHook.$register;
  final stateHook = UseState(0);
  ...
}
```

### rt_invalid_hook_register

The hook register('$' field) must be final only.

#### Bad

Cause: The hook register cannot be defined using getter.

```dart
class MyHook extends RtHook {
>  get $ => RtHook.$register;
  ...
}
```

Cause: The hook register cannot be defined using setter.

```dart
class UseMyHook extends RtHook {
>  set $(_) => RtHook.$register;
  ...
}
```

Cause: The hook register cannot be defined using `var` keyword.

```dart
class UseMyHook extends RtHook {
>  var $ = RtHook.$register;
  ...
}
```

Cause: The hook register cannot be defined using a type.

```dart
class UseMyHook extends RtHook {
>  Object $ = RtHook.$register;
  ...
}
```

#### Good

Fix: Define it using `final` keyword.

```dart
class UseMyHook extends RtHook {
  final $ = RtHook.$register;
  ...
}
```

### rt_invalid_state_creation

The state must be create under the Reactter context.

#### Bad

Cause: The state cannot be created outside Reactter context.

```dart
class MyState with RtState<MyState> {...}

> final myState = MyState();
```

#### God

Fix: Use `Rt.registerState` method for registering the state under the Reactter context.

```dart
class MyState with RtState<MyState> {...}

final myState = Rt.registerState(() => MyState());
```

### rt_no_logic_in_create_state

Don't put logic in `registerState` method

#### Bad

Cause: The `registerState` method includes additional logic.

```dart
> final myState = Rt.registerState(() {
>   final inst = MyState();
>   inst.foo();
>   return inst;
> });
```

```dart
> final myState = Rt.registerState(() {
>   if (flag) return MyState();
>
>   return OtherState();
> });
```

#### God

Fix: Try moving the logic out of `registerState` method.

```dart
final myState = Rt.registerState(() => MyState());
myState.foo();
```

```dart
final myState = flag 
  ? Rt.registerState(() => MyState())
  : Rt.registerState(() => OtherState());
```

### rt_state_late_convention

The state late must be attached an instance.

#### Bad

Cause: `RtHook` cannot be late without attaching an instance.

```dart
class AppController {
  final stateA = UseState(0);
  final stateB = UseState(0);
>  late final stateLate = UseCompute(
>    () => stateA.value + stateB.value,
>    [stateA, stateB],
>  );
  ...
}
```

#### Good

Fix: Use `Rt.lazyState` for attaching an instance.

```dart
class AppController {
  final stateA = UseState(0);
  final stateB = UseState(0);
  late final stateLate = Rt.lazyState(
    () => UseCompute(
      () => stateA.value + stateB.value,
      [stateA, stateB],
    ),
    this,
  );
  ...
}
```
