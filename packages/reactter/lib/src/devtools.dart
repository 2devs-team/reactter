// coverage:ignore-file
import 'dart:collection';
import 'dart:developer' as dev;

import 'package:meta/meta.dart';
import 'package:reactter/src/signal/signal.dart';

import 'framework.dart';
import 'internals.dart';

extension RtDevToolsExt on RtInterface {
  /// Initialize the devtools for observing the states and dependencies.
  /// This will enable the devtools extension in the `Reactter` tab.
  void initializeDevTools() {
    RtDevTools.initialize();
  }
}

/// This class is used internally by the devtools extension only
/// and should not be used directly by the users.
///
/// To enable it, call the [Rt.initializeDevTools] method.
/// This will initialize the devtools and start observing changes.
///
/// To access the Reactter devtools, open the devtools extension
/// and navigate to the Reactter tab.
@internal
class RtDevTools implements IStateObserver, IDependencyObserver {
  static RtDevTools? instance;

  final LinkedList<_Node> _nodes = LinkedList();
  final LinkedHashMap<String, _Node> _nodesByKey = LinkedHashMap();

  static void initialize() {
    assert(() {
      if (kDebugMode && instance != null) {
        throw RtDevToolsInitializeAssertionError(
          'The devtools has already been initialized.',
        );
      }

      return true;
    }());

    if (kDebugMode) {
      instance ??= RtDevTools._();
    }
  }

  RtDevTools._() {
    Rt.addObserver(this);
  }

  @override
  void onStateCreated(RtState state) {
    final stateKey = state.hashCode.toString();
    final stateNode = _addNode(state);

    dev.postEvent('ext.reactter.onStateCreated', {
      'stateKey': stateKey,
      'state': stateNode.toJson(),
    });
  }

  @override
  void onStateBound(RtState state, Object instance) {
    final stateKey = state.hashCode.toString();
    final stateNode = _nodesByKey[stateKey];
    final instanceNode = _addNode(instance);

    if (stateNode != null) instanceNode.addChild(stateNode);

    dev.postEvent('ext.reactter.onStateBound', {
      'state': stateNode?.toJson(),
      'instance': instanceNode.toJson(),
    });
  }

  @override
  void onStateUnbound(RtState state, Object instance) {
    final stateKey = state.hashCode.toString();
    final instanceKey = instance.hashCode.toString();
    final stateNode = _nodesByKey[stateKey];
    final instanceNode = _nodesByKey[instanceKey];

    if (stateNode != null) instanceNode?.removeChild(stateNode);

    final isInstanceRemoved = _removeNode(instanceKey);

    dev.postEvent('ext.reactter.onStateUnbound', {
      'stateKey': stateKey,
      'instanceKey': instanceKey,
      'isInstanceRemoved': isInstanceRemoved,
    });
  }

  @override
  void onStateUpdated(RtState state) {
    final stateKey = state.hashCode.toString();

    dev.postEvent('ext.reactter.onStateUpdated', {
      'stateKey': stateKey,
    });
  }

  @override
  void onStateDisposed(RtState state) {
    final stateKey = state.hashCode.toString();

    final isStateRemoved = _removeNode(stateKey);

    dev.postEvent('ext.reactter.onStateDisposed', {
      'stateKey': stateKey,
      'isStateRemoved': isStateRemoved,
    });
  }

  @override
  void onDependencyRegistered(DependencyRef dependency) {
    final dependencyNode = _addNode(dependency);

    dev.postEvent('ext.reactter.onDependencyRegistered', {
      'dependency': dependencyNode.toJson(),
    });
  }

  @override
  void onDependencyCreated(DependencyRef dependency, Object? instance) {
    final dependencyKey = dependency.hashCode.toString();
    final dependencyNode = _nodesByKey[dependencyKey];

    _Node? instanceNode;
    if (instance != null) instanceNode = _addNode(instance);

    dev.postEvent('ext.reactter.onDependencyCreated', {
      'dependency': dependencyNode?.toJson(),
      'instance': instanceNode?.toJson(),
    });
  }

  @override
  void onDependencyMounted(DependencyRef dependency, Object? instance) {
    final dependencyKey = dependency.hashCode.toString();
    final instanceKey = instance.hashCode.toString();

    dev.postEvent('ext.reactter.onDependencyMounted', {
      'dependencyKey': dependencyKey,
      'instanceKey': instanceKey,
    });
  }

  @override
  void onDependencyUnmounted(DependencyRef dependency, Object? instance) {
    final dependencyKey = dependency.hashCode.toString();
    final instanceKey = instance.hashCode.toString();

    dev.postEvent('ext.reactter.onDependencyUnmounted', {
      'dependencyKey': dependencyKey,
      'instanceKey': instanceKey,
    });
  }

