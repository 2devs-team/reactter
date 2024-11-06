import 'dart:async';
import 'dart:collection';

import 'package:devtools_app_shared/service.dart';
import 'package:flutter_reactter/reactter.dart';
import 'package:reactter_devtools_extension/src/data/constants.dart';
import 'package:reactter_devtools_extension/src/data/tree_node.dart';
import 'package:reactter_devtools_extension/src/services/eval_service.dart';
import 'package:reactter_devtools_extension/src/utils/extensions.dart';
import 'package:vm_service/vm_service.dart';

const _kMaxValueLength = 50;

base class PropertyNode extends TreeNode<PropertyNode> {
  final String key;

  InstanceRef _valueRef;
  InstanceRef get valueRef => _valueRef;
  Disposable? isAlive;
  bool _isResolved = false;

  FutureOr<String?>? _valueFuture;

  final LinkedHashMap<String, PropertyNode> _childNodeRefs =
      LinkedHashMap<String, PropertyNode>();

  final uValue = UseState<String?>(null);
  final uInstanceInfo = UseState<Map<String, dynamic>?>(null);
  final uIsLoading = UseState(false);

  PropertyNode._({
    required this.key,
    required InstanceRef valueRef,
    bool isExpanded = false,
  }) : _valueRef = valueRef {
    uIsExpanded.value = isExpanded;
  }

  factory PropertyNode({
    PropertyNode? parent,
    required String key,
    required InstanceRef valueRef,
    bool isExpanded = false,
  }) {
    return Rt.createState(
      () => PropertyNode._(
        key: key,
        valueRef: valueRef,
        isExpanded: isExpanded,
      ),
    );
  }

  Future<void> reassignValueRef(InstanceRef valueRef) async {
    isAlive?.dispose();
    _isResolved = false;
    _valueRef = valueRef;
    _valueFuture = null;
    uIsLoading.value = false;

    if (list == null) return;

    await getValueAsync();
  }

  Future<String?> getValueAsync() async {
    if (_valueFuture != null) return _valueFuture!;
    if (_isResolved) return Future.value(uValue.value);
    if (uIsLoading.value) return Future.value(uValue.value);

    return _valueFuture = Rt.batch<String?>(() async {
      uIsLoading.value = true;
      isAlive = Disposable();
      String? value;

      try {
        switch (valueRef.kind) {
          case InstanceKind.kList:
            value = await _resolveValueByList();
            break;
          case InstanceKind.kMap:
            value = await _resolveValueByMap();
            break;
          case InstanceKind.kRecord:
            value = await _resolveValueByRecord();
            break;
          case InstanceKind.kSet:
            value = await _resolveValueBySet();
            break;
          case InstanceKind.kPlainInstance:
            value = await _resolveValueByPlainInstance();
            break;
          case InstanceKind.kNull:
            value = 'null';
            uChildren.value.clear();
            break;
          case InstanceKind.kString:
            value = '"${valueRef.valueAsString}"';
            uChildren.value.clear();
            break;
          default:
            value = valueRef.valueAsString;
            uChildren.value.clear();
            break;
        }
      } catch (e) {
        value = null;
      }

      value ??= 'Unknown - Cannot load value';

      _isResolved = true;
      uIsLoading.value = false;
      return uValue.value = value;
    });
  }

  Future<String?> _resolveValueBySet() async {
    assert(valueRef.kind == InstanceKind.kSet);

    final instance = await valueRef.safeGetInstance(isAlive);
    final elements = instance?.elements?.cast<InstanceRef>() ?? [];
    final children = {
      for (var i = 0; i < elements.length; i++) i.toString(): elements[i],
    };

    await _addChildren(children);

    return await _resolveValueByChildren(
      buildValue: (key, value) => '$value',
      prefix: '{',
      suffix: '}',
    );
  }

  Future<String?> _resolveValueByList() async {
    assert(valueRef.kind == InstanceKind.kList);

    final instance = await valueRef.safeGetInstance(isAlive);
    final elements = instance?.elements?.cast<InstanceRef>() ?? [];
    final children = {
      for (var i = 0; i < elements.length; i++) i.toString(): elements[i],
    };

    await _addChildren(children);

    return await _resolveValueByChildren(
      buildValue: (key, value) => "$value",
      prefix: '[',
      suffix: ']',
    );
  }

  Future<String?> _resolveValueByMap() async {
    assert(valueRef.kind == InstanceKind.kMap);

    final instance = await valueRef.safeGetInstance(isAlive);
    final associations = instance?.associations?.cast<MapAssociation>() ?? [];
    final children = <String, InstanceRef>{};

    for (final entry in associations) {
      final keyRef = entry.key as InstanceRef;
      final key = await keyRef.evalValueFirstLevel(isAlive);

      children[key.toString()] = entry.value;
    }

    await _addChildren(children);

    return await _resolveValueByChildren(
      buildValue: (key, value) => '$key: $value',
      prefix: '{',
      suffix: '}',
    );
  }

  Future<String?> _resolveValueByRecord() async {
    assert(valueRef.kind == InstanceKind.kRecord);

    final instance = await valueRef.safeGetInstance(isAlive);
    final fields = instance?.fields?.cast<BoundField>() ?? [];
    final children = {
      for (final field in fields)
        field.name.toString(): field.value as InstanceRef,
    };

    await _addChildren(children);

    return await _resolveValueByChildren(
      buildValue: (key, value) => '$key: $value',
      prefix: '(',
      suffix: ')',
    );
  }

  Future<void> _addChildren(Map<String, InstanceRef> children) async {
    final childrenToRemove = _childNodeRefs.keys.toSet();

    for (final child in children.entries) {
      final isRemoved = childrenToRemove.remove(child.key);
      final childNode = _childNodeRefs.putIfAbsent(
        child.key,
        () => PropertyNode(
          key: child.key,
          valueRef: child.value,
        ),
      );

      if (isRemoved) {
        childNode.reassignValueRef(child.value);
      } else {
        addChild(childNode);
      }
    }

    for (final childKey in childrenToRemove) {
      final childNode = _childNodeRefs.remove(childKey);
      childNode?.remove();
    }
  }

  Future<String?> _resolveValueByChildren({
    required String Function(String key, String? value) buildValue,
    String prefix = '{',
    String suffix = '}',
  }) async {
    final children = uChildren.value.toList();
    final childrenValueBuffer = StringBuffer();
    var isFull = true;

    for (var i = 0; i < children.length; i++) {
      final child = children[i];
      final isLast = i == children.length - 1;
      String? value;

      switch (child.valueRef.kind) {
        case InstanceKind.kMap:
        case InstanceKind.kSet:
          value = '{...}';
          break;
        case InstanceKind.kList:
          value = '[...]';
          break;
        default:
          await child.getValueAsync();
          value = child.uValue.value;
          break;
      }

      childrenValueBuffer.write(
        "${buildValue(child.key, value)}${isLast ? '' : ', '}",
      );

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

    return "$prefix$childrenValueCutted$cuttedEllipsis$moreEllipsis$suffix";
  }

  Future<String?> _resolveValueByPlainInstance() async {
    assert(valueRef.kind == InstanceKind.kPlainInstance);

    final eval = await EvalService.devtoolsEval;
    final valueInfo = await EvalService.evalsQueue.add(
      () => eval.evalInstance(
        'RtDevTools._instance?.getPlainInstanceInfo(value)',
        isAlive: isAlive,
        scope: {'value': valueRef.id!},
      ),
    );

    if (valueInfo.kind != InstanceKind.kMap) return null;

    final valueInfoMap = await valueInfo.evalValue(isAlive);

    if (valueInfoMap is! Map) return null;

    uInstanceInfo.value = valueInfoMap.cast<String, dynamic>();

    final String kind = valueInfoMap['kind'];
    final String key = valueInfoMap['key'];
    final String type = valueInfoMap['type'];
    final String? id = valueInfoMap['id'];
    final String? debugLabel = valueInfoMap['debugLabel'];
    final String? idOrDebugLabel = id ?? debugLabel;

    return idOrDebugLabel != null
        ? "$type($idOrDebugLabel)#$key"
        : "$type#$key";
  }
}
