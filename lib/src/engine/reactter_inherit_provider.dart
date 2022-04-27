import 'package:flutter/material.dart';
import 'reactter_inherit_provider_scope.dart';
import '../core/reactter_types.dart';

/// Wrapper a [ReactterInheritedProviderScope].
///
/// Need for communicate and search parents and childs.
class ReactterInheritedProvider extends StatelessWidget {
  final Widget? child;

  const ReactterInheritedProvider({
    Key? key,
    this.builder,
    this.child,
  }) : super(key: key);

  final BuildWithChild? builder;

  @override
  Widget build(BuildContext context) {
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
