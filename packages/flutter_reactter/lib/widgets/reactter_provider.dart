// ignore_for_file: prefer_void_to_null, invalid_use_of_protected_member

part of '../widgets.dart';

abstract class ReactterProviderAbstraction<T extends ReactterContext>
    extends StatelessWidget implements ReactterWrapperWidget {
  const ReactterProviderAbstraction({Key? key}) : super(key: key);

  @override
  ReactterProviderElement createElement() {
    return ReactterProviderElement(this);
  }
}

/// A wrapper [StatelessWidget] that provides a [ReactterContext]'s instance of [T]
/// to widget tree that can be access through the [BuildContext].
///
///```dart
/// ReactterProvider(
///   () => AppContext(),
///   builder: (context, child) {
///     final appContext = context.watch<AppContext>();
///     return Text("state: ${appContext.stateHook.value}");
///   },
/// )
///```
///
/// **IMPORTANT:** Don's use [ReactterContext] with constructor parameters to prevent conflicts.
/// Instead of it, use [onInit] method to access its instance and put the data you need.
///
/// **NOTE:** [ReactteProvider] is a "scoped". So it contains a [ReactterScope]
/// which the [builder] callback will be rebuild, when the [ReactterContext] changes.
/// For this to happen, the [ReactterContext] should put it on listens
/// for [BuildContext]'s [watch]ers.
///
/// If you want to create a different [ReactterContext]'s instance, use [id] parameter.
///
/// If you don't want to rebuild a part of [builder] callback, use the [child]
/// property, it's more efficient to build that subtree once instead of
/// rebuilding it on every [ReactterContext] changes.
///
///```dart
/// ReactterProvider(
///   () => AppContext(),
///   child: Text("This widget build only once"),
///   builder: (context, child) {
///     final appContext = context.watch<AppContext>();
///     return Column(
///       children: [
///         Text("state: ${appContext.stateHook.value}"),
///         child,
///       ],
///     );
///   },
/// )
///```
class ReactterProvider<T extends ReactterContext>
    extends ReactterProviderAbstraction {
  /// Create a instances of [ReactterContext] class
  @protected
  final ContextBuilder<T> instanceBuilder;

  /// Id usted to identify the context
  final String? id;

  /// Provides a widget , which render one time.
  ///
  /// It's expose on [builder] method as second parameter.
  final Widget? child;

  /// Method which has the render logic
  ///
  /// Exposes [BuilderContext] and [child] widget as parameters.
  /// and returns a widget.
  final TransitionBuilder? builder;

  /// Create the instance defined
  /// on firts parameter [_instanceBuilder] when [UseContext] is called.
  @protected
  final bool init;

  /// Invoked when instance defined
  /// on firts parameter [_instanceBuilder] is created
  @protected
  final OnInitContext<T>? onInit;

  const ReactterProvider(
    this.instanceBuilder, {
    Key? key,
    this.id,
    this.init = false,
    this.onInit,
    this.child,
    this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildWithChild(context, child);
  }

  /// A [build] method that receives an extra `child` parameter.
  ///
  /// This method may be called with a `child` different from the parameter
  /// passed to the constructor of [SingleChildStatelessWidget].
  /// It may also be called again with a different `child`, without this widget
  /// being recreated.
  Widget _buildWithChild(BuildContext context, Widget? child) {
    return ReactterProvider._buildScope<T>(
      id: id,
      owner: this,
      child: Builder(
        builder: (context) {
          assert(child != null || builder != null);

          return builder?.call(context, child) ?? child!;
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
      return ReactterProviderInherited<T, String>(
        owner: owner,
        child: child,
      );
    }

    return ReactterProviderInherited<T, Null>(
      owner: owner,
      child: child,
    );
  }

  bool _existsInstance() => Reactter.exists<T>(id);

  T? _createInstance(Object ref) {
    final instance = Reactter.create<T>(
      builder: instanceBuilder,
      id: id,
      ref: ref,
    );

    if (instance != null) {
      onInit?.call(instance);
    }

    return instance;
  }

  void _deleteInstance(Object ref) {
    Reactter.delete<T>(id, ref);
  }

  /// Returns a [_instance] of [T]
  /// and puts contexts listen to when it should be re-rendered
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

    context.dependOnInheritedElement(providerInheritedElement!);

    if (listenHooks != null) {
      final hooks = listenHooks(instance);

      providerInheritedElement.dependOnHooks(hooks);

      return instance;
    }

    providerInheritedElement.dependOnInstance(instance);

    return instance;
  }

  static ReactterProviderInheritedElement?
      _getProviderInheritedElement<T extends ReactterContext?>(
          BuildContext context,
          [String? id]) {
    if (id != null) {
      // O(2)
      final inheritedElementNotSure =
          context.getElementForInheritedWidgetOfExactType<
                  ReactterProviderInherited<T, String>>()
              as ReactterProviderInheritedElement<T, String>?;

      return inheritedElementNotSure?.getInheritedElementOfExactId(id);
    }

    // O(1)
    return context.getElementForInheritedWidgetOfExactType<
            ReactterProviderInherited<T, Null>>()
        as ReactterProviderInheritedElement<T, Null>?;
  }
}

class ReactterProviderElement extends StatelessElement
    with ReactterWrapperElementMixin<ReactterProvider> {
  /// Creates an element that uses the given widget as its configuration.
  ReactterProviderElement(ReactterProviderAbstraction widget) : super(widget);

  @override
  Widget build() {
    if (parent != null) {
      return widget._buildWithChild(this, parent?.injectedChild);
    }

    return super.build();
  }
}

extension ReactterElementExtension on Element {}
