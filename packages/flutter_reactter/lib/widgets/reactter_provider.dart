// ignore_for_file: prefer_void_to_null

part of '../widgets.dart';

abstract class ReactterProviderAbstraction<T extends ReactterContext>
    extends StatelessWidget implements ReactterScopeWidget {
  const ReactterProviderAbstraction({Key? key}) : super(key: key);

  @override
  ReactterProviderElement createElement() {
    return ReactterProviderElement(this);
  }
}

class ReactterProvider<T extends ReactterContext>
    extends ReactterProviderAbstraction {
  /// Create a instances of [ReactterContext] class
  @protected
  final ContextBuilder<T> _instanceBuilder;

  /// Id usted to identify the context
  final String? _id;

  /// Provides a widget witch render one time.
  ///
  /// It's expose on [builder] method as second parameter.
  final Widget? _child;

  /// Method which has the render logic
  ///
  /// Exposes [BuilderContext] and [child] widget as parameters.
  /// and returns a widget.
  final TransitionBuilder? _builder;

  /// Create the instance defined
  /// on firts parameter [_instanceBuilder] when [UseContext] is called.
  @protected
  final bool _init;

  /// Invoked when instance defined
  /// on firts parameter [_instanceBuilder] is created
  @protected
  final OnInitContext<T>? _onInit;

  const ReactterProvider(
    this._instanceBuilder, {
    Key? key,
    String? id,
    bool init = false,
    OnInitContext<T>? onInit,
    Widget? child,
    TransitionBuilder? builder,
  })  : _id = id,
        _init = init,
        _onInit = onInit,
        _child = child,
        _builder = builder,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildWithChild(context, _child);
  }

  @override
  ReactterProviderElement createElement() {
    return ReactterProviderElement(this);
  }

  @override
  void debugFillProperties(properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('id', _id, showName: true))
      ..add(
        FlagProperty(
          'init',
          value: _init,
          ifTrue: 'true',
          ifFalse: 'false',
          showName: true,
        ),
      );
    properties.defaultDiagnosticsTreeStyle = DiagnosticsTreeStyle.shallow;
  }

  /// A [build] method that receives an extra `child` parameter.
  ///
  /// This method may be called with a `child` different from the parameter
  /// passed to the constructor of [SingleChildStatelessWidget].
  /// It may also be called again with a different `child`, without this widget
  /// being recreated.
  Widget _buildWithChild(BuildContext context, Widget? child,
      [WidgetBuilder? afterBuild]) {
    return ReactterProvider._buildScope<T>(
      id: _id,
      owner: this,
      child: Builder(
        builder: (context) {
          final injectedChild = child ?? afterBuild?.call(context);

          return _builder?.call(context, injectedChild) ?? injectedChild!;
        },
      ),
    );
  }

  static Widget _buildScope<T extends ReactterContext?>({
    required ReactterProvider owner,
    required Widget child,
    String? id,
  }) {
    if (id != null) {
      return ReactterScopeInherited<T, String>(owner: owner, child: child);
    }
    return ReactterScopeInherited<T, Null>(owner: owner, child: child);
  }

  bool _existsInstance() => Reactter.factory.existsInstance<T>(_id);

  T? _createInstance(Object ref) {
    Reactter.factory.register<T>(_instanceBuilder, _id);

    final instance = Reactter.factory.getInstance<T>(_id, ref);

    if (instance != null) {
      _onInit?.call(instance);
    }

    return instance;
  }

  void _deleteInstance(Object ref) {
    Reactter.factory.deletedInstance<T>(_id, ref);
  }

  /// Returns a [instance] of [T]
  /// and puts contexts listen to when it should be re-rendered
  static T contextOf<T extends ReactterContext?>(
    BuildContext context, {
    String? id,
    ListenHooks<T>? listenHooks,
    SelectorAspect<T>? aspect,
    bool listen = true,
  }) {
    final inheritedElement = _getScopeInheritedElement<T>(
      context,
      id: id,
      aspect: aspect,
    );

    if (inheritedElement?._instance == null && null is! T) {
      throw ReactterContextNotFoundException(T, context.widget.runtimeType);
    }

    final instance = inheritedElement?._instance as T;

    if (!listen || instance == null) {
      return instance;
    }

    context.dependOnInheritedElement(
      inheritedElement!,
      aspect: aspect ?? () => {},
    );

    if (listenHooks != null) {
      final hooks = listenHooks(instance);

      inheritedElement.dependOnHooks(hooks);

      return instance;
    }

    inheritedElement.dependOnInstance(instance);

    return instance;
  }

  static ReactterScopeInheritedElement?
      _getScopeInheritedElement<T extends ReactterContext?>(
    BuildContext context, {
    String? id,
    SelectorAspect<T>? aspect,
  }) {
    if (id != null) {
      // O(2)
      final inheritedElementNotSure =
          context.getElementForInheritedWidgetOfExactType<
                  ReactterScopeInherited<T, String>>()
              as ReactterScopeInheritedElement<T, String>?;

      return inheritedElementNotSure?.getScopeInheritedElementOfExactId(id);
    }

    // O(1)
    return context.getElementForInheritedWidgetOfExactType<
            ReactterScopeInherited<T, Null>>()
        as ReactterScopeInheritedElement<T, Null>?;
  }
}

class ReactterProviderElement extends StatelessElement
    with ReactterScopeElementMixin {
  /// Creates an element that uses the given widget as its configuration.
  ReactterProviderElement(ReactterProviderAbstraction widget) : super(widget);

  @override
  ReactterProvider get widget => super.widget as ReactterProvider;

  @override
  Widget build() {
    if (parent != null) {
      Widget afterBuild(context) {
        final providerParent = parent?.widget.owner.widget;

        return providerParent?.build.call(context) ?? const SizedBox.shrink();
      }

      return widget._buildWithChild(
        this,
        parent?.injectedChild,
        afterBuild,
      );
    }

    return super.build();
  }
}

extension ReactterElementExtension on Element {}
