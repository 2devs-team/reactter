import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactter/reactter.dart';
import 'package:reactter_devtools_extension/src/constants.dart';
import 'package:reactter_devtools_extension/src/nodes/dependency/dependency_info.dart';
import 'package:reactter_devtools_extension/src/nodes/dependency/dependency_node.dart';

import 'package:reactter_devtools_extension/src/nodes/instance/instance_info.dart';
import 'package:reactter_devtools_extension/src/nodes/instance/instance_node.dart';
import 'package:reactter_devtools_extension/src/nodes/sentinel_node.dart';
import 'package:reactter_devtools_extension/src/nodes/slot_node.dart';
import 'package:reactter_devtools_extension/src/nodes/state/state_info.dart';
import 'package:reactter_devtools_extension/src/bases/tree_list.dart';
import 'package:reactter_devtools_extension/src/bases/node.dart';
import 'package:reactter_devtools_extension/src/services/devtools_service.dart';
import 'package:reactter_devtools_extension/src/nodes/state/state_node.dart';
import 'package:vm_service/vm_service.dart';

class NodesController {
  StreamSubscription? extEventSubscription;

  final devtoolsSevices = DevtoolsService();
  final nodesList = TreeList<Node>();
  final dependenciesList = TreeList<Node>();
  final uNodes = UseState(LinkedHashMap<String, Node>());
  final uCurrentNodeKey = UseState<String?>(null);
  final uMaxDepth = UseState(0);

  final nodesListViewKey = GlobalKey();
  final dependenciesListViewKey = GlobalKey();

  final nodesListScrollControllerY = ScrollController();
  final dependencyListScrollControllerY = ScrollController();

  Node? get currentNode => uNodes.value[uCurrentNodeKey.value];

  NodesController() {
    init();
  }

  Future<void> init() async {
    await getAllNodes();

    final vmService = await serviceManager.onServiceAvailable;

    // Listen hot-restart for re-fetching all nodes
    serviceManager.isolateManager.selectedIsolate.addListener(getAllNodes);

    extEventSubscription = vmService.onExtensionEvent.listen((event) {
      if (!(event.extensionKind?.startsWith('ext.reactter.') ?? false)) {
        return;
      }

      final eventData = event.extensionData?.data ?? {};

      switch (event.extensionKind) {
        case 'ext.reactter.onStateCreated':
          final Map<String, dynamic> state = eventData['state'];
          addNodeByMapInfo(state);
          break;
        case 'ext.reactter.onStateBound':
          final Map<String, dynamic> state = eventData['state'];
          final Map<String, dynamic> instance = eventData['instance'];
          addNodeByMapInfo(state);
          addNodeByMapInfo(instance);
          break;
        case 'ext.reactter.onStateUnbound':
          final String instanceKey = eventData['instanceKey'];
          final bool isInstanceRemoved = eventData['isInstanceRemoved'];
          if (isInstanceRemoved) removeNodeByKey(instanceKey);
          break;
        case 'ext.reactter.onStateUpdated':
          final String stateKey = eventData['stateKey'];
          if (uCurrentNodeKey.value == stateKey) currentNode?.loadDetails();
          break;
        case 'ext.reactter.onStateDisposed':
          final String stateKey = eventData['stateKey'];
          final bool isStateRemoved = eventData['isStateRemoved'];
          if (isStateRemoved) removeNodeByKey(stateKey);
          break;
        case 'ext.reactter.onDependencyRegistered':
          final Map<String, dynamic> dependency = eventData['dependency'];
          addNodeByMapInfo(dependency);
          break;
        case 'ext.reactter.onDependencyCreated':
          final Map<String, dynamic> dependency = eventData['dependency'];
          final Map<String, dynamic> instance = eventData['instance'];
          addNodeByMapInfo(dependency);
          addNodeByMapInfo(instance);
          break;
        case 'ext.reactter.onDependencyDeleted':
          final String instanceKey = eventData['instanceKey'];
          final bool isInstanceRemoved = eventData['isInstanceRemoved'];
          if (isInstanceRemoved) removeNodeByKey(instanceKey);
          break;
        case 'ext.reactter.onDependencyUnregistered':
          final String dependencyKey = eventData['dependencyKey'];
          removeNodeByKey(dependencyKey);
          break;
      }
    });
  }

  Future<void> getAllNodes() async {
    resetState();
    final nodesInfo = await devtoolsSevices.getAllNodes();
    addNodes(nodesInfo);
  }

  void resetState() {
    nodesList.clear();
    dependenciesList.clear();
    uNodes.value.clear();
    uCurrentNodeKey.value = null;
    uMaxDepth.value = 0;
  }

