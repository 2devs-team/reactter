part of '../widgets.dart';

/// Abstract class to implementing a wrapper widget for [RtProvider]
@internal
abstract class ProviderWrapper implements WrapperWidget {}

/// {@template reactter_providers}
/// A [StatelessWidget] that allows to use multiple [RtProvider] as nested way.
///
/// ```dart
/// ReactterProviders(
///   [
///     ReactterProvider(() => AppController()),
///     ReactterProvider(() => AppController(), id: "uniqueId"),
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
/// The [ReactterProviders] pass it through the [builder] callback,
/// so you can incorporate it into your build:
///
/// ```dart
/// ReactterProviders(
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
class ReactterProviders extends StatelessWidget implements ProviderWrapper {
  /// {@macro reactter_providers}
  const ReactterProviders(
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
  ReactterProvidersElement createElement() {
    return ReactterProvidersElement(this);
  }
}

class ReactterProvidersElement extends StatelessElement
    with WrapperElementMixin<ReactterProviders> {
  /// Creates an element that uses the given widget as its configuration.
  ReactterProvidersElement(ReactterProviders widget) : super(widget);

  @override
  Widget build() {
    NestedWidget? nestedHook;
    var nextNode = parent?.injectedChild ??
        Builder(
          builder: (context) => widget.build(context),
        );

    for (final child in widget.providers.reversed) {
      nextNode = nestedHook = NestedWidget<ReactterProviders>(
        owner: this,
        wrappedWidget: child,
        injectedChild: nextNode,
      );
    }

    if (nestedHook != null) {
      // We manually update ReactterNestedProviderElement instead of letter widgets do their thing
      // because an item N may be constant but N+1 not. So, if we used widgets
      // then N+1 wouldn't rebuild because N didn't change
      for (final node in nodes) {
        node
          ..wrappedChild = nestedHook!.wrappedWidget
          ..injectedChild = nestedHook.injectedChild;

        final next = nestedHook.injectedChild;
        if (next is NestedWidget) {
          nestedHook = next;
        } else {
          break;
        }
      }
    }

    return nextNode;
  }
}
