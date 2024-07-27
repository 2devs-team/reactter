part of '../widgets.dart';

/// {@template flutter_reactter.rt_scope}
/// An [InheritedWidget] that provides a scope for managing state
/// and re-rendering child widgets.
class RtScope extends InheritedWidget {
  const RtScope({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  @override
  RtScopeElement createElement() => RtScopeElement(this);

  /// Returns the [RtScopeElement]
  /// and sets the [BuildContext] to listen for when it should be re-rendered.
  static void contextOf(
    BuildContext context, {
    String? id,
    ListenStates<void>? listenStates,
    bool listen = true,
  }) {
    final reactterScopeElement = _getScopeInheritedElement(context);

    if (listen && listenStates != null) {
      context.dependOnInheritedElement(
        reactterScopeElement,
        aspect: StatesDependency(
          listenStates(null).toSet(),
        ),
      );
    }
  }

  static RtScopeElement _getScopeInheritedElement(BuildContext context) {
    final reactterScopeElement =
        context.getElementForInheritedWidgetOfExactType<RtScope>();

    if (reactterScopeElement == null) {
      throw RtScopeNotFoundException(context.widget.runtimeType);
    }

    return reactterScopeElement as RtScopeElement;
  }
}

class RtScopeElement extends InheritedElement with ScopeElementMixin {
  Widget? prevChild;

  RtScopeElement(InheritedWidget widget) : super(widget);

  @override
  RtScope get widget => super.widget as RtScope;

  @override
  Widget build() {
    if (hasDependenciesDirty) {
      notifyClients(widget);

      if (prevChild != null) return prevChild!;
    }

    return prevChild = super.build();
  }
}

class RtScopeNotFoundException implements Exception {
  final Type widgetType;

  const RtScopeNotFoundException(
    this.widgetType,
  );

  @override
  String toString() {
    return '''
Error: Could not find the correct `RtScope` above this `$widgetType` Widget

This happens because you used a `BuildContext` without dependency defined:

- You added a new `RtScope` in your `main.dart` and perform a hot-restart.

  `RtScope` is a "scoped". So if you insert of `RtScope` inside a route, then
  other routes will not be able to access it.

If none of these solutions work, consider asking for help on StackOverflow:
https://stackoverflow.com/questions/tagged/flutter
    ''';
  }
}

/// {@macro flutter_reactter.rt_scope}
@Deprecated('Use `RtScope` instead')
typedef ReactterScope = RtScope;

@Deprecated('Use `RtScopeNotFoundException` instead')
typedef ReactterScopeNotFoundException = RtScopeNotFoundException;