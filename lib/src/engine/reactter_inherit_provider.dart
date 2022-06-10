import 'package:flutter/widgets.dart';
import 'reactter_inherit_provider_scope.dart';
import 'reactter_inherit_provider_scope_element.dart';

abstract class ReactterInheritedProvider extends StatelessWidget {
  final Widget? _child;
  final TransitionBuilder? _builder;

  /// Provides a widget witch render one time.
  ///
  /// It's expose on [builder] method as second parameter.
  Widget? get child => _child;

  /// Method which has the render logic
  ///
  /// Exposes [BuilderContext] and [child] widget as parameters.
  /// and returns a widget.
  TransitionBuilder? get builder => _builder;

  const ReactterInheritedProvider({
    Key? key,
    Widget? child,
    TransitionBuilder? builder,
  })  : _child = child,
        _builder = builder,
        super(key: key);

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

  void willMount() {}

  void didMount() {}

  void willUnmount() {}

  void willUpdate() {}
}
