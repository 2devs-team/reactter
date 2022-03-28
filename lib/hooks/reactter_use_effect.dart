library reactter;

import 'package:reactter/hooks/reactter_hook.dart';

class UseEffect extends ReactterHookGestor {
  UseEffect(
    void Function() callback,
    List<ReactterHook> dependencies, [
    ReactterHookGestor? context,
  ]) {
    subscribe(callback);
    listenHooks(dependencies);
    context?.listenHooks([this]);
  }
}
