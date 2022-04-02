import 'package:flutter/material.dart';

import '../../reactter.dart';

abstract class ReactterComponent<T extends ReactterContext>
    extends StatelessWidget {
  const ReactterComponent({Key? key}) : super(key: key);

  List<UseState> listen(T ctx) {
    return [];
  }

  @protected
  @override
  Widget build(BuildContext context) {
    final ctx = context.of<T>(listen);

    return render(ctx);
  }

  Widget render(T ctx) {
    return const SizedBox();
  }
}
