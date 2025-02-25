import 'dart:async';
import 'dart:collection';

import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactter/reactter.dart';
import 'package:reactter_devtools_extension/src/controllers/node_details_controller.dart';
import 'package:reactter_devtools_extension/src/nodes/instance/instance_info.dart';
import 'package:reactter_devtools_extension/src/nodes/instance/instance_node.dart';
import 'package:reactter_devtools_extension/src/constants.dart';
import 'package:reactter_devtools_extension/src/nodes/dependency/dependency_info.dart';
import 'package:reactter_devtools_extension/src/nodes/dependency/dependency_node.dart';
import 'package:reactter_devtools_extension/src/nodes/sentinel_node.dart';
import 'package:reactter_devtools_extension/src/nodes/slot_node.dart';
import 'package:reactter_devtools_extension/src/bases/tree_list.dart';
import 'package:reactter_devtools_extension/src/bases/node.dart';
import 'package:reactter_devtools_extension/src/nodes/state/state_info.dart';
import 'package:reactter_devtools_extension/src/services/devtools_service.dart';
import 'package:reactter_devtools_extension/src/nodes/state/state_node.dart';
import 'package:vm_service/vm_service.dart';

class NodesController {
  StreamSubscription? extEventSubscription;
  final uNodeDetailsController = UseDependency<NodeDetailsController>();
  final devtoolsSevices = DevtoolsService();
  final nodesList = TreeList<Node>();
  final dependenciesList = TreeList<Node>();
  final uNodes = UseState(LinkedHashMap<String, Node>());

  final nodesListViewKey = GlobalKey();
  final dependenciesListViewKey = GlobalKey();

  final nodesListScrollControllerY = ScrollController();
  final dependencyListScrollControllerY = ScrollController();

  NodeDetailsController get nodeDetailsController =>
      uNodeDetailsController.instance!;
  Node? get uCurrentNode => nodeDetailsController.uCurrentNode.value;
  String? get currentNodeKey => uCurrentNode?.key;

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
          addNodeByData(state);
          break;
        case 'ext.reactter.onStateBound':
          final Map<String, dynamic> state = eventData['state'];
          final Map<String, dynamic> instance = eventData['instance'];
          addNodeByData(state);
          addNodeByData(instance);
          break;
        case 'ext.reactter.onStateUnbound':
          final String instanceKey = eventData['instanceKey'];
          final bool isInstanceRemoved = eventData['isInstanceRemoved'];
          if (isInstanceRemoved) removeNodeByKey(instanceKey);
          break;
        case 'ext.reactter.onStateUpdated':
          final String stateKey = eventData['stateKey'];
          if (currentNodeKey == stateKey) nodeDetailsController.reloadDetails();
          break;
        case 'ext.reactter.onStateDisposed':
          final String stateKey = eventData['stateKey'];
          final bool isStateRemoved = eventData['isStateRemoved'];
          if (isStateRemoved) removeNodeByKey(stateKey);
          break;
        case 'ext.reactter.onDependencyRegistered':
          final Map<String, dynamic> dependency = eventData['dependency'];
          addNodeByData(dependency);
          break;
        case 'ext.reactter.onDependencyCreated':
          final Map<String, dynamic> dependency = eventData['dependency'];
          final Map<String, dynamic> instance = eventData['instance'];
          addNodeByData(dependency);
          addNodeByData(instance);
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
    nodeDetailsController.resetState();
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
    final dataNode = await devtoolsSevices.getNodeBykey(nodeKey, fallback);
    addNodeByData(dataNode);
  }

  void addNodes(List<Map> dataNodes) {
    Rt.batch(() {
      for (final dataNode in dataNodes) {
        addNodeByData(dataNode);
      }
    });
  }

  void addNodeByData(Map dataNode) {
    final kind = dataNode['kind'];
    final key = dataNode['key'];
    final type = dataNode['type'];
    final error = dataNode['error'];
    final dependencyKey = dataNode['dependencyKey'];

    if (error is SentinelException) {
      final nodePrev = uNodes.value[key];
      final node = nodePrev ?? SentinelNode(key: key);

      if (kind == 'dependency') {
        addDependencyNode(node as DependencyNode);
      } else {
        addNode(node as InstanceNode);
      }

      return;
    }

    switch (kind) {
      case NodeKindKey.dependency:
        final nodePrev = uNodes.value[key];
        final node =
            nodePrev is DependencyNode ? nodePrev : DependencyNode(key: key);

        node.uInfo.value = DependencyInfo(
          node,
          type: dataNode['type'],
          mode: dataNode['mode'],
          identify: dataNode['id'],
        );
        node.uIsExpanded.value = true;

        addDependencyNode(node);
        break;
      case NodeKindKey.instance:
        final nodePrev = uNodes.value[key];
        final node =
            nodePrev is InstanceNode ? nodePrev : InstanceNode(key: key);

        node.uInfo.value = InstanceInfo(
          node,
          type: type,
          identityHashCode: key,
          dependencyKey: dependencyKey,
        );
        node.uIsExpanded.value = true;

        addNode(node);

        break;
      case NodeKindKey.state:
      case NodeKindKey.hook:
      case NodeKindKey.signal:
        final nodePrev = uNodes.value[key];
        final node = nodePrev is StateNode ? nodePrev : StateNode(key: key);

        final debugLabel = dataNode['debugLabel'];
        final boundInstanceKey = dataNode['boundInstanceKey'];

        node.uInfo.value = StateInfo(
          node,
          nodeKind: NodeKind.getKind(kind),
          type: type,
          identify: debugLabel,
          identityHashCode: key,
          boundInstanceKey: boundInstanceKey,
          dependencyKey: dependencyKey,
        );
        node.uIsExpanded.value = true;

        if (boundInstanceKey != null) {
          final boundInstanceNodePrev = uNodes.value[boundInstanceKey];
          final boundInstanceNode =
              boundInstanceNodePrev ?? SlotNode(key: boundInstanceKey);

          addNode(boundInstanceNode);

          boundInstanceNode.addChild(node);
        }

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

    if (node.list == null) {
      nodesList.add(node);
    }

    nodePrev?.replaceFor(node);
  }

  void addDependencyNode(DependencyNode node) {
    uNodes.value[node.key] = node;
    uNodes.notify();
    if (node.list == null) dependenciesList.add(node);
  }

  void removeNodeByKey(String nodeKey) {
    devtoolsSevices.disposeNodeByKey(nodeKey);

    if (currentNodeKey == nodeKey) {
      nodeDetailsController.resetState();
    }

    uNodes
      ..value[nodeKey]?.remove()
      ..value.remove(nodeKey)
      ..notify();
  }

  Future<void> selectNode(Node node) async {
    if (uCurrentNode != node) {
      uCurrentNode?.uIsSelected.value = false;
      node.uIsSelected.value = true;
    }

    nodeDetailsController.loadDetails(node);
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