  @override
  void onDependencyDeleted(DependencyRef dependency, Object? instance) {
    final dependencyKey = dependency.hashCode.toString();
    final instanceObj =
        instance ?? _nodesByKey[dependencyKey]?.children.first.instance;
    final instanceKey = instanceObj.hashCode.toString();
    final dependencyNode = _nodesByKey[dependencyKey];
    final instanceNode = _nodesByKey[instanceKey];

    if (instanceNode != null) dependencyNode?.removeChild(instanceNode);

    final isInstanceRemoved = _removeNode(instanceKey);

    dev.postEvent('ext.reactter.onDependencyDeleted', {
      'dependencyKey': dependencyKey,
      'instanceKey': instanceKey,
      'isInstanceRemoved': isInstanceRemoved,
    });
  }

  @override
  void onDependencyUnregistered(DependencyRef dependency) {
    final dependencyKey = dependency.hashCode.toString();

    _removeNode(dependencyKey);

    dev.postEvent('ext.reactter.onDependencyUnregistered', {
      'dependencyKey': dependencyKey,
    });
  }

  @override
  void onDependencyFailed(
    covariant DependencyRef<Object?> dependency,
    DependencyFail fail,
  ) {}

  Map<String, dynamic> getNodes(int page, int pageSize) {
    final nodesList = _nodes.toList();
    final length = nodesList.length;
    final start = page * pageSize;
    final end = length < (start + pageSize) ? length : start + pageSize;
    final totalPages = (length / pageSize).ceil();

    final data =
        nodesList.sublist(start, end).map((node) => node.toJson()).toList();

    return {
      'nodes': data,
      'total': length,
      'start': start,
      'end': end,
      'page': page,
      'pageSize': pageSize,
      'totalPages': totalPages,
    };
  }

  _Node _addNode(Object instance) {
    _Node node;

    if (instance is DependencyRef) {
      node = _addDependencyNode(instance);
    } else if (instance is RtState) {
      node = _addStateNode(instance);
    } else {
      node = _addInstanceNode(instance);
    }

    _nodesByKey[node.key] = node;

    if (node.list == null) {
      _nodes.add(node);
      node.moveChildren();
    }

    return node;
  }

  bool _removeNode(String nodeKey) {
    final node = _nodesByKey[nodeKey];

    if (node == null) return false;

    final isRemoved = node.remove();

    if (isRemoved) _nodesByKey.remove(nodeKey);

    return isRemoved;
  }

  _StateNode _addStateNode(RtState state) {
    final stateKey = state.hashCode.toString();
    final stateNode = _nodesByKey.putIfAbsent(
      stateKey,
      () => _StateNode(instance: state),
    ) as _StateNode;

    final boundInstance = state.boundInstance;

    if (boundInstance != null) {
      final boundInstanceNode = _addNode(boundInstance);
      boundInstanceNode.addChild(stateNode);
    }

    return stateNode;
  }

  _DependencyNode _addDependencyNode(DependencyRef dependencyRef) {
    final dependencyKey = dependencyRef.hashCode.toString();
    final dependencyNode = _nodesByKey.putIfAbsent(
      dependencyKey,
      () => _DependencyNode(instance: dependencyRef),
    ) as _DependencyNode;

    final instance = Rt.getDependencyRegisterByRef(dependencyRef)?.instance;

    if (instance != null) {
      final instanceNode = _addNode(instance);
      dependencyNode.addChild(instanceNode);
    }

    return dependencyNode;
  }

  _InstanceNode _addInstanceNode(Object instance) {
    return _nodesByKey.putIfAbsent(
      instance.hashCode.toString(),
      () => _InstanceNode(instance: instance),
    ) as _InstanceNode;
  }

  Map<String, dynamic>? getDebugInfo(String stateKey) {
    final state = _nodesByKey[stateKey];

    if (state is! _StateNode) return null;

    return state.instance.debugInfo;
  }

  dynamic getBoundInstance(String stateKey) {
    final state = _nodesByKey[stateKey];

    if (state is! _StateNode) return null;

    return state.instance.boundInstance;
  }

  dynamic getDependencyRef(String dependencyKey) {
    final dependencyRef = _nodesByKey[dependencyKey];

    if (dependencyRef is! _DependencyNode) return null;

    return dependencyRef.instance;
  }

  Map<String, dynamic> getDependencyInfo(String dependencyKey) {
    final dependencyRef = _nodesByKey[dependencyKey];

    if (dependencyRef is! _DependencyNode) return {};

    return dependencyRef.toJson();
  }

  Map<String, dynamic> getPlainInstanceInfo(Object instance) {
    if (instance is DependencyRef) {
      return _DependencyNode.getInstanceInfo(instance);
    }

    if (instance is RtState) {
      return _StateNode.getInstanceInfo(instance);
    }

    return getInstanceInfo(instance);
  }

