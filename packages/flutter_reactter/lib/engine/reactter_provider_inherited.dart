part of '../widgets.dart';

enum _InheritedElementStatus { mount, unmount }

/// A generic implementation for [ReactterProvider]
class ReactterProviderInherited<T extends ReactterContext?, Id extends String?>
    extends InheritedWidget {
  final ReactterProvider owner;

  const ReactterProviderInherited({
    Key? key,
    required this.owner,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

  @override
  ReactterProviderInheritedElement createElement() {
    return ReactterProviderInheritedElement<T, Id>(this);
  }
}

/// [ReactterProviderInherited]'s Element
class ReactterProviderInheritedElement<T extends ReactterContext?,
    Id extends String?> extends InheritedElement {
  T? _instance;
  bool _isRoot = false;
  Map<ReactterInstance, ReactterProviderInheritedElement<T, Id>>?
      _inheritedElementsWithId;
  late final _event = UseEvent.withInstance(this);

  ReactterProviderInheritedElement(
    ReactterProviderInherited widget,
  ) : super(widget) {
    if (widget.owner.init) {
      _createInstance();
    }
  }

  @override
  ReactterProviderInherited get widget =>
      super.widget as ReactterProviderInherited;

  @override
  void debugFillProperties(properties) {
    super.debugFillProperties(properties);

    properties.add(
      StringProperty('id', widget.owner.id, showName: true),
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
    if (!widget.owner.init) {
      _createInstance();
    }

    _event.emit(_InheritedElementStatus.mount);

    _loadInheritedElementWithId(parent);

    if (_isRoot) {
      UseEvent.withInstance(_instance).emit(Lifecycle.willMount);
    }

    super.mount(parent, newSlot);

    if (_isRoot) {
      UseEvent.withInstance(_instance).emit(Lifecycle.didMount);
    }
  }

  @override
  void unmount() {
    if (_isRoot) {
      UseEvent.withInstance(_instance).emit(Lifecycle.willUnmount);
    }

    _event.emit(_InheritedElementStatus.unmount);
    widget.owner._deleteInstance(this);
    _inheritedElementsWithId = null;
    _instance = null;

    return super.unmount();
  }

  /// Gets [ReactterProviderInheritedElement] that it has the [ReactterInstance]'s id.
  ReactterProviderInheritedElement<T, Id>? getInheritedElementOfExactId(
    String id,
  ) =>
      _inheritedElementsWithId?[ReactterInstance<T>(id)];

  /// Loads all ancestor [ReactterProviderInheritedElement] with id
  void _loadInheritedElementWithId(Element? parent) {
    if (Id == Null) return;

    var ancestorInheritedElement =
        parent?.getElementForInheritedWidgetOfExactType<
                ReactterProviderInherited<T, Id>>()
            as ReactterProviderInheritedElement<T, Id>?;

    void _onAncestorMount(_, __) =>
        _updateInheritedElementWithId(ancestorInheritedElement);

    _onAncestorMount(null, null);

    void _onUnmount(_, __) => ancestorInheritedElement?._event
        .off(_InheritedElementStatus.mount, _onAncestorMount);

    ancestorInheritedElement?._event
        .one(_InheritedElementStatus.mount, _onAncestorMount);

    _event.one(_InheritedElementStatus.unmount, _onUnmount);
  }

  /// updates [inheritedElementsWithId]
  /// with all ancestor [ReactterProviderInheritedElement] with id
  void _updateInheritedElementWithId(
    ReactterProviderInheritedElement<T, Id>? ancestorInheritedElement,
  ) {
    if (ancestorInheritedElement != null &&
        ancestorInheritedElement._inheritedElementsWithId != null) {
      _inheritedElementsWithId =
          HashMap<ReactterInstance, ReactterProviderInheritedElement<T, Id>>.of(
              ancestorInheritedElement._inheritedElementsWithId!);
    } else {
      _inheritedElementsWithId =
          HashMap<ReactterInstance, ReactterProviderInheritedElement<T, Id>>();
    }

    final reactterInstance = ReactterInstance<T>(widget.owner.id);
    _inheritedElementsWithId![reactterInstance] = this;
  }

  void _createInstance() {
    _isRoot = !widget.owner._existsInstance();
    _instance = widget.owner._createInstance(this) as T;
  }
}
