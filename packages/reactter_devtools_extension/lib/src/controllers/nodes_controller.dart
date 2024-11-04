import 'dart:async';
import 'dart:collection';

import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter_reactter/reactter.dart';

import 'package:reactter_devtools_extension/src/data/instance_info.dart';
import 'package:reactter_devtools_extension/src/data/instance_node.dart';
import 'package:reactter_devtools_extension/src/data/slot_node.dart';
import 'package:reactter_devtools_extension/src/data/state_info.dart';
import 'package:reactter_devtools_extension/src/data/tree_list.dart';
import 'package:reactter_devtools_extension/src/interfaces/node.dart';
import 'package:reactter_devtools_extension/src/services/devtools_service.dart';
import 'package:reactter_devtools_extension/src/data/state_node.dart';

class NodesController {
  StreamSubscription? extEventSubscription;

  final devtoolsSevices = DevtoolsService();
  final nodesList = TreeList<INode>();
  final uNodes = UseState(LinkedHashMap<String, INode>());
  final uCurrentNodeKey = UseState<String?>(null);

  INode? get currentNode => uNodes.value[uCurrentNodeKey.value];

  NodesController() {
    init();
  }

  Future<void> init() async {
    await getAllNodes();

    final vmService = await serviceManager.onServiceAvailable;

    extEventSubscription = vmService.onExtensionEvent.listen((event) {
      if (!(event.extensionKind?.startsWith('ext.reactter.') ?? false)) {
        return;
      }

      final eventData = event.extensionData?.data ?? {};

      switch (event.extensionKind) {
        case 'ext.reactter.onStateCreated':
          final String stateKey = eventData['stateKey'];
          addNodeByKey(stateKey);
          break;
        case 'ext.reactter.onStateBound':
          final String instanceKey = eventData['instanceKey'];
          final String stateKey = eventData['stateKey'];
          addNodeByKey(instanceKey);
          addNodeByKey(stateKey);
          break;
        case 'ext.reactter.onStateUnbound':
          final String instanceKey = eventData['instanceKey'];
          final bool isInstanceRemoved = eventData['isInstanceRemoved'];
          if (isInstanceRemoved) removeNodeByKey(instanceKey);
          break;
        case 'ext.reactter.onStateUpdated':
          final String stateKey = eventData['stateKey'];
          if (uCurrentNodeKey.value == stateKey) {
            print('refresh state');
          }
          break;
        case 'ext.reactter.onStateDisposed':
          final String stateKey = eventData['stateKey'];
          final bool isStateRemoved = eventData['isStateRemoved'];
          if (isStateRemoved) removeNodeByKey(stateKey);
          break;
        case 'ext.reactter.onDependencyCreated':
          final String instanceKey = eventData['instanceKey'];
          addNodeByKey(instanceKey);
          break;
        case 'ext.reactter.onDependencyDeleted':
          final String instanceKey = eventData['instanceKey'];
          final bool isInstanceRemoved = eventData['isInstanceRemoved'];
          if (isInstanceRemoved) removeNodeByKey(instanceKey);
      }
    });
  }

  Future<void> getAllNodes() async {
    final nodesInfo = await devtoolsSevices.getAllNodes();
    addNodes(nodesInfo);
  }

  Future<void> addNodeByKey(String nodeKey) async {
    final nodeInfo = await devtoolsSevices.getNodeBykey(nodeKey);
    addNodeByMapInfo(nodeInfo);
    print('addNodeByKey $nodeKey ${nodeInfo['boundInstanceKey']}');
  }

  void addNodes(List<Map> nodesInfo) {
    Rt.batch(() {
      for (final nodeInfo in nodesInfo) {
        addNodeByMapInfo(nodeInfo);
        // print(
        //   "key: ${nodeInfo['key']}, label: ${nodeInfo['debugLabel']}, type: ${nodeInfo['type']}, kind: ${nodeInfo['kind']}, boundInstanceKey: ${nodeInfo['boundInstanceKey']}",
        // );
      }
    });
  }

  void addNodeByMapInfo(Map nodeInfo) {
    final kind = nodeInfo['kind'];
    final key = nodeInfo['key'];
    final type = nodeInfo['type'];

    switch (kind) {
      case 'dependency':
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
          label: debugLabel,
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

        node.uInfo.value = InstanceInfo();

        addNode(node);

        break;
    }
  }

  void addNode(INode node) {
    // if (node is SlotNode) {
    //   print("SloteNode(key: ${node.key})");
    // } else if (node is StateNode) {
    //   print("StateNode(key: ${node.key})");
    // } else if (node is InstanceNode) {
    //   print("InstanceNode(key: ${node.key})");
    // } else {
    //   print("Node(key: ${node.key})");
    // }

    final nodePrev = uNodes.value[node.key];

    if (nodePrev == node) return;

    uNodes.value[node.key] = node;
    uNodes.notify();

    nodePrev?.replace(node);

    if (node is SlotNode) return;

    if (node.list == null) nodesList.add(node);
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

  Future<void> selectNode(INode node) async {
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
