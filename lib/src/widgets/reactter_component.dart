import 'package:flutter/widgets.dart';
import '../core/reactter_context.dart';
import '../core/reactter_hook.dart';
import '../core/reactter_types.dart';
import '../hooks/reactter_use_context.dart';
import 'reactter_provider.dart';

/// Provides the functionality of [ReactterProvider] with a [UseContext] of [T],
/// and exposes the instance of [T] through [render] method.
abstract class ReactterComponent<T extends ReactterContext>
    extends StatelessWidget {
  const ReactterComponent({Key? key}) : super(key: key);

  /// Id of [T].
  @protected
  String? get id => null;

  /// How to builder the instance of [T].
  @protected
  InstanceBuilder<T>? get builder => null;

  /// Listen hooks to mark need to build.
  @protected
  List<ReactterHook> listenHooks(T ctx);

  /// Replace a build method. Provides the instances of [T] and context of [BuildContext].
  @protected
  Widget render(T ctx, BuildContext context);

  @protected
  @override
  Widget build(BuildContext context) {
    if (builder == null) {
      return render(_getContext(context), context);
    }

    return ReactterProvider(
      contexts: [
        UseContext<T>(builder!),
      ],
      builder: (context, _) => render(_getContext(context), context),
    );
  }

  T _getContext(BuildContext context) {
    return id == null
        ? context.of<T>(listenHooks)
        : context.ofId<T>(id!, listenHooks);
  }
}
