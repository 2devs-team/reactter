library reactter;

import '../engine/mixins/reactter_publish_suscription.dart';
import '../engine/mixins/reactter_life_cycle.dart';
import '../core/reactter_types.dart';

abstract class ReactterHookAbstract with ReactterPubSub {}

/// Provide the functionlatiy of a hook to a mixin or class.
///
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
class ReactterHook extends ReactterHookAbstract with ReactterLifeCycle {
  /// Saves all the hooks given before.
  final Set<ReactterHookAbstract> _hooks = {};

  UseEffectCallback? _useEffectCallback;

  void Function()? _returnUseEffectCallback;

  /// Suscribe to all [hooks] given.
  void listenHooks(List<ReactterHookAbstract> hooks,
      [void Function()? Function()? _callback]) {
    _useEffectCallback = _callback;

    for (final _hook in hooks) {
      if (_hooks.contains(_hook)) {
        return;
      }

      _hooks.add(_hook);

      _hook.subscribe(publish);
    }
  }

  @override
  awake() {
    _returnUseEffectCallback = _useEffectCallback?.call();
  }

  @override
  willUnmount() {
    _returnUseEffectCallback?.call();
  }
}
