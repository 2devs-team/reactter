part of '../hooks.dart';

/// A [ReactterHook] that allows to get the [T] instance with/without [id]
/// from dependency store when it's ready.
///
/// ```dart
/// final useAppController = UseContext<AppController>();
/// final useOtherControllerWithId = UseContext<OtherController>('uniqueId');
/// ```
///
/// The [T] instance that you need to get, to must be created by [ReactterInstanceManager]:
///
/// ```dart
/// Reactter.create<AppController>(() => AppContex());
/// ```
///
/// or created by [ReactterProvider] of [`flutter_reactter`](https://pub.dev/packages/flutter_reactter)
///
/// Use [instance] getter to get the [T] instance:
///
/// ```dart
/// final useAppController = UseContext<AppController>();
/// print(useAppController.instance);
/// ```
/// > **NOTE:**
/// > [instance] returns null, when the [T] instance is not found
/// or it hasn't created yet.
///
/// Use [UseEffect] hook to wait for the [instance] to be created.
///
/// ```dart
/// final useAppController = UseContext<AppController>();
/// print(useAppController.instance); // return null
///
/// UseEffect(() {
///   print(useAppController.instance); // return instance of AppController
/// }, [useAppController]);
/// ```
///
/// > **IMPORTANT**
/// > You should call [dispose] when it's no longer needed.
///
/// See also:
///
/// * [ReactterInstanceManager], a instances manager.
/// * [UseEffect], a side-effect manager.
@Deprecated(
  'Use manage instances shortcuts or `UseInstance` instead. '
  'This feature was deprecated after v6.0.0.pre.',
)
typedef UseContext<T extends Object> = UseInstance<T>;
