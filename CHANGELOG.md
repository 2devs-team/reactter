# Reactter by [2devs.io](https://2devs.io)

## 3.1.2

### Fixes

- **fix(core)**: Add ref on `Reactter.create`.

### Internal

- **docs**: Fix some documentation.

## 3.1.1

### Fixes

- **fix(widgets)**: Fix `child` and `builder` of `ReactterProvider` is not required when use `ReactterProviders`.

## 3.1.0

### Breaking

- **refactor(core)**: Remove selector aspect from `ReactterProvider.of`.

### Fixes

- **fix(core)**:  Fix `ReactterInstanceManager`'s get method create instance when instance didn't created yet.
- **refactor(engine, widgets)**: Add validations about `child` and `builder` properties.

### Enhancements

- **refactor(core)**: Change `Reactter.delete` named argument to positional argument.

### Internal

- **docs**: Fix README documentation.
- **refactor(tests)**: Add test coverage of 100%.

## 3.0.0

### Breaking

- **build**: Change structure folder. Now the package was separated into two packages, one for dart only([`reactter`](https://pub.dev/packages/reactter)) and one for flutter([`flutter_reactter`](https://pub.dev/packages/flutter_reactter)).
- **refactor(hooks)**: Type return on [`UseAsyncState.when`](https://pub.dev/documentation/reactter/3.0.0/reactter/UseAsyncState/when.html).
- **refactor(widgets)**: Replace [`UseContext`](https://pub.dev/documentation/reactter/2.3.3/reactter/UseContext-class.html) to [`ReactterProvider`](https://pub.dev/documentation/flutter_reactter/3.0.0/widgets/ReactterProvider-class.html).
- **refactor(widgets)**: Replace [`ReactterProvider`](https://pub.dev/documentation/reactter/2.3.3/reactter/ReactterProvider-class.html) to [`ReactterProviders`](https://pub.dev/documentation/reactter/3.0.0/reactter/ReactterProviders-class.html).
- **refactor**: Rename `LifeCycleEvent.onWillMount` to `Lifecycle.willMount`,`LifeCycleEvent.onDidMount` to `Lifecycle.didMount`,`LifeCycleEvent.onWillUpdate` to `Lifecycle.willUpdate`,`LifeCycleEvent.onDidUpdate` to `Lifecycle.didUpdate` and `LifeCycleEvent.onWillUnmount` to `Lifecycle.willUnmount`.
- **refactor(core)**: Move `Reactter.factory.register` to [`Reactter.register`](https://pub.dev/documentation/reactter/3.0.0/core/ReactterInstanceManager/register.html), `Reactter.factory.unregistered` to [`Reactter.unregister`](https://pub.dev/documentation/reactter/3.0.0/core/ReactterInstanceManager/unregister.html), `Reactter.factory.existsInstance` to [`Reactter.factory.exists`](https://pub.dev/documentation/reactter/3.0.0/core/ReactterInstanceManager/exists.html), `Reactter.factory.getInstance` to [`Reactter.get`](https://pub.dev/documentation/reactter/3.0.0/core/ReactterInstanceManager/get.html), `Reactter.factory.deletedInstance` to [`Reactter.delete`](https://pub.dev/documentation/reactter/3.0.0/core/ReactterInstanceManager/delete.html).
- **refactor(core)**: Replace [`ReactterSubscribersManager`](https://pub.dev/documentation/reactter/2.3.3/reactter/ReactterSubscribersManager-class.html) to [`UseEvent`](https://pub.dev/documentation/reactter/3.0.0/hooks/UseEvent-class.html).
- **refactor(core)**: Replace [`BuildContext.read`](https://pub.dev/documentation/reactter/2.3.3/reactter/ReactterBuildContextExtension/read.html) and [`BuildContext.readId`](https://pub.dev/documentation/reactter/2.3.3/reactter/ReactterBuildContextExtension/readId.html) to [`BuildContext.use`](https://pub.dev/documentation/flutter_reactter/3.0.0/widgets/ReactterBuildContextExtension/use.html).

### Enhancements

- **feat(widgets)**: Improve finding [`ReactterContext`](https://pub.dev/documentation/flutter_reactter/3.0.0/hooks/ReactterContext-class.html) in the widget tree via the [`BuildContext`](https://pub.dev/documentation/flutter_reactter/3.0.0/widgets/ReactterBuildContextExtension.html). Now the operation of finding `ReactterContext` is O(1) and `ReactterContext` using id is O(2).
- **refactor(hooks)**: Add more [`Lifecycle`](https://pub.dev/documentation/reactter/3.0.0/core/Lifecycle.html) events(`Lifecycle.registered`,`Lifecycle.unregistered`,`Lifecycle.registered` and `Lifecycle.destroyed`)
- **feat(hooks)**: Add [`UseContext`](https://pub.dev/documentation/reactter/3.0.0/hooks/UseContext-class.html) hook.
- **feat(hooks)**: Add [`UseEvent`](https://pub.dev/documentation/reactter/3.0.0/hooks/UseEvent-class.html) hook.
- **feat(widgets)**: Add [`ReactterScope`](https://pub.dev/documentation/flutter_reactter/3.0.0/widgets/ReactterScope-class.html) widget.
- **refactor(core)**: Add [`Reactter.create`](https://pub.dev/documentation/reactter/3.0.0/core/ReactterInstanceManager/create.html) and [`Reactter.find`](https://pub.dev/documentation/reactter/3.0.0/core/ReactterInstanceManager/find.html).

## 2.3.3

### Enhancements

- **refactor(core,widget)**: Remove life cycle class and move it to reactter_context.

### Internal

- **reactor(example)**: Move buttons and fix typo on tree example.
- **docs(example)**: Change description of some examples.
- **docs**: Remove assets and change README.
- **docs**: Add README to example.

## 2.3.2

### Fixes

- **fix**: format reactter.dart and remove an unnecesary dart file

## 2.3.1

### Internal

- **fix(example)**: Fix typo on counter example button.
- **fix(example)**: Add implement tags on animation example.

## 2.3.0

### Breaking

- **refactor**: Rename `context.of` to `context.watch`.
- **refactor**: Rename `context.ofId` to `context.watchId`.
- **refactor**: Rename `context.ofStatic` to `context.read`.
- **refactor**: Rename `context.ofIdStatic` to `context.readId`.
- **refactor**: Move subscribe and publish pattern to `ReactterSubscribersManager` class. Can use subscribe and publish pattern with enum type specified.
- **refactor(widgets)**: Use `ReactterInheritedProvider` as scope on `ReactterBuilder`.
- **refactor(widgets)**: Add `ReactterBuilder` as scope when doesn't has builder on `ReactterComponent`.
- **refactor(core)**: `HookManager` subscribe to `willUpdate` and `didUpdate` event.
- **refactor(core)**: `WillUpdate` and `DidUpdate` event trigger when its `ReactterHook` update.
- **refactor(engine)**: Manage dependencies of `ReactterPubSub` and `lifecycle` of `ReactterContext`.
- **refactor(widget)**: Performance as the instance of `context` is listen to mark need build.
- **refactor(hooks, widgets)** - Rename `UseProvide` to `ReactterProvider`.

### Fixes

- **fix(hooks,widgets)**: Delete instances of `UseContext` when dispatch updated event on `ReactterProvider`, for prevent has instances duplicated.
- **refacor(widget)**: Fix `ReactterBuilder`.

### Enhancements

- **feat(widgets)**: Send `id` for find `ReactterContext` on `ReactterComponent`.
- **feat(widget)**: Add type on `listenerHooks` of `ReactterBuilder`.
- **feat(hooks)**: Add argument to `resolve` method of `UseAsyncState`.
- **feat(hooks)**: Add `lifecycle` `willUpdate` and `didUpdate`.
- **feat(widget)**: Add `onInit` to `UseContext`.
- **feat(hooks)**: `UseEffect` has lifecycle control of the context.
- **feat(hook)** `UseContext` works with unique ids to create unique instances.
- **feat(widget)**: Add `ReactterComponent`.
- **refactor(core)**: Remove context property as public on `ReactterHook`.
- **feat(engine)**: Remove dependencies when `ReactterProvider` unmount.
- **refactor(core)**: Remove unneccesaries event listeners from `ReactterContext`.
- **refactor(core,hooks)**: Remove innecesary code.
- **refactor(engine)**: Remove props innecesary on `ReactterInheritedProvider`.
- **refactor(hooks)**: Clear code and do code simple on `UseAsyncState`.
- **refactor(core)**: Improve performance how instances manager on `ReactterFactory`.
- **refactor(core)**: Improve `UseEffect`. Now the return of callback execute when a hook was change or `willUnmount` event was invoke.
- **refactor(core)**: Improve `lifecycle` events. Now it use as subscription.

### Internal

- **docs**: Fix some documentation.
- **feat(example)**: Add more example with animation.
- **feat(example)**: Add new examples.
- **docs**: Add badgets, reorder topic, fix examples and improve redacty redaction on README.
- **docs**: Add more documentation.
- **tests**: Add tests for `hooks` and `Widgets`.

## 1.0.1

### Enhancements

- Improve performance with primitive loops in functions.

### Internal

- Fix some documentation.
- Removed Utils folder from library.

## 1.0.0

### Enhancements

- **No need package dependencies**: We decided to remove all dependencies and create a new state management from scratch.
- **Controller now is Context**: `ReactterController` has been replaced by `ReactterContext`, which are the classes that going to manage our states.

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
        late final lastName = UseState<String>("Le??n", context: this);
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
        final appContextStatic = context.ofStatic<AppContext>();

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

-*Note**: UseEffect has to be called inside context constructor.

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

### Internal

- Fix some documentation.
- Package description (was too short).
- Remove unused imports in library.
- Documentation
- 130 points in pub.dev.

## 1.0.0-dev

### Enhancements

- **Controller now is Context**: `ReactterController` has been replaced by `ReactterContext`, which are the classes that going to manage our states.

  ```dart
    class AppContext extends ReactterContext {}
  ```

### Internal

- **No need package dependencies**: We decided to remove all dependencies and create a new state management from scratch.

## 0.0.1-dev.4

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
