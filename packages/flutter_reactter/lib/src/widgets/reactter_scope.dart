part of '../widgets.dart';

class ReactterScope extends InheritedWidget {
  const ReactterScope({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  @override
  ReactterScopeElement createElement() {
    return ReactterScopeElement(this);
  }

  /// Returns the [ReactterScopeElement]
  /// and sets the `BuildContext` to listen for when it should be re-rendered.
  static ReactterScopeElement? contextOf(
    BuildContext context, {
    String? id,
    ListenStates<void>? listenStates,
    bool listen = true,
  }) {
    final reactterScopeElement =
        context.getElementForInheritedWidgetOfExactType<ReactterScope>();

    if (reactterScopeElement == null) {
      throw ReactterScopeNotFoundException(context.widget.runtimeType);
    }

    if (listen && listenStates != null) {
      context.dependOnInheritedElement(
        reactterScopeElement,
        aspect: ReactterStatesDependency(
          listenStates(null).toSet(),
        ),
      );
    }

    return reactterScopeElement as ReactterScopeElement;
  }
}

class ReactterScopeElement extends InheritedElement
    with ReactterScopeElementMixin {
  ReactterScopeElement(InheritedWidget widget) : super(widget);
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

This happens because you used a `BuildContext` that does not include the instance of your choice.
There are a few common scenarios:

- You added a new `ReactterScope` in your `main.dart` and perform a hot-restart.

  `ReactterScope` is a "scoped". So if you insert of `ReactterScope` inside a route, then
  other routes will not be able to access that instance.

If none of these solutions work, consider asking for help on StackOverflow:
https://stackoverflow.com/questions/tagged/flutter
    ''';
  }
}
