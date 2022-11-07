// ignore_for_file: prefer_void_to_null, invalid_use_of_protected_member

part of '../widgets.dart';

/// An abstract class that extends [InheritedWidget] and implements
/// [ReactterWrapperWidget].
abstract class ReactterProviderAbstraction<T extends ReactterContext>
    extends InheritedWidget implements ReactterWrapperWidget {
  const ReactterProviderAbstraction({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  ReactterProviderElement createElement();
}

/// A [StatelessWidget] that provides a [ReactterContext]'s instance of [T]
/// to widget tree that can be access through the [BuildContext].
///
///```dart
/// ReactterProvider<AppContext>(
///   () => AppContext(),
///   builder: (appContext, context, child) {
///     return Text("StateA: ${appContext.stateA.value}");
///   },
/// )
///```
///
/// Use [id] property for create a different instances of [ReactterContext].
///
/// **CONSIDER:** Dont's use [ReactterContext] with constructor parameters
/// to prevent conflicts.
///
/// **CONSIDER** Use [child] property to pass a [Widget] that
/// you want to build it once. The [ReactterProvider] pass it through
/// the [builder] callback, so you can incorporate it into your build:
///
///```dart
/// ReactterProvider<AppContext>(
///   () => AppContext(),
///   child: Text("This widget build only once"),
///   builder: (context, child) {
///     final appContext = context.watch<AppContext>();
///
///     return Column(
///       children: [
///         Text("state: ${appContext.stateA.value}"),
///         child,
///       ],
///     );
///   },
/// )
///```
///
/// **NOTE:** [ReactterProvider] is a "scoped". This mean that [ReactterProvider]
/// exposes the [ReactterContext] defined on first parameter([InstanceBuilder])
/// through the [BuildContext] in the widget subtree:
///
///```dart
/// ReactterProvider<AppContext>(
///   () => AppContext(),
///   builder: (appContext, context, child) {
///     return OtherWidget();
///   }
/// );
///
/// class OtherWidget extends StatelessWidget {
///   ...
///   Widget build(context) {
///      final appContext = context.use<AppContext>();
///
///      return Column(
///       children: [
///         Text("StateA: ${appContext.stateA.value}"),
///         Builder(
///           builder: (context){
///             context.watch<AppContext>((ctx) => [ctx.stateB]);
///
///             return Text("StateB: ${appContext.stateB.value}");
///           },
///         ),
///       ],
///     );
///   }
/// }
///```
///
/// In the above example, stateA remains static while the [Builder] is rebuilt
/// according to the changes in stateB. Because the [Builder]'s context kept in
/// watch of stateB.
///
/// See also:
///
/// * [ReactterContext], a base-class that allows to manages the [ReactterHook]s.
class ReactterProvider<T extends ReactterContext>
    extends ReactterProviderAbstraction {
  final String? id;

  /// Create a instances of [ReactterContext] class
  @protected
  final ContextBuilder<T> instanceBuilder;

  /// Create the instance defined
  /// on firts parameter [_instanceBuilder] when [UseContext] is called.
  @protected
  final bool init;

  /// Method which has the render logic
  ///
  /// Exposes [BuilderContext] and [child] widget as parameters.
  /// and returns a widget.
  @protected
  final InstanceBuilder<T>? builder;

  const ReactterProvider(
    this.instanceBuilder, {
    Key? key,
    this.id,
    this.init = false,
    Widget? child,
    this.builder,
  }) : super(
          key: key,
          // `child` is required because the super class is a InheritedWidget.
          child: child ?? const _UndefinedWidget(),
        );

  Widget build(BuildContext context) {
    return _buildWithChild(child is _UndefinedWidget ? null : child);
  }

  @override
  ReactterProviderElement createElement() {
    return ReactterProviderElement<T>(widget: this, id: id);
  }

  /// This is a hack to save it and find it with the `id` distinction
  /// in `_inheritedWidgets` of `Element` using the helper functions
  /// of `BuildContext` like `getElementForInheritedWidgetOfExactType`.
  @override
  Type get runtimeType {
    Type getType<TT>() => TT;

    if (id != null) {
      return getType<_ReactterProviderKey<T, String>>();
    }

    return getType<_ReactterProviderKey<T, Null>>();
  }

  /// A [build] method that receives an extra `child` parameter.
  ///
  /// This method may be called with a `child` different from the parameter
  /// passed to the constructor of [SingleChildStatelessWidget].
  /// It may also be called again with a different `child`, without this widget
  /// being recreated.
  Widget _buildWithChild(Widget? child) {
    return Builder(
      builder: (context) {
        assert(child != null || builder != null);

        final instance = context.use<T>(id);

        return builder?.call(instance, context, child) ?? child!;
      },
    );
  }

  /// Returns an instance of [T]
  /// and sets the `BuildContext` to listen for when it should be re-rendered.
  static T contextOf<T extends ReactterContext?>(
    BuildContext context, {
    String? id,
    ListenHooks<T>? listenHooks,
    bool listen = true,
  }) {
    final providerInheritedElement =
        _getProviderInheritedElement<T>(context, id);

    if (providerInheritedElement?._instance == null && null is! T) {
      throw ReactterContextNotFoundException(T, context.widget.runtimeType);
    }

    final instance = providerInheritedElement?._instance as T;

    if (!listen || instance == null) {
      return instance;
    }

    /// A way to tell the `BuildContext` that it should be re-rendered
    /// when the `ReactterInstance` or the `ReactterHook`s that are being listened
    /// change.
    context.dependOnInheritedElement(
      providerInheritedElement!,
      aspect: ReactterDependency<T?>(
        id: id,
        instance: listenHooks != null ? null : instance,
        states: listenHooks?.call(instance).toSet(),
      ),
    );

    return instance;
  }

  /// Returns the `ReactterProviderElement` of the `ReactterProvider` that is
  /// closest to the `BuildContext` that was passed as arguments.
  static ReactterProviderElement?
      _getProviderInheritedElement<T extends ReactterContext?>(
    BuildContext context, [
    String? id,
  ]) {
    // To find it with id, is O(2) complexity(O(1)*2)
    if (id != null) {
      final inheritedElementNotSure =
          context.getElementForInheritedWidgetOfExactType<
              _ReactterProviderKey<T, String>>() as ReactterProviderElement<T>?;

      return inheritedElementNotSure?.getInheritedElementOfExactId(id);
    }

    // To find it without id, is O(1) complexity
    return context.getElementForInheritedWidgetOfExactType<
        _ReactterProviderKey<T, Null>>() as ReactterProviderElement<T>?;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

/// `ReactterProviderElement` is a class that manages the lifecycle of the `ReactterInstance` and
/// provides the `ReactterInstance` to its descendants
class ReactterProviderElement<T extends ReactterContext?>
    extends InheritedElement
    with ReactterWrapperElementMixin, ReactterScopeElementMixin {
  final String? _id;
  Widget? _widget;
  bool _isRoot = false;
  Map<String, ReactterProviderElement<T>>? _inheritedElementsWithId;

  @override
  ReactterProvider get widget => super.widget as ReactterProvider;

  T? get _instance => Reactter.instanceOf<T>(_id);

  /// Creates an element that uses the given widget as its configuration.
  ReactterProviderElement({
    required ReactterProvider widget,
    String? id,
  })  : _id = id,
        super(widget) {
    if (widget.init) {
      _createInstance();
    }
  }

  @override
  void debugFillProperties(properties) {
    super.debugFillProperties(properties);

    properties.add(
      StringProperty('id', widget.id, showName: true),
    );
    properties.add(
      FlagProperty(
        'isRoot',
        value: _isRoot,
        ifTrue: 'true',
        ifFalse: 'false',
        showName: true,
      ),
    );
  }

  @override
  void mount(Element? parent, Object? newSlot) {
    if (!widget.init) {
      _createInstance();
    }

    _updateInheritedElementWithId(parent);

    if (_isRoot) {
      Reactter.emit(_instance, Lifecycle.willMount);
    }

    super.mount(parent, newSlot);

    if (_isRoot) {
      Reactter.emit(_instance, Lifecycle.didMount);
    }
  }

  @override
  Widget build() {
    if (_instanceOrStatesDirty.isNotEmpty) {
      notifyClients(widget);

      return _widget!;
    }

    if (parent != null) {
      return _widget = widget._buildWithChild(parent?.injectedChild);
    }

    return _widget = widget.build(this);
  }

  @override
  void unmount() {
    if (_isRoot) {
      Reactter.emit(_instance, Lifecycle.willUnmount);
    }

    Reactter.delete<T>(_id, this);

    _inheritedElementsWithId = null;
    _widget = null;

    return super.unmount();
  }

  /// Gets [ReactterProviderElement] that it has the [ReactterInstance]'s id.
  ReactterProviderElement<T>? getInheritedElementOfExactId(
    String id,
  ) =>
      _inheritedElementsWithId?[ReactterInstance.generateKey<T?>(id)];

  /// updates [inheritedElementsWithId]
  /// with all ancestor [ReactterProviderElement] with id
  void _updateInheritedElementWithId(Element? parent) {
    if (_id == null) return;

    var ancestorInheritedElement =
        parent?.getElementForInheritedWidgetOfExactType<
            _ReactterProviderKey<T, String>>() as ReactterProviderElement<T>?;

    if (ancestorInheritedElement?._inheritedElementsWithId != null) {
      _inheritedElementsWithId = HashMap<String, ReactterProviderElement<T>>.of(
        ancestorInheritedElement!._inheritedElementsWithId!,
      );
    } else {
      _inheritedElementsWithId = HashMap<String, ReactterProviderElement<T>>();
    }

    final instanceKey = ReactterInstance.generateKey<T?>(widget.id);
    _inheritedElementsWithId![instanceKey] = this;
  }

  void _createInstance() {
    _isRoot = !Reactter.exists<T>(_id);

    Reactter.create<T>(
      builder: widget.instanceBuilder as ContextBuilder<T>,
      id: _id,
      ref: this,
    );
  }
}

abstract class _ReactterProviderKey<T extends ReactterContext?,
    Id extends String?> extends InheritedWidget {
  // coverage:ignore-start
  const _ReactterProviderKey({Key? key})
      : super(key: key, child: const _UndefinedWidget());
  // coverage:ignore-end
}

class _UndefinedWidget extends Widget {
  const _UndefinedWidget({Key? key}) : super(key: key);

  // coverage:ignore-start
  @override
  Element createElement() {
    throw UnimplementedError();
  }
  // coverage:ignore-end
}
