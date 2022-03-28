library reactter;

import 'package:reactter/engine/mixins/reactter_publish_suscription.dart';

abstract class ReactterHookAbstract with ReactterPubSub {}

class ReactterHook extends ReactterHookAbstract {
  final Set<ReactterHookAbstract> _hooks = {};

  void listenHooks(List<ReactterHookAbstract> hooks) {
    for (final _hook in hooks) {
      if (_hooks.contains(_hook)) {
        return;
      }

      _hooks.add(_hook);

      _hook.subscribe(publish);
    }
  }
}
