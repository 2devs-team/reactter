import 'package:flutter/widgets.dart';
import 'reactter_inherit_provider_scope.dart';
import '../core/reactter_types.dart';
import '../engine/reactter_inherit_provider_scope_element.dart';

/// Wrapper a [ReactterInheritedProviderScope].
///
/// Need for communicate and search parents and childs.
abstract class ReactterInheritedProvider extends StatelessWidget {
  /// Provides a widget witch render one time.
  ///
  /// It's expose on [builder] method as second parameter.
  final Widget? child;

  /// Method which has the render logic
  ///
  /// Exposes [BuilderContext] and [child] widget as parameters.
  /// and returns a widget.
  final BuildWithChild? builder;

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
                final _inheritedElement =
                    context.getElementForInheritedWidgetOfExactType<
                            ReactterInheritedProviderScope>()
                        as ReactterInheritedProviderScopeElement;

                _inheritedElement.removeDependencies();

                return builder!(context, child);
              },
            )
          : child!,
    );
  }

  willMount();

  didMount();

  willUnmount();
}
