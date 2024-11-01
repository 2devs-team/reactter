import 'package:devtools_app_shared/service.dart';
import 'package:flutter_reactter/reactter.dart';
import 'package:reactter_devtools_extension/src/data/tree_node.dart';
import 'package:reactter_devtools_extension/src/services/eval_service.dart';
import 'package:vm_service/vm_service.dart';

base class PropertyNode extends TreeNode<PropertyNode> {
  final String key;
  final InstanceRef valueRef;

  String? _value;
  String? get value => _value;

  PropertyNode._({
    required this.key,
    required this.valueRef,
  }) {
    if (valueRef.kind == InstanceKind.kString) {
      _value = '"${valueRef.valueAsString}"';
    } else {
      _value = valueRef.valueAsString;
    }

    if (_value == null) {
      _loadValue();
    }
  }

  factory PropertyNode({
    PropertyNode? parent,
    required String key,
    required InstanceRef valueRef,
  }) {
    return Rt.createState(
      () => PropertyNode._(
        key: key,
        valueRef: valueRef,
      ),
    );
  }

  Future<void> _loadValue() async {
    final eval = await EvalService.devtoolsEval;
    final isAlive = Disposable();

    final value = await eval.evalInstance(
      'RtDevTools._instance?.getPropertyValue(value)',
      isAlive: isAlive,
      scope: {'value': valueRef.id!},
    );

    final isIterable = await eval.evalInstance(
      'value is Iterable',
      isAlive: isAlive,
      scope: {'value': valueRef.id!},
    );

    print(isIterable);

    _value = value.valueAsString;
    notify();
  }
}
