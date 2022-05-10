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
    bool _isMounted = false;

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

                if (_isMounted) {
                  willUpdate();
                }

                final _widget = builder!(context, child);

                if (_isMounted) {
                  didUpdate();
                }

                _isMounted = true;

                return _widget;
              },
            )
          : child!,
    );
  }

  willMount();

  didMount();

  willUpdate();

  didUpdate();

  willUnmount();
}
