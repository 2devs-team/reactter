part of '../widgets.dart';

/// An [InheritedWidget] that provides a scope for managing state
/// and re-rendering child widgets.
class ReactterScope extends InheritedWidget {
  const ReactterScope({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  @override
  ReactterScopeElement createElement() => ReactterScopeElement(this);

  /// Returns the [ReactterScopeElement]
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

  static ReactterScopeElement _getScopeInheritedElement(BuildContext context) {
    final reactterScopeElement =
        context.getElementForInheritedWidgetOfExactType<ReactterScope>();

    if (reactterScopeElement == null) {
      throw ReactterScopeNotFoundException(context.widget.runtimeType);
    }

    return reactterScopeElement as ReactterScopeElement;
  }
}

class ReactterScopeElement extends InheritedElement with ScopeElementMixin {
  Widget? prevChild;

  ReactterScopeElement(InheritedWidget widget) : super(widget);

  @override
  ReactterScope get widget => super.widget as ReactterScope;

  @override
  Widget build() {
    if (hasDependenciesDirty) {
      notifyClients(widget);

      if (prevChild != null) return prevChild!;
    }

    return prevChild = super.build();
  }
}

class ReactterScopeNotFoundException implements Exception {
  final Type widgetType;

  const ReactterScopeNotFoundException(
    this.widgetType,
  );

  @override
  String toString() {
    return '''
Error: Could not find the correct `ReactterScope` above this `$widgetType` Widget

This happens because you used a `BuildContext` without dependency defined:

- You added a new `ReactterScope` in your `main.dart` and perform a hot-restart.

  `ReactterScope` is a "scoped". So if you insert of `ReactterScope` inside a route, then
  other routes will not be able to access it.

If none of these solutions work, consider asking for help on StackOverflow:
https://stackoverflow.com/questions/tagged/flutter
    ''';
  }
}
