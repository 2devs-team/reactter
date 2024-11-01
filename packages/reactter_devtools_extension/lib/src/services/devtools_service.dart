import 'package:devtools_app_shared/service.dart';
import 'package:queue/queue.dart';
import 'package:reactter_devtools_extension/src/services/eval_service.dart';
import 'package:vm_service/vm_service.dart';

class DevtoolsService {
  static final evalsQueue = Queue(parallel: 5);
  static final _nodesDisposables = <String, Disposable>{};

  Future<List<Map<String, dynamic>>> getAllNodes({
    int page = 0,
    int pageSize = 20,
  }) async {
    final eval = await EvalService.devtoolsEval;
    final isAlive = Disposable();

    final pageNodes = await evalsQueue.add(
      () => eval.evalInstance(
        'RtDevTools._instance?.getNodes($page, $pageSize)',
        isAlive: isAlive,
      ),
    );

    assert(pageNodes.kind == InstanceKind.kMap);

    final pageInfo = {};

    for (final entry in pageNodes.associations!) {
      final key = entry.key!.valueAsString!;
      final valueRef = entry.value!;

      if (valueRef.kind == InstanceKind.kString) {
        pageInfo[key] = valueRef.valueAsString;
      } else if (valueRef.kind == InstanceKind.kInt) {
        pageInfo[key] = int.tryParse(valueRef.valueAsString);
      } else {
        pageInfo[key] = valueRef;
      }
    }

    final totalPages = pageInfo['totalPages'] as int;
    final nodesInst = pageInfo['nodes'] as InstanceRef;
    final nodes = await eval.safeGetInstance(nodesInst, isAlive);

    assert(nodes.kind == InstanceKind.kList);

    final nodeRefs = nodes.elements!.cast<InstanceRef>();
    final nodeInfos = <Map<String, dynamic>>[];

    for (final nodeRef in nodeRefs) {
      final nodeInst = await eval.safeGetInstance(nodeRef, isAlive);

      nodeInfos.add(await getNodeInfo(nodeInst));
    }

    if (page >= totalPages - 1) return nodeInfos;

    final nextNodeInfos = await getAllNodes(page: page + 1, pageSize: pageSize);

    return nodeInfos + nextNodeInfos;
  }

  Future<Map<String, dynamic>> getNodeBykey(String nodeKey) async {
    final eval = await EvalService.devtoolsEval;

    final isAlive = _nodesDisposables.putIfAbsent(nodeKey, () => Disposable());

    final nodeInst = await evalsQueue.add(
      () => eval.evalInstance(
        'RtDevTools._instance?._nodesByKey["$nodeKey"]?.toJson()',
        isAlive: isAlive,
      ),
    );

    if (nodeInst.kind == InstanceKind.kNull) return {};

    assert(nodeInst.kind == InstanceKind.kMap);

    return getNodeInfo(nodeInst);
  }

  void disposeNodeByKey(String nodeKey) {
    _nodesDisposables.remove(nodeKey)?.dispose();
  }

  Future<Map<String, dynamic>> getNodeInfo(Instance nodeInst) async {
    final nodeInfo = <String, dynamic>{};

    for (final entry in nodeInst.associations!) {
      final key = entry.key!.valueAsString!;
      final valueRef = entry.value!;

      nodeInfo[key] = await getValueOfInstanceRef(valueRef);
    }

    return nodeInfo;
  }

  Future<dynamic> getValueOfInstanceRef(InstanceRef instanceRef) async {
    final eval = await EvalService.devtoolsEval;
    final isAlive = Disposable();

    final instance = await evalsQueue.add(
      () => eval.safeGetInstance(instanceRef, isAlive),
    );

    return await getValueOfInstance(instance);
  }

  Future<dynamic> getValueOfInstance(Instance instance) async {
    switch (instance.kind) {
      case InstanceKind.kNull:
        return null;
      case InstanceKind.kString:
        return instance.valueAsString;
      case InstanceKind.kMap:
        return await getNodeInfo(instance);
      case InstanceKind.kList:
        final list = instance.elements!.cast<InstanceRef>();
        final listValues = <dynamic>[];

        for (final e in list) {
          listValues.add(await getValueOfInstanceRef(e));
        }

        return listValues;
      default:
        return instance.valueAsString;
    }
  }
}
