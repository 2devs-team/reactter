import 'package:flutter/material.dart';
import 'package:reactter/src/core/reactter_types.dart';

import '../../reactter.dart';

abstract class ReactterComponent<T extends ReactterContext>
    extends StatelessWidget {
  const ReactterComponent({Key? key}) : super(key: key);

  @protected
  String? get id => null;

  InstanceBuilder<T>? get builder => null;

  @protected
  List<UseState> listen(T ctx);

  T _getContext(BuildContext context) {
    return id == null ? context.of<T>(listen) : context.ofId<T>(id!, listen);
  }

  @protected
  @override
  Widget build(BuildContext context) {
    if (builder == null) {
      return render(_getContext(context));
    }

    return UseProvider(
      contexts: [
        UseContext<T>(builder!),
      ],
      builder: (context, _) {
        return render(_getContext(context));
      },
    );
  }

  @protected
  Widget render(T ctx);
}
