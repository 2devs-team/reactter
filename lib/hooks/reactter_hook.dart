library reactter;

import 'package:reactter/engine/mixins/reactter_publish_suscription.dart';

class ReactterHook with ReactterPubSub {}

class ReactterHookGestor extends ReactterHook {
  final Set<ReactterHook> _hooks = {};

  void listenHooks(List<ReactterHook> hooks) {
    for (final _hook in hooks) {
      if (_hooks.contains(_hook)) {
        return;
      }

      _hooks.add(_hook);

      _hook.subscribe(publish);
    }
  }
}
