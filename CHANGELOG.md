# Reactter by [2devs.io](https://2devs.io)

## [1.0.0-dev] - `Release` `2022-03-30`

### Changed

- **No need package dependencies**: We decided to remove all dependencies and create a new state management from scratch.  

- **Controller now is Context**: `ReactterController` has been replaced by `ReactterContext`, which are the classes that going to manage our states.  

  ```dart
    class AppContext extends ReactterContext {}
  ```

### Added

- **Two ways to manage state**: You can control the listeners from context like this:

  ```dart
    class AppContext extends ReactterContext {
        /* You can create the state here and add it to dependencies in 
        constructor with listenHooks() */
        final username = UseState<String>("");

        AppContext(){
            listenHooks([username]);
        }

        /* But we recommend to give the context to the state this way:
        With this, you no longer need to put it in listenHooks()
       which is cleaner */
        late final firstName = UseState<String>("Leo", context: this);
        late final lastName = UseState<String>("León", context: this);
    }
  ```

- **Added UseProvider widget**: `UseProvider` provide all `ReactterContext` to his children.

  ```dart
    UseProvider(
      contexts: [
        UseContext(
          () => AppContext(),
          init: true,
        ),
      ],
      builder: (context, _) {
        // Get all the states listeners of context.
        final appContext = context.of<AppContext>();

        // Get the listener of an specific state to rebuild.
        final appContext = context.of<AppContext>((ctx) => [ctx.userName]);

        // Read all the states, but no rebuild when change.
        final appContextStaic = context.ofStatic<AppContext>();

        return Text(appContext.username.value);
      }
    );

  ```

- **Remove UseEffect widget**: This widget has been replaced by a class called `UseEffect`. It has exactly the same functionality as the `React Hook`, when a dependency changes, executes the callback parameter.

  ```dart
    UseEffect((){

      userName.value = firstName + lastName;

    }, [firstName, lastName]);
  ```

  **Note**: UseEffect has to be called inside context constructor.

- **Added custom Hooks**: You can create your own hooks with mixin inherit from `ReactterHook`.

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

- **Added UseAsyncState class**: If you need an async state, you can use this:

   ```dart

   class AppContext extends ReactterContext {
       ...

        late final userName =
            UseAsyncState<String>("Init state", fillUsername, context: this);

        Future<String> fillUsername() async {
            final userFromApi = await getUserName();

            return userFromApi;
        }

        ...
   }

    ```

- **Added UseAsyncState.when function**: Added this function to controll the async flow from `UseAsyncState`:

   ```dart
    ...
    ),
    userContext.userName.when(
        
        // Base state
        standby: (value) => Text("Standby: " + value),
        // When is executing the async code
        loading: () => const CircularProgressIndicator(),
        // When the async code has finished
        done: (value) => Text(value),
        // When it throw an error
        error: (error) => const Text(
            "Unhandled exception",
            style: TextStyle(color: Colors.red),
        ),
    ),
    ...

    ```

- **Added lifecycle methods to ReactterContext**:

   ```dart
    @override
    awake() {
        // Executes when the instance starts building.
    }

    @override
    willMount() {
        // Before the dependency widget will mount in the tree.
    }

    @override
    didMount() {
        // After the dependency widget did mount in the tree.
    }

    @override
    willUnmount() {
        // When the widget removes from the tree.
    }

    ```

## [0.0.1-dev.4] - `2022-03-19`

### Added

- useEffect
- useState
- Reactter View
- Reactter State
- Reactter Controller
- Routing Controller
- Helpers
- Exceptions
- Types

### Changed

- First release
