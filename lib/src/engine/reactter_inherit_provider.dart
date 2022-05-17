// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/widgets.dart';
import 'reactter_inherit_provider_scope.dart';
import 'reactter_inherit_provider_scope_element.dart';

abstract class ReactterInheritedProvider extends StatelessWidget {
  /// Provides a widget witch render one time.
  ///
  /// It's expose on [builder] method as second parameter.
  final Widget? child;

  /// Method which has the render logic
  ///
  /// Exposes [BuilderContext] and [child] widget as parameters.
  /// and returns a widget.
  final TransitionBuilder? builder;

  const ReactterInheritedProvider({
    Key? key,
    this.child,
    this.builder,
  }) : super(key: key);

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
              builder: (context) {
                final inheritedElement =
                    context.getElementForInheritedWidgetOfExactType<
                            ReactterInheritedProviderScope>()
                        as ReactterInheritedProviderScopeElement;

                inheritedElement.removeDependencies();

                return builder!(context, child);
              },
            )
          : child!,
    );
  }

  void willMount();

  void didMount();

  void willUnmount();
}
