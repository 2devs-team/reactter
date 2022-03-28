library reactter;

import 'package:reactter/hooks/reactter_hook.dart';

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
