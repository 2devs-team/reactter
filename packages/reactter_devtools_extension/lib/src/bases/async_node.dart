import 'dart:async';

import 'package:flutter_reactter/reactter.dart';
import 'package:reactter_devtools_extension/src/bases/node.dart';
import 'package:reactter_devtools_extension/src/bases/node_info.dart';
import 'package:vm_service/vm_service.dart';

abstract base class AsyncNode<I extends NodeInfo> extends Node<I> {
  bool _isValueUpdating = false;
  FutureOr<void>? _futureLoadNode;

  InstanceRef? _lastInstanceRef;
  InstanceRef _instanceRef;
  InstanceRef get instanceRef => _instanceRef;

  final uNeedToLoadNode = UseState(true);
  final uIsLoading = UseState(false);

  AsyncNode({
    required super.key,
    required InstanceRef instanceRef,
  })  : _instanceRef = instanceRef,
        super(kind: instanceRef.kind!);

  Future<I?> getNodeInfo();

  Future<void> loadNodeInfo() async {
    await Rt.batch(() async {
      uInfo.value = await getNodeInfo();
    });
  }

  @override
  Future<void> loadNode() async {
    if (_futureLoadNode != null) return _futureLoadNode;

    await (_futureLoadNode = Rt.batch(() async {
      uIsLoading.value = true;
      try {
        await Future.wait([
          loadNodeInfo(),
          super.loadNode(),
        ]);
      } catch (e) {
        print(e);
      }
      _isValueUpdating = false;
      uNeedToLoadNode.value = false;
      uIsLoading.value = false;
    }));

    if (_lastInstanceRef != null && _instanceRef != _lastInstanceRef) {
      reloadNode();
    }
  }

  Future<void> updateInstanceRef(InstanceRef instanceRef) async {
    _lastInstanceRef = instanceRef;

    if (_isValueUpdating) return;

    _isValueUpdating = true;

    if (_futureLoadNode != null) await _futureLoadNode;

    reloadNode();
  }

  void reloadNode() {
    _instanceRef = _lastInstanceRef!;
    _futureLoadNode = null;
    uNeedToLoadNode.value = true;
  }
}
