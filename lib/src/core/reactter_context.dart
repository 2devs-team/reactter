import 'mixins/reactter_life_cycle.dart';
import 'reactter_hook_manager.dart';

/// Provide the functionlatiy of [ReactterHookManager] and [ReactterLifeCycle] to any class.
///
/// It's recommended to name you class with `Context` suffix to improve readability.
///
///```dart
/// class AppContext extends ReactterContext {
///   late final name = UseState<String>('Leo León', context: this);
/// }
/// ```
///
/// To use it, you should provide it within [UseProvider] and [UseContext],
/// you can access to the prop values with [ReactterBuildContextExtension].
///
/// This example contain a [UseProvider] with an [UseContext]
/// of type [AppContext], and read all the states in builder:
///
/// ```dart
/// UseProvider(
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
class ReactterContext extends ReactterHookManager with ReactterLifeCycle {}