  void selectNodeByKey(String nodeKey) {
    final node = uNodes.value[nodeKey];

    if (node != null) selectNode(node);

    final index = node?.getIndex();

    if (index == null) return;

    final offset = index * kNodeTileHeight;
    final list = node?.list;
    final isDependenciesList = list == dependenciesList;
    final scrollController = isDependenciesList
        ? dependencyListScrollControllerY
        : nodesListScrollControllerY;
    final scrollBottom =
        scrollController.offset + scrollController.position.viewportDimension;
    final nodeBottom = offset + kNodeTileHeight;

    if (offset > scrollController.offset && nodeBottom < scrollBottom) return;

    scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.bounceIn,
    );
  }

  Future<void> addNodeByKey(String nodeKey, [Map fallback = const {}]) async {
    final nodeInfo = await devtoolsSevices.getNodeBykey(nodeKey, fallback);
    addNodeByMapInfo(nodeInfo);
  }

  void addNodes(List<Map> nodesInfo) {
    Rt.batch(() {
      for (final nodeInfo in nodesInfo) {
        addNodeByMapInfo(nodeInfo);
      }
    });
  }

  void addNodeByMapInfo(Map nodeInfo) {
    final kind = nodeInfo['kind'];
    final key = nodeInfo['key'];
    final type = nodeInfo['type'];
    final error = nodeInfo['error'];
    final dependencyRef = nodeInfo['dependencyRef'];

    if (error is SentinelException) {
      final nodePrev = uNodes.value[key];
      final node = nodePrev ??
          SentinelNode(
            key: key,
            kind: kind,
            type: type ?? 'Unknown',
          );

      if (kind == 'dependency') {
        addDependencyNode(node);
      } else {
        addNode(node);
      }

      return;
    }

    switch (kind) {
      case 'dependency':
        final nodePrev = uNodes.value[key];
        final node = nodePrev is DependencyNode
            ? nodePrev
            : DependencyNode(
                key: key,
                kind: kind,
                type: type,
              );

        node.uInfo.value = DependencyInfo(
          id: nodeInfo['id'],
        );

        addDependencyNode(node);
        break;
      case 'state':
      case 'hook':
      case 'signal':
        final nodePrev = uNodes.value[key];
        final node = nodePrev is StateNode
            ? nodePrev
            : StateNode(
                key: key,
                kind: kind,
                type: type,
              );

        final debugLabel = nodeInfo['debugLabel'];
        final boundInstanceKey = nodeInfo['boundInstanceKey'];

        node.uInfo.value = StateInfo(
          dependencyRef: dependencyRef,
          debugLabel: debugLabel,
          boundInstanceKey: boundInstanceKey,
        );

        if (boundInstanceKey != null) {
          final boundInstanceNodePrev = uNodes.value[boundInstanceKey];
          final boundInstanceNode = boundInstanceNodePrev ??
              SlotNode(
                key: boundInstanceKey,
                kind: kind,
                type: 'Unknown',
              );

          addNode(boundInstanceNode);

          boundInstanceNode.addChild(node);
        }

        addNode(node);

        break;
      case 'instance':
        final nodePrev = uNodes.value[key];
        final node = nodePrev is InstanceNode
            ? nodePrev
            : InstanceNode(
                key: key,
                kind: kind,
                type: type,
              );

        node.uInfo.value = InstanceInfo(
          dependencyRef: dependencyRef,
        );

        addNode(node);

        break;
    }
  }

  void addNode(Node node) {
    final nodePrev = uNodes.value[node.key];

    if (nodePrev == node) return;

    uNodes.value[node.key] = node;
    uNodes.notify();

    if (node is SlotNode) return;

    if (node.list == null) nodesList.add(node);

    nodePrev?.replaceFor(node);
    uMaxDepth.value = max(uMaxDepth.value, node.uDepth.value);
  }

  void addDependencyNode(Node node) {
    uNodes.value[node.key] = node;
    uNodes.notify();
    if (node.list == null) dependenciesList.add(node);
  }

  void removeNodeByKey(String nodeKey) {
    devtoolsSevices.disposeNodeByKey(nodeKey);

    if (uCurrentNodeKey.value == nodeKey) {
      uCurrentNodeKey.value = null;
    }

    uNodes
      ..value[nodeKey]?.remove()
      ..value.remove(nodeKey)
      ..notify();
  }

  Future<void> selectNode(Node node) async {
    currentNode?.uIsSelected.value = false;
    uCurrentNodeKey.value = node.key;
    node.uIsSelected.value = true;
    node.loadDetails();
  }
}

class RtDevToolsInstanceException implements Exception {
  RtDevToolsInstanceException();

  @override
  String toString() {
    return '''
  RtDevTools is not available.
  Make sure you have initialized RtDevTools before using this service.
  You can do this by calling `Rt.initializeDebugging()` in your app entry point. eg:

  void main() {
    Rt.initializeDebugging();
    runApp(MyApp());
  }
  ''';
  }
}
