library reactter;

import '../hooks/reactter_hook.dart';

/// Inyects the [callback] in the [UseState] [dependencies] given to execute when any of
/// those changes.
///
/// ```
/// This example produces a [UseEffect], it must be called on [ReactterContext]
/// constructor:
///
/// ```dart
/// AppContext() {
///   UseEffect(() {
///     userName.value = firstName + lastName;
///   }, [firstName, lastName]);
/// }
/// ```
/// You can create your own hook with mixins:
///
///```dart
/// mixin UseCart on ReactterHook {
///     late final cart = UseState<Cart?>(null, context: this);
/// }
/// ```

/// This gonna expose `cart` to any [ReactterContext]
///```dart
/// UserContext extends ReactterContext with UseCart {
///
///   List<Product>? getCart(){
///     return cart?.value.productList;
///   }
/// }
/// ```
///
/// Any class can be a hook, but we recommend do it with mixins due the injection
/// of the props in the class.
class UseEffect extends ReactterHook {
  UseEffect(
    void Function() callback,
    List<ReactterHookAbstract> dependencies, [
    ReactterHook? context,
  ]) {
    subscribe(callback);
    listenHooks(dependencies);
    context?.listenHooks([this]);
  }
}
