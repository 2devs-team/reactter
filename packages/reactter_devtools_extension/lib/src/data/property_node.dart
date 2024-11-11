import 'dart:async';
import 'dart:collection';

import 'package:devtools_app_shared/service.dart';

import 'package:flutter_reactter/reactter.dart';
import 'package:reactter_devtools_extension/src/data/tree_node.dart';
import 'package:reactter_devtools_extension/src/services/eval_service.dart';
import 'package:reactter_devtools_extension/src/utils/extensions.dart';
import 'package:vm_service/vm_service.dart';

const _kMaxValueLength = 50;

base class PropertyNode extends TreeNode<PropertyNode> {
  final String key;

  InstanceRef _valueRef;
  InstanceRef get valueRef => _valueRef;

  Disposable? _isAlive;
  bool _isResolved = false;
  bool _isValueUpdating = false;
  final LinkedHashMap<String, PropertyNode> _childNodeRefs =
      LinkedHashMap<String, PropertyNode>();

  final uValueFuture = UseState<FutureOr<String?>?>(null);
  final uValue = UseState<String?>(null);
  final uIsLoading = UseState(false);
  final uInstanceInfo = UseState<Map<String, dynamic>?>(null);

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

  Future<void> updateValueRef(InstanceRef valueRef) async {
    if (uValueFuture.value == null || _isValueUpdating) return;

    _isValueUpdating = true;

    await uValueFuture.value;

    uValueFuture.value = null;
    _valueRef = valueRef;
    _isResolved = false;
    uIsLoading.value = false;
  }

  Future<String?> getValueAsync() async {
    if (uValueFuture.value != null) return uValueFuture.value!;
    if (_isResolved) return Future.value(uValue.value);
    if (uIsLoading.value) return Future.value(uValue.value);

    try {
      return uValueFuture.value = Rt.batch<String?>(() async {
        uIsLoading.value = true;
        _isAlive = Disposable();
        String? value;

        try {
          switch (valueRef.kind) {
            case InstanceKind.kList:
              value = await resolveValueByList();
              break;
            case InstanceKind.kSet:
              value = await resolveValueBySet();
              break;
            case InstanceKind.kMap:
              value = await resolveValueByMap();
              break;
            case InstanceKind.kRecord:
              value = await resolveValueByRecord();
              break;
            case InstanceKind.kPlainInstance:
              value = await resolveValueByPlainInstance();
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

        uIsLoading.value = false;
        uValue.value = value;

        return value;
      });
    } finally {
      _isResolved = true;
      _isValueUpdating = false;
    }
  }

  Future<String?> resolveValueByList() async {
    assert(valueRef.kind == InstanceKind.kList);

    final instance = await valueRef.safeGetInstance(_isAlive);
    final elements = instance?.elements?.cast<InstanceRef>() ?? [];
    final SplayTreeMap<String, InstanceRef> children = SplayTreeMap(
      (a, b) => int.parse(a).compareTo(int.parse(b)),
    );

    for (var i = 0; i < elements.length; i++) {
      children[i.toString()] = elements[i];
    }

    await addChildren(children);

    return await resolveValueByChildren(
      buildValue: (key, value) => "$value",
      prefix: '[',
      suffix: ']',
    );
  }

  Future<String?> resolveValueBySet() async {
    assert(valueRef.kind == InstanceKind.kSet);

    final instance = await valueRef.safeGetInstance(_isAlive);
    final elements = instance?.elements?.cast<InstanceRef>() ?? [];
    final SplayTreeMap<String, InstanceRef> children = SplayTreeMap(
      (a, b) => int.parse(a).compareTo(int.parse(b)),
    );

    for (var i = 0; i < elements.length; i++) {
      children[i.toString()] = elements[i];
    }

    await addChildren(children);

    return await resolveValueByChildren(
      buildValue: (key, value) => '$value',
      prefix: '{',
      suffix: '}',
    );
  }

  Future<String?> resolveValueByMap() async {
    assert(valueRef.kind == InstanceKind.kMap);

    final instance = await valueRef.safeGetInstance(_isAlive);
    final associations = instance?.associations?.cast<MapAssociation>() ?? [];
    final SplayTreeMap<String, InstanceRef> children = SplayTreeMap();

    for (final entry in associations) {
      final keyRef = entry.key as InstanceRef;
      final key = await keyRef.evalValueFirstLevel(_isAlive);

      children[key.toString()] = entry.value;
    }

    await addChildren(children);

    return await resolveValueByChildren(
      buildValue: (key, value) => '$key: $value',
      prefix: '{',
      suffix: '}',
    );
  }

  Future<String?> resolveValueByRecord() async {
    assert(valueRef.kind == InstanceKind.kRecord);

    final instance = await valueRef.safeGetInstance(_isAlive);
    final fields = instance?.fields?.cast<BoundField>() ?? [];
    final SplayTreeMap<String, InstanceRef> children = SplayTreeMap();

    for (final field in fields) {
      children[field.name.toString()] = field.value as InstanceRef;
    }

    await addChildren(children);

    return await resolveValueByChildren(
      buildValue: (key, value) => '$key: $value',
      prefix: '(',
      suffix: ')',
    );
  }

  Future<void> addChildren(SplayTreeMap<String, InstanceRef> children) async {
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
        childNode.updateValueRef(child.value);
      } else {
        addChild(childNode);
      }
    }

    for (final childKey in childrenToRemove) {
      final childNode = _childNodeRefs.remove(childKey);
      childNode?.remove();
    }
  }

  Future<String?> resolveValueByChildren({
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

  Future<String?> resolveValueByPlainInstance() async {
    assert(valueRef.kind == InstanceKind.kPlainInstance);

    final eval = await EvalService.devtoolsEval;
    final valueInfo = await EvalService.evalsQueue.add(
      () => eval.evalInstance(
        'RtDevTools._instance?.getPlainInstanceInfo(value)',
        isAlive: _isAlive,
        scope: {'value': valueRef.id!},
      ),
    );

    final instance = await valueRef.safeGetInstance(_isAlive);
    final fields = instance?.fields?.cast<BoundField>() ?? [];
    final SplayTreeMap<String, InstanceRef> children = SplayTreeMap();

    for (final field in fields) {
      if (field.value is InstanceRef) {
        children[field.name] = field.value as InstanceRef;
      }
    }

    await addChildren(children);

    if (valueInfo.kind != InstanceKind.kMap) return null;

    final valueInfoMap = await valueInfo.evalValue(_isAlive);

    if (valueInfoMap is! Map) return null;

    uInstanceInfo.value = valueInfoMap.cast<String, dynamic>();

    final String key = valueInfoMap['key'];
    final String type = valueInfoMap['type'];
    final String? id = valueInfoMap['id'];
    final String? debugLabel = valueInfoMap['debugLabel'];
    final String? idOrDebugLabel = id ?? debugLabel;

    return idOrDebugLabel != null
        ? "$type($idOrDebugLabel) #$key"
        : "$type #$key";
  }
}
