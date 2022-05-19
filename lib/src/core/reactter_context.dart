import 'mixins/reactter_life_cycle.dart';
import 'mixins/reactter_publish_suscription.dart';
import 'reactter_hook_manager.dart';

/// Provides the functionlatiy of [ReactterHookManager] and [ReactterLifeCycle] to any class.
///
/// It's recommended to name you class with `Context` suffix to improve readability:
///
///```dart
/// class AppContext extends ReactterContext {
///   late final name = UseState<String>('Leo León', this);
/// }
/// ```
///
/// To use it, you should provide it within [ReactterProvider] with an [UseContext],
/// you can access to the property values with [ReactterBuildContextExtension].
///
/// This example contain a [ReactterProvider] with an [UseContext]
/// of type [AppContext], and read all the states in builder:
///
/// ```dart
/// ReactterProvider(
///  contexts: [
///    UseContext(
///      () => AppContext()
///    )
///  ],
///  builder: (context) {
///     appContext = context.of<AppContext>();
///
///     return Text(appContext.name.value);
///   }
/// )
/// ```
abstract class ReactterContext extends ReactterHookManager
    with ReactterLifeCycle {
  ReactterContext() {
    onDidMount(_onDidMount);
  }

  _onDidMount() {
    subscribe(PubSubEvent.willUpdate, _onWillUpdate);
    subscribe(PubSubEvent.didUpdate, _onDidUpdate);
  }

  _onWillUpdate() => executeEvent(LifeCycleEvent.willUpdate);

  _onDidUpdate() => executeEvent(LifeCycleEvent.didUpdate);
}
