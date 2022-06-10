import 'reactter_life_cycle.dart';
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
    with ReactterLifeCycle {}
