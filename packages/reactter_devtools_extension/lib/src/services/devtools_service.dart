import 'package:devtools_app_shared/service.dart';
import 'package:reactter_devtools_extension/src/services/eval_service.dart';
import 'package:reactter_devtools_extension/src/utils/extensions.dart';
import 'package:vm_service/vm_service.dart';

class DevtoolsService {
  static final _nodesDisposables = <String, Disposable>{};

  Future<List<Map>> getAllNodes({
    int page = 0,
    int pageSize = 20,
  }) async {
    final eval = await EvalService.devtoolsEval;
    final isAlive = Disposable();

    final pageNodes = await EvalService.evalsQueue.add(
      () => eval.evalInstance(
        'RtDevTools._instance?.getNodes($page, $pageSize)',
        isAlive: isAlive,
      ),
    );

    if (pageNodes.kind == InstanceKind.kNull) return [];

    final Map pageInfo = await pageNodes.evalValue(isAlive);
    final totalPages = pageInfo['totalPages'] as int;
    final nodeInfos = (pageInfo['nodes'] as List).cast<Map>();

    if (page >= totalPages - 1) return nodeInfos;

    final nextNodeInfos = await getAllNodes(page: page + 1, pageSize: pageSize);

    return nodeInfos + nextNodeInfos;
  }

  Future<Map> getNodeBykey(String nodeKey) async {
    final eval = await EvalService.devtoolsEval;

    final isAlive = _nodesDisposables.putIfAbsent(nodeKey, () => Disposable());

    final nodeInst = await EvalService.evalsQueue.add(
      () => eval.evalInstance(
        'RtDevTools._instance?._nodesByKey["$nodeKey"]?.toJson()',
        isAlive: isAlive,
      ),
    );

    if (nodeInst.kind == InstanceKind.kNull) return {};

    assert(nodeInst.kind == InstanceKind.kMap);

    return await nodeInst.evalValue(isAlive);
  }

  void disposeNodeByKey(String nodeKey) {
    _nodesDisposables.remove(nodeKey)?.dispose();
  }
}
