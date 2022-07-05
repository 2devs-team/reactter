part of '../core.dart';

/// A context that contains any logic and allowed react
/// when any change the [ReactterHook].
///
/// **RECOMMENDED:**
/// Name class with `Context` suffix, for easy locatily:
///
/// ```dart
/// class AppContext extends ReactterContext {}
/// ```
///
/// For access to instance anywhere, you need to register the instance
/// using [ReactterFactory]:
///
/// ```dart
/// Reactter.factory.register<AppContext>(
///   () => AppContex(),
/// );
///
/// // or
/// final appContext = Reactter.factory.createInstance<AppContext>(
///   () => AppContex(),
/// );
/// ```
///
/// And later you can get the instance:
///
/// ```dart
/// final appContext = Reactter.factory.getInstance<AppContext>();
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
/// - [ReactterFactory], a instances manager
/// - [UseContext], a hook that allowed access to instance of [ReactterContext].
abstract class ReactterContext extends ReactterHookManager {
  /// This methods is called for [ReactterFactory]
  /// when the instance will be destroyed.
  dispose() {}
}
