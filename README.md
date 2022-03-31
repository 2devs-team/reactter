A light state management with React syntax.

By using `Reactter` you get:

# Features
- Use familiarized syntax such as [UseState](#UseState), [UseEffect](#UseEffect), [UseContext](#UseContext), [Custom hooks](#Custom-hooks) and more.
- Create custom hooks to reuse functionality.
- Reduce significantly boilerplate code.
- Improve code readability.
- Unidirectional data flow.
- An easy way to share global information in the application. 
<br><br>

# Usage

## **UseState**

```dart

class AppContext extends ReactterContext {
        
    // You can create the state here and add it to dependencies in 
    // constructor with listenHooks() */
    final username = UseState<String>("");

    AppContext(){
        listenHooks([username]);
    }

    // We recommend to give the context to the state this way:
    // With this, you no longer need to put it in listenHooks()
    // which is cleaner */
    late final firstName = UseState<String>("Leo", context: this);
    late final lastName = UseState<String>("León", context: this);
}


```
You can also create any other classes and set an [UseState](#UseState) prop to share the state.
```dart
class Global {
  static final currentUser = UseState<User?>(null);
}
```
But if you want reactive widgets you need to use `ReactterContext` or pass this prop to a `ReactterContext`.

See Custom Hooks for an example. 
<br><br>


## **UseEffect**

```dart 
AppContext(){

    UseEffect((){

      userName.value = firstName + lastName;

    }, [firstName, lastName]);

}

```
It should be used inside a `ReactterContext` constructor.
<br><br>

## **UseProvider** and  **UseContext**

```dart
UseProvider(
    contexts: [
        UseContext(
            () => AppContext(),
            init: true,
        )
    ],
    builder: (context, _) {
        
        final appContext1 = context.of<AppContext>();

        final appContext2 = context.of<AppContext>((ctx) => [ctx.userName]);

        final appContext3 = context.ofStatic<AppContext>();

        return Text(appContext1.username.value);
    }
);
```
## Reading values
As you can see, in the example above, you can read the value from context in three different ways:
  1. `context.of<AnyContext>()`: Get all the states listeners of context.
  2. `context.of<AnyContext>((ctx) => [ctx.anyState])`: Get the listener of an specific state to rebuild, you can use as many you need.
  3. `context.ofStatic<AppContext>()`: Read all the states, but no rebuild when change.
<br><br>

## **UseAsyncState**

```dart
class AppContext extends ReactterContext {

    late final userName =
        UseAsyncState<String>("Init state", fillUsername, context: this);

    Future<String> fillUsername() async {
        final userFromApi = await getUserName();

        return userFromApi;
    }

    // You should use anyAsyncState.resolve() to resolve the state
    onClickGetUser(){
        userName.resolve();
    }

}
```

You can execute `resolve()` wherever you want.
<br><br>

## **UseAsyncState.when**

```dart
userContext.userName.when(

    standby: (value) => Text("Standby: ${value}"),

    loading: () => const CircularProgressIndicator(),

    done: (value) => Text(value),

    error: (error) => const Text("Unhandled exception: ${error}"),
)
```

`<AnyAsyncState>.when` receives four functions an always return a widget to handle the view depending from the status of the state:

* `standby`: When the state has the initial value.
* `loading`: When the request for the state is retrieving the value. 
* `done`: When the request is done. 
* `error`: If any errors happens in the request. 
<br><br>

## **Custom hooks**

```dart
mixin UseCart on ReactterHook {
    late final cart = UseState<Cart?>(null, context: this);

    addProductToCart(Product product) {
        final oldProducts = cart.value.products;

        cart.value = cart.value?
            .copyWith(products: [...oldProducts, product]);
    }
}
```

You can use it like this:
```dart
class UserContext extends ReactterContext with UseCart {
  final user = Global.currentUser;

  UserContext() {
    UseEffect(() {
      cart.value = api.getUserCart(user.value?.id ?? 0);
    }, [user]);
  }
}
```
We recommend to use `mixins` for create hooks due the ease of injecting variables, but any class that extends from `ReactterHook` can be a [Custom hook](#Custom-hooks).

<br>

## **Lifecycle methods** on **ReactterContext**:

```dart
@override
awake() {}

@override
willMount() {}

@override
didMount() {}

@override
willUnmount() {}
```
All the `ReacterContext` has this lifecycle methods:

* `awake`: Executes when the instance starts building. 
* `willMount`: Executes before the dependency widget will mount in the tree. 
* `didMount`: Executes after the dependency widget did mount in the tree. 
* `willUnmount`: Executes when the widget removes from the tree. 
<br><br>

# Roadmap
We want keeping adding features for `Reactter`, those are some we have in mind order by priority:

**V2**
- **Tests**
  - Make `Reactter` easy to test.
- **Creates**
  - Have the option for create same instances from a context with different ids, usefull for lists of widgets where each widget goint to have his own state.
- **Lazy UseContext**
  - Don't initialize a context until you will need it.
- **Child widget optional for render**
  - Save a child which won't re-render when the state change.
- **ReactterComponent**
  - A StatelessWidget who going to expose a `ReactterContext` state for all the widget, without needing to write `context.of<T>()`, just `state.someProp`.
- **Equatable**
  - For remove the prop `alwaysUpdate` in state when you are working with Objects or List.

**ReactterComponents (new package)**
- Buttons (Almost ready for release)
- App Bars
- Bottom Bars
- Snackbars
- Drawers
- Floating actions
- Modals
- Inputs
<br><br>

# WARNING: 
## `Reactter` has just left development status, you can use it in production with small applications but with caution, we are working to make it more testable and consider all possible situations of state management. The API could changes in the future due the [Roadmap](#Roadmap).

<br>


# Contribute
If you want to contribute don't hesitate to create an issue or pull-request in **[Reactter repository](https://github.com/Leoocast/reactter).**

You can find us in twitter:
*  [@leoocast10](https://twitter.com/leoocast10)

or by email:

- Leo Castellanos <leoocast.dev@gmail.com>
- Carlos León <carleon.dev@gmail.com> 

<br>

## Copyright (c) 2022 **[2devs.io](https://2devs.io/)** 
