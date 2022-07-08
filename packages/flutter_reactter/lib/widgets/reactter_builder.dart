part of '../widgets.dart';

class ReactterBuilder<T extends ReactterContext?> extends StatelessWidget {
  /// Provides a widget witch render one time.
  ///
  /// It's expose on [builder] method as second parameter.
  final Widget? _child;

  /// Method which has the render logic
  ///
  /// Exposes [BuilderContext] and [child] widget as parameters.
  /// and returns a widget.
  final InstanceBuilder<T>? _builder;

  /// Id of [T].
  final String? _id;

  /// Watchs specific hooks to re-render
  final ListenHooks<T>? _listenHooks;

  const ReactterBuilder({
    Key? key,
    String? id,
    ListenHooks<T>? listenHooks,
    Widget? child,
    InstanceBuilder<T>? builder,
  })  : _id = id,
        _listenHooks = listenHooks,
        _child = child,
        _builder = builder,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final inheritedElement =
        ReactterProvider._getScopeInheritedElement<T>(context, id: _id)!;

    return ReactterProvider._buildScope<T>(
      id: _id,
      owner: inheritedElement.widget.owner,
      child: Builder(
        builder: (context) {
          ReactterProvider.contextOf<T>(
            context,
            id: _id,
            listenHooks: _listenHooks,
          );

          return _builder?.call(
                inheritedElement._instance as T,
                context,
                _child,
              ) ??
              _child!;
        },
      ),
    );
  }

  @override
  void debugFillProperties(properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('id', _id, showName: true));
    properties.defaultDiagnosticsTreeStyle = DiagnosticsTreeStyle.shallow;
  }
}
