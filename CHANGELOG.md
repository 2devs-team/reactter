# Reactter

## 7.2.0

### Breakings

- **refactor(core,hooks,test):** Deprecate and replace some enums and methods on Lifecycle to use the right concept.
  - Deprecated `Lifecycle.initialized`, use `Lifecycle.created` instead.
  - Deprecated `Lifecycle.destroyed`, use `Lifecycle.deleted` instead.
  - Deprecated [`onInitialized`](https://pub.dev/documentation/reactter/7.1.0/reactter/LifecycleObserver/onInitialized.html) method of `LifecycleObserver`, use [`onCreated`](https://pub.dev/documentation/reactter/7.2.0/reactter/LifecycleObserver/onCreated.html) method instead.
  - Deprecated [`onDestroyed`](https://pub.dev/documentation/reactter/7.1.0/reactter/LifecycleObserver/onDestroyed.html) method of `LifecycleObserver`, use [`onDeleted`](https://pub.dev/documentation/reactter/7.2.0/reactter/LifecycleObserver/onDeleted.html) method instead.
- **refactor(widgets):** Update  [`ReactterProvider`](https://pub.dev/documentation/flutter_reactter/7.1.0/flutter_reactter/ReactterProvider/ReactterProvider.html) to use [`ReactterProvider.init`](https://pub.dev/documentation/flutter_reactter/7.2.0/flutter_reactter/ReactterProvider/ReactterProvider.init.html) constructor instead of `init` property.
  - Deprecated `init` property of [`ReactterProvider`](https://pub.dev/documentation/flutter_reactter/7.1.0/flutter_reactter/ReactterProvider/ReactterProvider.html), use [`ReactterProvider.init`](https://pub.dev/documentation/flutter_reactter/7.2.0/flutter_reactter/ReactterProvider/ReactterProvider.init.html) instead.

### Enhancements

- **feat(core):** Add [`Reactter.hasRegister`](https://pub.dev/documentation/reactter/7.2.0/reactter/ReactterInterface/hasRegister.html) method to check if the dependency is registered in Reactter.
- **refactor(framework):** Improve lazy loading performance in `ProviderImpl`, update implementation to reduce unnecessary checks and streamline widget rendering.

### Fixes

- **fix(core):** Prevent all `ReactterDependency` events from being deleted after deregistering a dependency.
  - Update [`offAll`](https://pub.dev/documentation/reactter/7.2.0/reactter/ReactterInterface/offAll.html) method in `EventHandler` to support generic removal.
- **fix(hooks):** Ensure that the callback is executed by the `dependencies` of  `UseEffect`.
- **refactor(hooks):** Improve error handling in `UseEffect`.

### Internal

- **refactor(core,framework,hooks):** Update `dependencyInjection` getter names in Reactter codebase.
- **refactor(framework,test):** Rename `reactter_instance` to `reactter_dependency` and fix imports and exports.
- **doc(hooks):** Update `UseReducer` and `UseState` documentation to improve clarity and consistency.
- **test(core,hooks):** Rename some files and update the descriptions.
- **test(core):** Add [`Reactter.hasRegister`](https://pub.dev/documentation/reactter/7.2.0/reactter/ReactterInterface/hasRegister.html) test.
- **refactor:** Remove unnecessary 'late' modifier in `TestController`.
- **test:** Add comparable test cases for `Args`.
- **refactor:** :memo: Improve some comments and documentation for clarity and consistency.
- **test:** :memo: Update the descriptions of some test for clarity and consistency.
- **test(widgets):** Add test case for nullish dependency obtained from context.
- **test(widgets):** Add test case for getting dependency form `ReactterProvider` siblings.
- **refactor:** Resolve lints and formatting issues.

## 7.1.0

### Breakings

- **refactor(core,framework,hooks,test):** Deprecate and replace some classes and methods to use the right concept.
  - Deprecated [`UseInstance`](https://pub.dev/documentation/reactter/7.0.1/reactter/UseInstance-class.html) hook, use [`UseDependency`](https://pub.dev/documentation/reactter/7.1.0/reactter/UseDependency-class.html) hook instead.
  - Deprecated [`InstanceManageMode`](https://pub.dev/documentation/reactter/7.0.1/reactter/InstanceManageMode.html) enum, use [`DependencyMode`](https://pub.dev/documentation/reactter/7.1.0/reactter/DependencyMode.html) enum instead.
  - Deprecated [`ReactterInstance`](https://pub.dev/documentation/reactter/7.0.1/reactter/ReactterInstance-class.html) class, use [`ReactterDependency`](https://pub.dev/documentation/reactter/7.1.0/reactter/ReactterDependency-class.html) class instead.
  - Deprecated [`getInstanceManageMode`](https://pub.dev/documentation/reactter/7.0.1/reactter/ReactterInterface/getInstanceManageMode.html) method, use [`getDependencyMode`](https://pub.dev/documentation/reactter/7.1.0/reactter/ReactterInterface/getDependencyMode.html) method instead.

### Internal

- **refactor(core,framework,hooks,test):** Deprecate and replace some classes and methods to use the right concept.
  - Renamed `InstanceManager` class to `DependencyInjection`.
  - Renamed `EventManager` class to `EventHandler`.
  - Renamed `StateManager` class to `StateManagement`.

## 7.0.1

### Internal

- **test:** Refactor and structure examples.
- **doc:** Update `ReactterWatcher` builder comments for clarity.

## 7.0.0

### Enhancements

- **feat(core, framework):** Add [`Reactter.batch`](https://pub.dev/documentation/reactter/7.0.0/reactter/ReactterInterface/batch.html) and [`Reactter.untracked`](https://pub.dev/documentation/reactter/7.0.0/reactter/ReactterInterface/untracked.html) methods.
  - [`Reactter.batch`](https://pub.dev/documentation/reactter/7.0.0/reactter/ReactterInterface/batch.html) hepls to execute the given `callback` function within a batch operation. A batch operation allows multiple state changes to be grouped together, ensuring that any associated side effects are only triggered once, improving performance and reducing unnecessary re-renders.
  - [`Reactter.untracked`](https://pub.dev/documentation/reactter/7.0.0/reactter/ReactterInterface/untracked.html) hepls to execute the given `callback` function without tracking any state changes. This means that any state changes that occur inside the `callback` function will not trigger any side effects.
- **refactor(framework):** Refactor lifecycle event handling and add lifecycle observer interface.
  - Add [`LifecycleObserver`](https://pub.dev/documentation/reactter/7.0.0/reactter/LifecycleObserver-class.html) inteface for event handling of the instance.
  - Add [`didUnmount`](https://pub.dev/documentation/reactter/7.0.0/reactter/Lifecycle.html) lifecycle.
- **refactor(core, framework, types):** Add [`LogLevel`](https://pub.dev/documentation/reactter/7.0.0/reactter/LogLevel.html) enum and update [`defaultLogWriterCallback`](https://pub.dev/documentation/reactter/7.0.0/reactter/defaultLogWriterCallback.html) signature.
- **refactor(hooks):** Improve [`UseEffect`](https://pub.dev/documentation/reactter/7.0.0/reactter/UseEffect-class.html) performance and readability.
  - Add [`UseEffect.runOnInit`](https://pub.dev/documentation/reactter/7.0.0/reactter/UseEffect/UseEffect.runOnInit.html) constructor to execute callback effect on initialization.
- **feat(framework, widgets):** Add [`ReactterProvider.lazy`](https://pub.dev/documentation/flutter_reactter/7.0.0/flutter_reactter/ReactterProvider/ReactterProvider.lazy.html) constructor for lazy instance initialization.
- **refactor(widgets):** Add `id`property to [`ReactterComponent`](https://pub.dev/documentation/flutter_reactter/7.0.0/flutter_reactter/ReactterComponent-class.html) for debugging information.

### Breakings

- **refactor(extensions, hooks, objs, signals):** Remove features deprecated.
  - Remove  [`List<ReactterState>.when`](https://pub.dev/documentation/flutter_reactter/6.2.0/flutter_reactter/ReactterStateListExtension/when.html), use [`context.select`](https://pub.dev/documentation/flutter_reactter/7.0.0/flutter_reactter/ReactterBuildContextExtension/select.html) or [`UseCompute`](https://pub.dev/documentation/reactter/7.0.0/reactter/UseCompute-class.html) instead.
  - Remove [`UseContext`](https://pub.dev/documentation/reactter/6.2.0/reactter/UseContext.html), use [`UseInstance`](https://pub.dev/documentation/reactter/6.2.0/reactter/UseInstance-class.html) instead.
  - Remove [`UseEvent`](https://pub.dev/documentation/reactter/6.2.0/reactter/UseEvent-class.html), use event shortcuts instead.
  - Remove `initialState` and `reset` from [`UseState`](https://pub.dev/documentation/reactter/6.2.0/reactter/UseState-class.html).
  - Remove [`.obj`](https://pub.dev/documentation/reactter/6.2.0/reactter/ObjGenericTypeExt.html), use  [`Obj`](https://pub.dev/documentation/reactter/7.0.0/reactter/Obj-class.html) class instead.
  - Remove [`.signal`](https://pub.dev/documentation/reactter/6.2.0/reactter/SignalGenericTypeExt.html), use [`Signal`](https://pub.dev/documentation/reactter/7.0.0/reactter/Signal-class.html) class instead.
- **refactor(framework, widgets, test):** Change the position of [`InstanceContextBuilder`](https://pub.dev/documentation/flutter_reactter/6.2.0/flutter_reactter/InstanceContextBuilder.html)([`InstanceChildBuilder`](https://pub.dev/documentation/reactter/7.0.0/reactter/InstanceChildBuilder.html) now) arguments.
  - Move `context` to first argument on [`InstanceContextBuilder`](https://pub.dev/documentation/flutter_reactter/6.2.0/flutter_reactter/InstanceContextBuilder.html)([`InstanceChildBuilder`](https://pub.dev/documentation/reactter/7.0.0/reactter/InstanceChildBuilder.html) now).
  - Adapt the [`InstanceContextBuilder`](https://pub.dev/documentation/flutter_reactter/6.2.0/flutter_reactter/InstanceContextBuilder.html)([`InstanceChildBuilder`](https://pub.dev/documentation/reactter/7.0.0/reactter/InstanceChildBuilder.html) now) of [`ReactterComponent`](https://pub.dev/documentation/flutter_reactter/7.0.0/flutter_reactter/ReactterComponent-class.html), [`ReactterConsumer`](https://pub.dev/documentation/flutter_reactter/7.0.0/flutter_reactter/ReactterConsumer-class.html) and [`ReactterProvider`](https://pub.dev/documentation/flutter_reactter/7.0.0/flutter_reactter/ReactterProvider-class.html) widgets.
- **refactor(core, hooks):** Rename [`attachTo`](https://pub.dev/documentation/reactter/6.2.0/reactter/ReactterState/attachTo.html) to [`bind`](https://pub.dev/documentation/reactter/7.0.0/reactter/ReactterState/bind.html), [`detachInstance`](https://pub.dev/documentation/reactter/6.2.0/reactter/ReactterState/detachInstance.html) to [`unbind`](https://pub.dev/documentation/reactter/7.0.0/reactter/ReactterState/unbind.html) and [`instanceAttached`](https://pub.dev/documentation/reactter/6.2.0/reactter/ReactterState/instanceAttached.html) to [`instanceBinded`](https://pub.dev/documentation/reactter/7.0.0/reactter/ReactterState/instanceBinded.html).
- **refactor(hooks):** Improve [`UseEffect`](https://pub.dev/documentation/reactter/7.0.0/reactter/UseEffect-class.html) performance and readability.
  - Remove [`context`](https://pub.dev/documentation/reactter/6.2.0/reactter/UseEffect/context.html) argument from `UseEffect`. It is no longer useful. Can use [`bind`](https://pub.dev/documentation/reactter/7.0.0/reactter/ReactterState/bind.html) method instead.

### Fixes

- **fix(obj):** Fix equality comparison in `ObjBase` class.
- **fix(core):** Resolve event for both types(instanceRef, instanceObj) and log event error.
- **fix(core):** Find the instance registered by the instance manager when searching for the extended class.
- **refactor(core):** Fix out-of-bounds index on `getHashCodeRefAt` method.

### Internal

- **refactor(framework, widgets, test):** Change the position of [`InstanceContextBuilder`](https://pub.dev/documentation/flutter_reactter/6.2.0/flutter_reactter/InstanceContextBuilder.html)([`InstanceChildBuilder`](https://pub.dev/documentation/reactter/7.0.0/reactter/InstanceChildBuilder.html) now) arguments.
  - Adjust the tests about [`ReactterComponent`](https://pub.dev/documentation/flutter_reactter/7.0.0/flutter_reactter/ReactterComponent-class.html), [`ReactterConsumer`](https://pub.dev/documentation/flutter_reactter/7.0.0/flutter_reactter/ReactterConsumer-class.html) and [`ReactterProvider`](https://pub.dev/documentation/flutter_reactter/7.0.0/flutter_reactter/ReactterProvider-class.html) widgets.
  - Adjust the documentation about [`ReactterComponent`](https://pub.dev/documentation/flutter_reactter/7.0.0/flutter_reactter/ReactterComponent-class.html), [`ReactterConsumer`](https://pub.dev/documentation/flutter_reactter/7.0.0/flutter_reactter/ReactterConsumer-class.html) and [`ReactterProvider`](https://pub.dev/documentation/flutter_reactter/7.0.0/flutter_reactter/ReactterProvider-class.html) widgets.
- **refactor(framework, widgets, test):** Improve framework structure and simplify the [`ReactterProvider`](https://pub.dev/documentation/flutter_reactter/7.0.0/flutter_reactter/ReactterProvider-class.html) code.
  - Remove `Reactter` prefix of the framework classes.
  - Add `ProviderBase`, `ProviderImpl`, `ProviderElement` and `ProviderRef` class.
  - Rename [`InstanceContextBuilder`](https://pub.dev/documentation/flutter_reactter/6.2.0/flutter_reactter/InstanceContextBuilder.html) to [`InstanceChildBuilder`](https://pub.dev/documentation/reactter/7.0.0/reactter/InstanceChildBuilder.html) and [`InstanceValueBuilder`](https://pub.dev/documentation/flutter_reactter/6.2.0/flutter_reactter/InstanceValueBuilder.html) to [`InstanceValueChildBuilder`](https://pub.dev/documentation/flutter_reactter/7.0.0/flutter_reactter/InstanceValueChildBuilder.html).
  - Add [`ChildBuilder`](https://pub.dev/documentation/flutter_reactter/7.0.0/flutter_reactter/ChildBuilder.html) type.
  - Add `Reactter.getHashCodeRef` method.
- **refactor:** Refactor file structure and imports.
- **refactor(core, framework, hooks, signal):** Rename variables of `ReactterZone` and improve `ReactterState` implementation.
- **refactor(test):** Add `lazyState`, `untracked` and `batch` tests.
- **refactor(core, test):** Fix lifecycle event handling and add lifecycle_observer test.
- **refactor(core, framework, test):** Refactor event manager and remove unused code for 100% coverage.
- **refactor(core, framework):** Add `BindingZone` class and update references.
- **fix(core):** Fix generic type constraint in `_getInstanceRef` method.
- **refactor(core):** Refactor event handling logic and optimize listener removal.
- **test(core, hooks):** Add tests for signal usage on instance and binding to another instance.
- **test(widgets):** Add [`ReactterProvider.lazy`](https://pub.dev/documentation/flutter_reactter/7.0.0/flutter_reactter/ReactterProvider/ReactterProvider.lazy.html) tests, update [`ReactterComponent`](https://pub.dev/documentation/flutter_reactter/7.0.0/flutter_reactter/ReactterComponent-class.html) tests and add [`LifecycleObserver`](https://pub.dev/documentation/reactter/7.0.0/reactter/LifecycleObserver-class.html) to `TestController`.
- **fix(example):** Update dependencies and fix code formatting on examples.

## 6.2.0

### Breakings

- **refactor:** Deprecate [`.signal`](https://pub.dev/documentation/reactter/6.2.0/reactter/SignalGenericTypeExt.html) and [`.obj`](https://pub.dev/documentation/reactter/6.2.0/reactter/ObjGenericTypeExt.html) extensions, use [`Signal`](https://pub.dev/documentation/reactter/6.2.0/reactter/Signal-class.html) and [`Obj`](https://pub.dev/documentation/reactter/6.2.0/reactter/Obj-class.html) class instead.

### Internal

- **doc:** Improve README.
- **fix(example):** Reset `doneCount` when clear todo completed.

## 6.1.0

### Enhancements

- **feat(framework, widgets, extensions):** Add [`ReactterSelector`](https://pub.dev/documentation/flutter_reactter/6.1.0/flutter_reactter/ReactterSelector-class.html) widget and [`context.select`](https://pub.dev/documentation/flutter_reactter/6.1.0/flutter_reactter/ReactterBuildContextExtension/select.html) method extension.
  - [`ReactterSelector`](https://pub.dev/documentation/flutter_reactter/6.1.0/flutter_reactter/ReactterSelector-class.html) and [`context.select`](https://pub.dev/documentation/flutter_reactter/6.1.0/flutter_reactter/ReactterBuildContextExtension/select.html) help to control the rebuilding of widget tree using a `Selector` methods that allows to select a state specific for listening, and return a computed value.
- **feat(widgets):** Add [`ReactterScope`](https://pub.dev/documentation/flutter_reactter/6.1.0/flutter_reactter/ReactterScope-class.html) Widget.
If `ReactterProvider.contextOf` doesn't have a type defined, use `ReactterScope` to work correctly.

### Breakings

- **perf(framework):** Remove `updateAsync` from [`ReactterHook`](https://pub.dev/documentation/reactter/6.1.0/reactter/ReactterHook-class.html) and [`ReactterState`](https://pub.dev/documentation/reactter/6.1.0/reactter/ReactterState-class.html).
- **perf(framework):** Remove `emitAsync` from [`ReactterEventManager`](https://pub.dev/documentation/reactter/6.1.0/reactter/ReactterEventManager-class.html).
- **refactor(extensions):** Deprecate [`List<ReactterState>.when`](https://pub.dev/documentation/flutter_reactter/6.1.0/flutter_reactter/ReactterStateListExtension/when.html), use [`context.select`](https://pub.dev/documentation/flutter_reactter/6.1.0/flutter_reactter/ReactterBuildContextExtension/select.html) or [`UseCompute`](https://pub.dev/documentation/reactter/6.1.0/reactter/UseCompute-class.html) instead.

### Fixes

- **fix(widgets):** Notify `ReactterWatcher` has changed when available.
- **fix(framework):** Remove `UseWen` asynchronously when call `markNeedsNotifyDependents` through its changes.

### Internal

- **perf(framework):** Add `ReactterNotifier` to manage events.
- **refactor(widgets):** Improve `ReactterProvider` code.
- **perf(extensions, framework, widgets):** Improve performance of `context.watch`.
- **refactor(types):** Add `WatchState` and `SelectComputeValue` types.
- **refactor(framework):** Improve message error about `notifyListeners` of `ReactterNotifier`.
- **feat(framework, widgets, extensions):** Improve managing dependency.
- **test(framework, widgets, hooks):** Fix some part for test coverage.
- **test:** Add `context.select` and `ReactterSelector` test.
- **doc:** Fix some code documentation.
- **refactor(example):** Improve api example.
- **doc:** Add documention about new features.

## 6.0.2

### Fixes

- **fix(signal):** Add missing getters(`first`, `last`, and `length`) to Signal of list type.

## 6.0.0

### Enhancements

- **feat(args):** Implement generic arguments.
  - Add the [`Args`](https://pub.dev/documentation/reactter/6.0.0/reactter/Args-class.html) class which represent one or more arguments.
  - Add the [`Args1`](https://pub.dev/documentation/reactter/6.0.0/reactter/Args1-class.html), [`Args2`](https://pub.dev/documentation/reactter/6.0.0/reactter/Args2-class.html) and [`Args3`](https://pub.dev/documentation/reactter/6.0.0/reactter/Args3-class.html) classes which represent one, two and three arguments respectively.
  - Add the types [`ArgsX2`](https://pub.dev/documentation/reactter/6.0.0/reactter/ArgsX2.html) and [`ArgsX3`](https://pub.dev/documentation/reactter/6.0.0/reactter/ArgsX3.html) which represent [`Args2`](https://pub.dev/documentation/reactter/6.0.0/reactter/Args2-class.html) and [`Args3`](https://pub.dev/documentation/reactter/6.0.0/reactter/Args3-class.html) with the same arguments type.
  - Add [`ary`](https://pub.dev/documentation/reactter/6.0.0/reactter/AryFunction/ary.html) methods for converting Function to Function with generic arguments.
- **feat(memo):** Implement the [`Memo`](https://pub.dev/documentation/reactter/6.0.0/reactter/Memo-class.html) class. It's used for memoizing values returned by a calcutate function.
- **feat(memo):** Add [`MemoInterceptors`](https://pub.dev/documentation/reactter/6.0.0/reactter/MemoInterceptors-class.html), [`MemoInterceptor`](https://pub.dev/documentation/reactter/6.0.0/reactter/MemoInterceptor-class.html) and [`MemoInterceptorWrapper`](https://pub.dev/documentation/reactter/6.0.0/reactter/MemoInterceptorWrapper-class.html) for intercepting and handling various events during the memoization process.
- **feat(memo):** Add [`AsyncMemoSafe`](https://pub.dev/documentation/reactter/6.0.0/reactter/AsyncMemoSafe-class.html)  for removing the memoized value if its futures that throw an error when executed.
- **feat(memo):** Add [`TemporaryCacheMemo`](https://pub.dev/documentation/reactter/6.0.0/reactter/TemporaryCacheMemo-class.html) for removing memoized values from the cache after a specified duration.
- **feat(framework, widgets)**:Improve `ReactterInstanceManager` and `ReactterInstance`.
  - Add `ref` parameter to [`Reactter.get`](https://pub.dev/documentation/reactter/6.0.0/reactter/ReactterInstanceManager/get.html).
  - Add [`Reactter.destory`](https://pub.dev/documentation/reactter/6.0.0/reactter/ReactterInstanceManager/destroy.html).
  - Add [`InstanceManageMode.builder`](https://pub.dev/documentation/reactter/6.0.0/InstanceManageMode/InstanceManageMode.builder.html), [`InstanceManageMode.factory`](https://pub.dev/documentation/reactter/6.0.0/InstanceManageMode/InstanceManageMode.factory.html) and [`InstanceManageMode.singleton`](https://pub.dev/documentation/reactter/6.0.0/InstanceManageMode/InstanceManageMode.singleton.html) enums. These types represent different ways of creating and managing instances.
  - Add [`Reactter.getInstanceManageMode`](https://pub.dev/documentation/reactter/6.0.0/reactter/ReactterInstanceManager/getInstanceManageMode.html) method for getting the instance type of the instance specified.
  - Add [`Reactter.isRegistered`](https://pub.dev/documentation/reactter/6.0.0/reactter/ReactterInstanceManager/isRegistered.html) method for check if an instance is registered in Reactter.
  - Add [`Reactter.lazyBuilder`](https://pub.dev/documentation/reactter/6.0.0/reactter/ReactterInstanceManager/lazyBuilder.html), [`Reactter.lazyFactory`](https://pub.dev/documentation/reactter/6.0.0/reactter/ReactterInstanceManager/lazyFactory.html), [`Reactter.lazySingleton`](https://pub.dev/documentation/reactter/6.0.0/reactter/ReactterInstanceManager/lazySingleton.html) methods to register a builder function to create a new instance in one of the different types.
  - Add [`Reactter.builder`,](https://pub.dev/documentation/reactter/6.0.0/reactter/ReactterInstanceManager/builder.html) [`Reactter.factory`,](https://pub.dev/documentation/reactter/6.0.0/reactter/ReactterInstanceManager/factory.html) [`Reactter.singleton`](https://pub.dev/documentation/reactter/6.0.0/reactter/ReactterInstanceManager/singleton.html) methods to create a new instance in one of the different types.
  - Add [`type`](https://pub.dev/documentation/flutter_reactter/6.0.0/flutter_reactter/ReactterProvider/type.html) property to [`ReactterProvider`](https://pub.dev/documentation/flutter_reactter/6.0.0/flutter_reactter/ReactterProvider-class.html).
- **feat(hooks)**: Improve [`UseInstance`](https://pub.dev/documentation/reactter/6.0.0/reactter/UseInstance-class.html) hook.
  - Add [`UseInstance.register`](https://pub.dev/documentation/reactter/6.0.0/reactter/UseInstance/UseInstance.register.html) constructor for registering the builder function when it instantiated.
  - Add [`UseInstance.create`](https://pub.dev/documentation/reactter/6.0.0/reactter/UseInstance/UseInstance.create.html) constructor to create an instancia when it instantiated.
  - Add [`UseInstance.get`](https://pub.dev/documentation/reactter/6.0.0/reactter/UseInstance/UseInstance.get.html) constructor to create and/or get an instancia when it instantiated.
  - Add [`UseInstance.lazyBuilder`](https://pub.dev/documentation/reactter/6.0.0/reactter/UseInstance/UseInstance.lazyBuilder.html), [`UseInstance.lazyFactory`](https://pub.dev/documentation/reactter/6.0.0/reactter/UseInstance/UseInstance.lazyFactory.html), [`UseInstance.lazySingleton`](https://pub.dev/documentation/reactter/6.0.0/reactter/UseInstance/UseInstance.lazySingleton.html) factories to register a builder function to create a new instance in one of the different types when it instantiated.
  - Add [`UseInstance.builder`](https://pub.dev/documentation/reactter/6.0.0/reactter/UseInstance/UseInstance.builder.html), [`UseInstance.factory`](https://pub.dev/documentation/reactter/6.0.0/reactter/UseInstance/UseInstance.factory.html), [`UseInstance.singleton`](https://pub.dev/documentation/reactter/6.0.0/reactter/UseInstance/UseInstance.singleton.html) factories to create a new instance in one of the different types when it instantiated.

### Breakings

- **refactor(framework)**: Replace `Reactter.instanceOf`  to [`Reactter.find`](https://pub.dev/documentation/reactter/6.0.0/reactter/ReactterInstanceManager/find.html).
- **refactor(framework)**: Change builder parameter  of [`Reactter.register`](https://pub.dev/documentation/reactter/6.0.0/reactter/ReactterInstanceManager/register.html) and [`Reactter.create`](https://pub.dev/documentation/reactter/6.0.0/reactter/ReactterInstanceManager/create.html) to positional parameter.
- **refactor(hooks):** Add [`UseAsyncState.withArg`](https://pub.dev/documentation/reactter/6.0.0/reactter/UseAsyncState/withArg.html) for using [`UseAsyncState`](https://pub.dev/documentation/reactter/6.0.0/reactter/UseAsyncState-class.html) with [`Args`](https://pub.dev/documentation/reactter/6.0.0/reactter/Args-class.html).
  - Now, the [`resolve`](https://pub.dev/documentation/reactter/6.0.0/reactter/UseAsyncState/resolve.html) method of [`UseAsyncState`](https://pub.dev/documentation/reactter/6.0.0/reactter/UseAsyncState-class.html) is used without arguments. Replace with [`UseAsyncState.withArg`](https://pub.dev/documentation/reactter/6.0.0/reactter/UseAsyncState/withArg.html). Its [`resolve`](https://pub.dev/documentation/reactter/6.0.0/reactter/UseAsyncStateArgs/resolve.html) method allows to use arguments.
- **refactor(hooks, example):** Deprecate [`UseState.initial`](https://pub.dev/documentation/reactter/6.0.0/reactter/UseState/initial.html) and [`UseState.reset`](https://pub.dev/documentation/reactter/6.0.0/reactter/UseState/reset.html).
  - Avoid using it.
- **refactor(hooks):** Deprecate [`UseEvent`](https://pub.dev/documentation/reactter/6.0.0/reactter/UseEvent-class.html) hook.
  - Use event shortcuts instead.
- **refactor(hooks, test):** Deprecate [`UseContext`](https://pub.dev/documentation/reactter/6.0.0/reactter/UseContext.html) hook.
  - Use manage instances shortcuts or [`UseInstance`](https://pub.dev/documentation/reactter/6.0.0/reactter/UseInstance-class.html) instead.
- **refactor(framework)**: The [`Reactter.unregister`](https://pub.dev/documentation/reactter/6.0.0/reactter/ReactterInstanceManager/unregister.html) couldn't deregister the instance builder when the instance is active.
- **refactor(framework)**: Rename `Reactter.dispose` to [`Reactter.offAll`](https://pub.dev/documentation/reactter/6.0.0/reactter/ReactterEventManager/offAll.html).
- **refactor(types)**: Rename `ContextBuilder` to [`InstanceBuilder`](https://pub.dev/documentation/reactter/6.0.0/reactter/InstanceBuilder.html) and `InstanceBuilder` to [`InstanceContextBuilder`](https://pub.dev/documentation/reactter/6.0.0/reactter/InstanceContextBuilder.html).
- **reactor(framework)**: Rename `Reactter.lazy` to [`Reactter.lazyState`](https://pub.dev/documentation/reactter/6.0.0/reactter/ReactterStateShortcuts/lazyState.html).

### Internal

- **refactor(framework, hooks, test)**: Improve code structure and how to attach an instance to states using `ReactterZone` and  structure code of `ReactterState`.
- **refactor(example)**: Improve examples using the new features.
- **test(framework, widgets, hooks)**: Add some tests about `ReactterInstanceManager`, `ReactterInstance`, `UseInstance`
- **test(framework):** Improve tests.
- **test(framework):** Add `Reactter.destroy` test.
- **test(memo):** Add `Memo` and `MemoInterceptor` test.
- **test(args):** Add `Args` test.
- **test(hooks):** Add `UseAsyncState.withArg` test.
- **test(hooks):** Add `UseInstance` test.
- **fix(test)**: Fix grammar of test description.

## 5.1.2

### Fixes

- **refactor(hooks):** Add const to `ReactterAction` and `ReactterActionCallable`.

### Internal

- **doc:** Change ROADMAP.
- **refactor(example):** Improve code and fix some issues.
- **refactor(example):** Remove `const` keyword for zapp compatibility.

## 5.1.1

### Fixes

- **fix(hooks):** Don't attach instance when `UseEffect` doesn't have `context`.

## 5.1.0

### Enhancements

- **feat(framework):** Implement hook register.
  - Add hook register logic for attaching `ReactterState` defined into `ReactterHook`.
  - Refactor hooks to implement hook register.
- **feat(framework):** Add `lazy` method and make `isInstanceBuilding` variable as public.
- **feat(extensions):** Add `ReactterStateListExtension` with `when` method.
- **feat(hooks):** Add `UseCompute` hook.
- **feat(widget, test):** Add `ReactterConsumer` widget.

### Internal

- **build(example):** Use `reactter_lint`.
- **build(widgets):** Remove unnecesary import.
- **doc:** Fix `ReactterInstanceNotFoundException` documentation.
- **refactor(framework):** Export `ReactterInstance`.
- **doc(example):** Add and remove some concepts from main.
- **refactor(example):** Remove late keyword form some hooks.
- **refactor(example):** Implement play and stop animation.
- **refactor(framework):** Rename `_RegisterHook` to `HookRegister`.
- **test:** Add `ReactterStateListExtension` test and other adjustments.
- **refactor(widgets):** Make `ReactterConsumer.builder` required.
- **fix(framework):** Add instance attached validation before `UseCompute` is disponsed.
- **refactor(extensions):** Use `UseCompute` type on `when` method.
- **test:** Add `UseCompute` test and other adjustments.
- **build(example):** Change folder structure.
- **build:** Change folder structure for `flutter_reactter` package.
  - Move all files to `src`.
  - Rename `ReactterTypes` to `types`.
  - `engine` was separated into `extensions`, `framework` and `types`.
  - Change folder structure of `test`.
- **build:** Change folder structure for `reactter` package.
  - Move all files to `src`.
  - Rename `ReactterTypes` to `types`.
  - `core` was separated into `framework`, `objs`, `signals`, `lifecycle`, `types`.
  - Change folder structure of `test`.
- **refactor(core, widgets):** Implement Reactter event to Signal generic.
  - Remove `ReactterSignalProxy`.
  - Move `Obj`, `Signal` to other folder.
  - Refactor `ReactterWatcher` to the new changes.
- **refactor(core):** Remove `ReactterNotifyManager`.
  - `ReactterNotifyManager` is no longer used, all its methods were moved to `ReactterState`.
  - `Lifecycle` enum was move to new file(`lifecycle.dart`).

## 5.0.1

### Internal

- **fix(test)**: Change dependencies for test coverage.
- **fix(test)**: Fix some info about code validator.

## 5.0.0

### Breakings

- **refactor(engine, widgets, core, hooks, test)**: Delete `ReactterContext` and `ReactterHookManager` and remove all about it.
- **refactor(widgets, test)**: Replace `ReactterContextNotFoundException` to `ReactterInstanceNotFoundException`.
- **refactor(widgets, test)**: Remove `listenAllHooks` property from `ReactterComponent`, use `listenAll`.
- **refactor(widgets, test)**: Remove `listenHooks` property from `ReactterComponent` and `ReactterProvider.contextOf`, use `listenStates`.
- **refactor(hooks, test)**: Remove `context` property from `UseAsyncState`, `UseContext`, `UseEvent`, `UseReducer` and `UseState`.
- **refactor(hooks, test)**: Remove type `ReactterAction`, `type` is String.
- **refactor(core, widgets, test)**: Delete `ReactterBuilder` and `ReactterScope`, replace to `build`, `StatelessWidget`, `StatefulWidget` or any Widget that expose `BuildContext`.

### Enhancements

- **feat(core)**: Add [`attachTo`](https://pub.dev/documentation/reactter/5.0.0/core/ReactterState/attachTo.html), [`detachTo`](https://pub.dev/documentation/reactter/5.0.0/core/ReactterState/detachTo.html) and [`createState`](https://pub.dev/documentation/reactter/5.0.0/core/ReactterState/createState.html) methods to `ReactterState`.

### Fixes

- **refactor(core)**: Fix `hasListener` no depend of `ReactterNotifyManager`.

### Internal

- **refactor, doc(example)**: Adjust to new changes.
- **doc**: Change documentation to better readability and adjut to new changes.

## 4.1.2

### Internal

- **build**: Move `examples` folder  to `packages/flutter_reactter/example`.

## 4.1.1

### Fixes

- **fix(core)**: Fix predispose all hook states.

### Internal

- **refactor(example)**: Minor changes in some examples.
- **refactor(example)**: Improve code and design of tree example.
- **refactor(example)**: Improve code of calculator example.
- **refactor(example)**: Improve code of animation example.
- **doc**: Add link to examples using zapp

## 4.1.0

### Enhancements

- **perf(core)**: Improve performance for changing states.
- **perf(engine)**: Improve management for context dependencies.

### Fixes

- **fix(core)**: Remove the callbacks of one events when the instance will be disposed.

### Internal

- **refactor(example)**: Improve examples and fix some bugs.
- **doc**: Fix documentation.

## 4.0.0

### Enhancements

- **feat(core)**: Add [`Obj`](https://pub.dev/documentation/reactter/4.0.0/core/Obj-class.html).
- **feat(core)**: Add [`Signal`](https://pub.dev/documentation/reactter/4.0.0/core/Obj-class.html).
- **feat(core)**: Add [`ReactterSignalProxy`](https://pub.dev/documentation/reactter/4.0.0/core/ReactterSignalProxy-mixin.html) mixin.
- **feat(core)**: Add [`ReactterNotifyManager`](https://pub.dev/documentation/reactter/4.0.0/core/ReactterNotifyManager-mixin.html) mixin.
- **feat(core)**: Add [`ReactterState`](https://pub.dev/documentation/reactter/4.0.0/core/ReactterState-mixin.html) mixin.
- **refactor(core,hooks)**: Manage event separate from `UseEvent` hook.
- **perf(core)**: Improve to manage instances.
- **perf(core)**: Improve to manage state.
- **perf(widgets,core)**: Improve performance on `ReactterProvider`.
Now there is no need to use `ReactterComponent` or `ReactterBuilder`. The instance can be accessed directly from the context(`BuildContext`) and just the part belonging to the context is re-built.
- **feat(widgets)**: Add [`ReactterWatcher`](https://pub.dev/documentation/reactter_flutter/4.0.0/widgets/ReactterWatcher-class.html).
You can use the `Signal` variable in `ReactterWatcher` and react when it changed for `ReactterWatcher`'s widgets rebuild.

### Breakings

- **refactor(core)**: Remove `typedef` innecesary.
- **refactor(hooks)**: Fix dispose of `UseContext` and `UseEffect`.
- **build(widgets)**: Mark `ReactterScope` as deprecated. Use any Widget that exposes the `BuildContext` like `Build`, `StatelessWidget` or `StatefulWidget` instead.
- **build(widgets)**: Mark `listenHooks` and `listenAllHooks` as deprecated. Use `listenStates` and `listenAll` instead.
- **refactor(widgets)**: Remove `onInit` from `ReactteProvider` and `ReactterComponent`.
- **refactor(widget)**: Add `ReactterContext` argument in `builder` of `ReactterProvider`.

### Fixes

- **fix(core)**: Don't allow increasing listeners count, if event don't exist.
- **fix(widgets)**: Clear previous signals saved.
- **fix(core)**: Remove one callback using off method and was changed how to storage event.

### Internal

- **test**: Refactor test and add event manager test.
- **refactor(test)**: Fix test and add new tests.
- **build(engine)**: Rename some files.
- **refactor(test)**: Fix test and add `ReactterWatcher` test.
- **refactor(examples)**: Improve examples code and add calculator example.
- **doc**: Fix documentation and add new documentation.
- **test(core,hooks)**: Fix dispose on some tests.
- **refactor(examples)**: Do counter more simple.

## 3.2.1-dev.2

### Enhancements

- **refactor(engine)**: Use `ReactterScopeInheritedElement` as mixin on `ReactterProviderInheritedElement`.
- **perf(widget)**: Improve `ReactterBuilder` performance.

## 3.2.0

### Enhancements

- **feat(hooks)**: Add [`UseReducer`](https://pub.dev/documentation/reactter/3.2.0/hooks/UseReducer-class.html) hook.

### Breakings

- **refactor(core)**: Replace `ReactterInstanceManager` extension to class.

### Fixes

- **refactor(hooks)**: Move events storage variable.

### Internal

- **refactor(examples)**: Improve examples code.
- **docs**: Update roadmap.
- **docs**: Fix some typos and improve documentation.

## 3.1.2

### Fixes

- **fix(core)**: Add ref on `Reactter.create`.

### Internal

- **docs**: Fix some documentation.

## 3.1.1

### Fixes

- **fix(widgets)**: Fix `child` and `builder` of `ReactterProvider` is not required when use `ReactterProviders`.

## 3.1.0

### Breakings

- **refactor(core)**: Remove selector aspect from `ReactterProvider.of`.

### Fixes

- **fix(core)**:  Fix `ReactterInstanceManager`'s get method create instance when instance didn't create yet.
- **refactor(engine, widgets)**: Add validations about `child` and `builder` properties.

### Enhancements

- **refactor(core)**: Change `Reactter.delete` named argument to positional argument.

### Internal

- **docs**: Fix README documentation.
- **refactor(tests)**: Add test coverage of 100%.

## 3.0.0

### Breakings

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

- **fix**: format reactter.dart and remove an unnecessary dart file

## 2.3.1

### Internal

- **fix(example)**: Fix typo on counter example button.
- **fix(example)**: Add implement tags on animation example.

## 2.3.0

### Breakings

- **refactor**: Rename `context.of` to `context.watch`.
- **refactor**: Rename `context.ofId` to `context.watchId`.
- **refactor**: Rename `context.ofStatic` to `context.read`.
- **refactor**: Rename `context.ofIdStatic` to `context.readId`.
- **refactor**: Move subscribe and publish pattern to `ReactterSubscribersManager` class. Can use subscribe and publish pattern with enum type specified.
- **refactor(widgets)**: Use `ReactterInheritedProvider` as scope on `ReactterBuilder`.
- **refactor(widgets)**: Add `ReactterBuilder` as scope when didn't has builder on `ReactterComponent`.
- **refactor(core)**: `HookManager` subscribe to `willUpdate` and `didUpdate` event.
- **refactor(core)**: `WillUpdate` and `DidUpdate` event trigger when its `ReactterHook` update.
- **refactor(engine)**: Manage dependencies of `ReactterPubSub` and `lifecycle` of `ReactterContext`.
- **refactor(widget)**: Performance as the instance of `context` is listened to mark need build.
- **refactor(hooks, widgets)** - Rename `UseProvide` to `ReactterProvider`.

### Fixes

- **fix(hooks,widgets)**: Delete instances of `UseContext` when dispatch updated event on `ReactterProvider`, to prevent has instances duplicated.
- **refactor(widget)**: Fix `ReactterBuilder`.

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
- **refactor(core)**: Remove unnecessary event listeners from `ReactterContext`.
- **refactor(core,hooks)**: Remove unnecessary code.
- **refactor(engine)**: Remove props unnecessary on `ReactterInheritedProvider`.
- **refactor(hooks)**: Clear code and do code simple on `UseAsyncState`.
- **refactor(core)**: Improve performance how instances manager on `ReactterFactory`.
- **refactor(core)**: Improve `UseEffect`. Now the return of callback execute when a hook was change or `willUnmount` event was invoke.
- **refactor(core)**: Improve `lifecycle` events. Now it uses as subscription.

### Internal

- **docs**: Fix some documentation.
- **feat(example)**: Add more example with animation.
- **feat(example)**: Add new examples.
- **docs**: Add badgets, reorder topic, fix examples and improve redaction on README.
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
