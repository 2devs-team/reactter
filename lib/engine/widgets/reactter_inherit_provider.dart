import 'package:flutter/material.dart';
import 'package:provider/single_child_widget.dart';
import 'package:reactter/core/reactter_types.dart';
import 'package:reactter/engine/widgets/reactter_inherit_provider_scope.dart';

class ReactterInheritedProvider extends SingleChildStatelessWidget {
  const ReactterInheritedProvider({
    Key? key,
    this.builder,
    Widget? child,
  }) : super(key: key);

  final BuildWithChild? builder;

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    assert(
      builder != null || child != null,
      '$runtimeType must used builder and/or child',
    );

    return ReactterInheritedProviderScope(
      owner: this,
      child: builder != null
          ? Builder(
              builder: (context) => builder!(context, child),
            )
          : child!,
    );
  }
}
