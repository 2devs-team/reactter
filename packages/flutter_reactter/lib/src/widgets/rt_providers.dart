part of '../widgets.dart';

/// Abstract class to implementing a wrapper widget for [RtProvider]
@internal
abstract class ProviderWrapper implements WrapperWidget {}

/// {@template flutter_reactter.rt_multi_provider}
/// A [StatelessWidget] that allows to use multiple [RtProvider] as nested way.
///
/// ```dart
/// RtMultiProvider(
///   [
///     RtProvider(() => AppController()),
///     RtProvider(() => AppController(), id: "uniqueId"),
///   ],
///   builder: (context, child) {
///     final appController = context.read<AppController>();
///     final appControllerWithId = context.watchId<AppController>("uniqueId");
///
///     return Column(
///       children: [
///         Text("AppController's state: ${appController.stateHook.value}"),
///         Text("appControllerWithId's state: ${appController.stateHook.value}");
///       ],
///     );
///   }
/// )
/// ```
///
/// Use [child] property to pass a [Widget] which to be built once only.
/// The [RtMultiProvider] pass it through the [builder] callback,
/// so you can incorporate it into your build:
///
/// ```dart
/// RtMultiProvider(
///   [
///     ReactterProvider(() => AppController()),
///     ReactterProvider(() => AppController(), id: "uniqueId"),
///   ],
///   child: Text("This widget build only once"),
///   builder: (context, child) {
///     final appController = context.read<AppController>();
///     final appControllerWithId = context.watchId<AppController>("uniqueId");
///
///     return Column(
///       children: [
///         child,
///         Text("AppController's state: ${appController.stateHook.value}"),
///         Text("appControllerWithId's state: ${appController.stateHook.value}");
///       ],
///     );
///   }
/// )
/// ```
///
/// See also:
///
/// * [RtProvider], a widget that provides a [T] dependency to widget tree.
/// {@endtemplate}
class RtMultiProvider extends StatelessWidget implements ProviderWrapper {
  /// {@macro reactter_providers}
  const RtMultiProvider(
    this.providers, {
    Key? key,
    this.child,
    this.builder,
  })  : assert(child != null || builder != null),
        super(key: key);

  final List<ProviderWrapper> providers;

  /// Provides a widget , which render one time.
  ///
  /// It's expose on [builder] method as second parameter.
  final Widget? child;

  /// Method which has the render logic
  ///
  /// Exposes [BuilderContext] and [child] widget as parameters.
  /// and returns a widget.
  final ChildBuilder? builder;

  @override
  Widget build(BuildContext context) {
    return builder?.call(context, child) ?? child!;
  }

  @override
  RtMultiProviderElement createElement() {
    return RtMultiProviderElement(this);
  }

  // coverage:ignore-start
  @override
  void dispose() {}
  // coverage:ignore-end
}

class RtMultiProviderElement extends StatelessElement
    with WrapperElementMixin<RtMultiProvider> {
  /// Creates an element that uses the given widget as its configuration.
  RtMultiProviderElement(RtMultiProvider widget) : super(widget);

  @override
  Widget build() {
    NestedWidget? nestedHook;
    var nextNode = parent?.injectedChild ??
        Builder(
          builder: (context) => widget.build(context),
        );

    for (final child in widget.providers.reversed) {
      nextNode = nestedHook = NestedWidget<RtMultiProvider>(
        owner: this,
        wrappedWidget: child,
        injectedChild: nextNode,
      );
    }

    if (nestedHook == null) return nextNode;

    /// We manually update [NestedElement] instead of letter widgets do their thing
    /// because an item N may be constant but N+1 not. So, if we used widgets
    /// then N+1 wouldn't rebuild because N didn't change
    for (final node in nodes.toList(growable: false)) {
      node
        ..wrappedWidget = nestedHook!.wrappedWidget
        ..injectedChild = nestedHook.injectedChild;

      final next = nestedHook.injectedChild;
      if (next is NestedWidget) {
        nestedHook = next;
      } else {
        break;
      }
    }

    return nextNode;
  }

  @override
  void removeNode(NestedElement node) {
    super.removeNode(node);

    if (node.wrappedWidget is RtProvider) {
      (node.wrappedWidget as RtProvider).disposeInstance();
    }
  }
}
