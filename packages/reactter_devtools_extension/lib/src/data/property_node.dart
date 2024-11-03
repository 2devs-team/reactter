import 'package:devtools_app_shared/service.dart';
import 'package:flutter_reactter/reactter.dart';
import 'package:reactter_devtools_extension/src/data/constants.dart';
import 'package:reactter_devtools_extension/src/data/tree_node.dart';
import 'package:reactter_devtools_extension/src/services/eval_service.dart';
import 'package:reactter_devtools_extension/src/utils/extensions.dart';
import 'package:vm_service/vm_service.dart';

const _kMaxValueLength = 80;

base class PropertyNode extends TreeNode<PropertyNode> {
  final String key;
  final InstanceRef valueRef;
  final instanceInfo = UseState<Map<String, dynamic>?>(null);

  final uIsLoading = UseState(false);

  String? _value;
  String? get value {
    if (_value == null) _loadValueAsync();

    return _value;
  }

  PropertyNode._({
    required this.key,
    required this.valueRef,
  }) {
    uIsExpanded.value = false;
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

  Future<void> _loadValueAsync() async {
    if (uIsLoading.value) return;

    uIsLoading.value = true;

    await Rt.batchAsync(() async {
      try {
        switch (valueRef.kind) {
          case InstanceKind.kNull:
            _value = 'null';
            break;
          case InstanceKind.kString:
            _value = '"${valueRef.valueAsString}"';
            break;
          case InstanceKind.kMap:
            await _resolveValueByMap();
            break;
          case InstanceKind.kList:
            await _resolveValueByList();
            break;
          case InstanceKind.kPlainInstance:
            await _resolveValueByPlainInstance();
            break;
          default:
            _value = valueRef.valueAsString;
            break;
        }
      } catch (e) {
        _value = 'Error: $e';
      } finally {
        uIsLoading.value = false;
        notify();
      }
    });
  }

  Future<void> _resolveValueByList() async {
    assert(valueRef.kind == InstanceKind.kList);

    try {
      final isAlive = Disposable();
      final instance = await valueRef.safeGetInstance(isAlive);
      final elements = instance?.elements?.cast<InstanceRef>();

      _value = '[...]';

      if (elements?.isEmpty ?? true) return;

      for (var i = 0; i < elements!.length; i++) {
        addChild(PropertyNode(
          key: i.toString(),
          valueRef: elements[i],
        ));
      }

      await _resolveValueByChildren(
        buildValue: (node) => '${node.value}',
        prefix: '[',
        suffix: ']',
      );
    } catch (e) {
      print('_resolveValueByList error: $e');
    } finally {
      notify();
    }
  }

  Future<void> _resolveValueByMap() async {
    assert(valueRef.kind == InstanceKind.kMap);

    try {
      final isAlive = Disposable();
      final instance = await valueRef.safeGetInstance(isAlive);
      final associations = instance?.associations;

      _value = '{...}';

      if (associations == null) return;

      for (final entry in associations) {
        final InstanceRef keyRef = entry.key;
        final InstanceRef valueRef = entry.value;

        final key = await keyRef.evalValueFirstLevel(isAlive);

        addChild(PropertyNode(
          key: key.toString(),
          valueRef: valueRef,
        ));
      }

      await _resolveValueByChildren(
        buildValue: (node) => '${node.key}: ${node.value}',
        prefix: '{',
        suffix: '}',
      );
    } catch (e) {
      print('_resolveMap error: $e');
    } finally {
      notify();
    }

    return;
  }

  Future<void> _resolveValueByChildren({
    required String Function(PropertyNode node) buildValue,
    String prefix = '{',
    String suffix = '}',
  }) async {
    final children = uChildren.value.toList();

    _value = '$prefix...$suffix';

    if (children.isEmpty) return;

    final childrenValueBuffer = StringBuffer();
    var isFull = true;

    for (var i = 0; i < children.length; i++) {
      final child = children[i];
      final isLast = i == children.length - 1;
      await child._loadValueAsync();

      childrenValueBuffer.write("${buildValue(child)}${isLast ? '' : ', '}");

      if (childrenValueBuffer.length > _kMaxValueLength) {
        isFull = isLast;
        break;
      }
    }
    final moreEllipsis = isFull ? '' : ', ...';
    final maxValueBufferLength =
        _kMaxValueLength - prefix.length - moreEllipsis.length - suffix.length;
    final childrenValue = childrenValueBuffer.toString();
    final shouldBeCutted = childrenValue.length > maxValueBufferLength;
    final cuttedEllipsis = shouldBeCutted ? '...' : '';
    final childrenValueCutted = shouldBeCutted
        ? childrenValue.substring(
            0,
            maxValueBufferLength - cuttedEllipsis.length,
          )
        : childrenValue;

    _value = "$prefix$childrenValueCutted$cuttedEllipsis$moreEllipsis$suffix";
  }

  Future<void> _resolveValueByPlainInstance() async {
    assert(valueRef.kind == InstanceKind.kPlainInstance);

    try {
      final isAlive = Disposable();
      final eval = await EvalService.devtoolsEval;
      final valueInfo = await EvalService.evalsQueue.add(
        () => eval.evalInstance(
          'RtDevTools._instance?.getPlainInstanceInfo(value)',
          isAlive: isAlive,
          scope: {'value': valueRef.id!},
        ),
      );

      if (valueInfo.kind != InstanceKind.kMap) return;

      final valueInfoMap = await valueInfo.evalValue(isAlive);

      if (valueInfoMap is! Map) return;

      instanceInfo.value = valueInfoMap.cast<String, dynamic>();

      final String kind = valueInfoMap['kind'];
      final String key = valueInfoMap['key'];
      final String type = valueInfoMap['type'];

      switch (NodeType.fromString(kind)) {
        case NodeType.state:
          final String? debugLabel = valueInfoMap['debugLabel'];

          if (debugLabel?.isNotEmpty ?? false) {
            _value = "$type($debugLabel)#$key";
            break;
          }
        case NodeType.dependency:
          final String? id = valueInfoMap['id'];

          if (id?.isNotEmpty ?? false) {
            _value = "$type($id)#$key";
            break;
          }
        default:
          _value = "$type#$key";
          break;
      }
    } catch (e) {
      print('loadValueFromPlainInstance error: $e');
    } finally {
      notify();
    }

    return;
  }
}
