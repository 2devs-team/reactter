part of '../core.dart';

/// A context that allows to manages the [ReactterHook]s
/// and provides [LifeCycle] events.
///
/// **RECOMMENDED:**
/// Name class with `Context` suffix, for easy locatily:
///
/// ```dart
/// class AppContext extends ReactterContext {}
/// ```
///
/// For access to instance anywhere, you need to register the instance
/// using [ReactterInstanceManager]:
///
/// ```dart
/// Reactter.register<AppContext>(
///   () => AppContex(),
/// );
///
/// // or
/// final appContext = Reactter.create<AppContext>(
///   () => AppContex(),
/// );
/// ```
///
/// And later you can get the instance:
///
/// ```dart
/// final appContext = Reactter.get<AppContext>();
/// ```
///
/// or using [UseContext] hook:
///
/// ```dart
/// final appContext = UseContext<AppContext>().instance;
/// ```
///
/// If you use flutter, add [`flutter_reactter`](https://pub.dev/packages/flutter_reactter)
/// package on your dependencies and use its Widgets.
///
/// See also:
/// - [ReactterHook], a abstract hook that [ReactterContext] listen it.
/// - [ReactterInstanceManager], a instances manager
/// - [UseContext], a hook that allowed access to instance of [ReactterContext].
abstract class ReactterContext extends ReactterHookManager {
  /// This methods is called for [ReactterInstanceManager]
  /// when the instance will be destroyed.
  dispose() {}
}
