import 'package:flutter_reactter/reactter.dart';
import 'package:reactter_devtools_extension/src/bases/node.dart';
import 'package:reactter_devtools_extension/src/bases/node_info.dart';
import 'package:vm_service/vm_service.dart';

abstract base class AsyncNode<I extends NodeInfo> extends Node<I> {
  final InstanceRef instanceRef;
  final uIsLoading = UseState(false);

  AsyncNode({
    required super.key,
    required this.instanceRef,
    required super.kind,
  });

  Future<I?> getNodeInfo();

  Future<void> loadNodeInfo() async {
    await Rt.batch(() async {
      uIsLoading.value = true;
      uInfo.value = await getNodeInfo();
      uIsLoading.value = false;
    });
  }

  @override
  Future<void> loadNode() async {
    await Future.wait([
      super.loadNode(),
      loadNodeInfo(),
    ]);
  }
}