  Map<String, dynamic> getInstanceInfo(Object instance) {
    if (instance is Enum) {
      return {
        ..._InstanceNode.getInstanceInfo(instance),
        'type': instance.toString(),
      };
    }

    if (instance is Iterable) {
      return {
        ..._InstanceNode.getInstanceInfo(instance),
        'fields': {
          'length': instance.length,
          'items': instance.toList(),
        },
      };
    }

    return _InstanceNode.getInstanceInfo(instance);
  }
}

@internal
abstract class NodeKind {
  static const String state = 'state';
  static const String hook = 'hook';
  static const String signal = 'signal';
  static const String instance = 'instance';
  static const String dependency = 'dependency';
}

abstract class _Node<T extends Object> extends LinkedListEntry<_Node> {
  String get key => instance.hashCode.toString();

  _Node? _parent;
  _Node? get parent => _parent;

  final T instance;
  final LinkedHashSet<_Node> children = LinkedHashSet();

  _Node({required this.instance});

  Map<String, String?> toJson() {
    final dependencyRef = Rt.getDependencyRef(instance);
    final dependencyId = dependencyRef?.id;

    return {
      'key': key,
      'dependencyId': dependencyId,
      'dependencyKey': dependencyRef?.hashCode.toString(),
    };
  }

  _Node? get lastDescendant =>
      children.isEmpty ? this : children.last.lastDescendant as _Node;

  @override
  void unlink() {
    if (list == null) return;

    super.unlink();
  }

  void addChild(_Node node) {
    if (node._parent == this) return;

    if (node.list != null) node.unlink();

    node._parent?.children.remove(node);

    if (lastDescendant?.list != null) {
      lastDescendant?.insertAfter(node);
    } else {
      insertAfter(node);
    }

    node.moveChildren();

    children.add(node);
    node._parent = this;
  }

  void moveChildren() {
    _Node? prevChild;

    for (final child in children) {
      if (child.list != null) child.unlink();

      if (prevChild != null) {
        prevChild.insertAfter(child);
      } else {
        insertAfter(child);
      }

      child.moveChildren();

      prevChild = child;
    }
  }

  void removeChild(_Node node) {
    // for (final child in node.children.toList()) {
    //   if (child.list != null) {
    //     node.removeChild(child);
    //   }
    // }

    if (node.list != null) {
      node.unlink();
    }

    if (node._parent == this) {
      children.remove(this);
      node._parent = null;
    }

    if (children.isEmpty) {
      unlink();
    }
  }

  bool remove() {
    if (children.isEmpty) {
      _parent?.removeChild(this);

      if (list != null) unlink();
    }

    return list == null;
  }
}

class _InstanceNode extends _Node {
  _InstanceNode({required Object instance}) : super(instance: instance);

  static Map<String, dynamic> getInstanceInfo(Object instance) {
    final value = instance.toString();
    final type = instance.runtimeType.toString();

    return {
      'kind': NodeKind.instance,
      'key': instance.hashCode.toString(),
      'type': type,
      'value': value.startsWith("Instance of") || value == type ? null : value,
    };
  }

  @override
  Map<String, String?> toJson() {
    return {
      ...getInstanceInfo(instance),
      ...super.toJson(),
    };
  }

  @override
  bool remove() {
    final json = toJson();

    if (json['dependencyKey'] == null) {
      return super.remove();
    }

    return false;
  }
}

class _StateNode extends _Node<RtState> {
  _StateNode({required RtState instance}) : super(instance: instance);

  static String resolveKind(RtState instance) {
    if (instance is Signal) return NodeKind.signal;
    if (instance is RtHook) return NodeKind.hook;
    return NodeKind.state;
  }

  static Map<String, dynamic> getInstanceInfo(RtState instance) {
    return {
      'kind': resolveKind(instance),
      'key': instance.hashCode.toString(),
      'type': instance.runtimeType.toString(),
      'debugLabel': instance.debugLabel,
      'boundInstanceKey': instance.boundInstance?.hashCode.toString(),
    };
  }

  @override
  Map<String, String?> toJson() {
    return {
      ...getInstanceInfo(instance),
      ...super.toJson(),
    };
  }

  @override
  bool remove() {
    final json = toJson();

    if (json['dependencyKey'] == null) {
      return super.remove();
    }

    return false;
  }
}

class _DependencyNode extends _Node<DependencyRef> {
  _DependencyNode({required DependencyRef instance})
      : super(instance: instance);

  static Map<String, dynamic> getInstanceInfo(DependencyRef instance) {
    final dependencyRef = Rt.getDependencyRegisterByRef(instance);

    return {
      'kind': NodeKind.dependency,
      'key': instance.hashCode.toString(),
      'type': instance.type.toString(),
      'id': instance.id,
      'mode': dependencyRef?.mode.toString(),
      'instanceKey': dependencyRef?.instance.hashCode.toString(),
    };
  }

  @override
  Map<String, String?> toJson() {
    return {
      ...getInstanceInfo(instance),
      ...super.toJson(),
    };
  }
}

@internal
typedef RtDevToolsInitializeAssertionError = AssertionError;
