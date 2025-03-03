import 'package:devtools_app_shared/service.dart' hide SentinelException;
import 'package:reactter_devtools_extension/src/bases/node.dart';
import 'package:reactter_devtools_extension/src/nodes/dart/closure_node.dart';
import 'package:reactter_devtools_extension/src/nodes/dart/iterable_node.dart';
import 'package:reactter_devtools_extension/src/nodes/dart/key_value_node.dart';
import 'package:reactter_devtools_extension/src/nodes/dart/map_node.dart';
import 'package:reactter_devtools_extension/src/nodes/dart/plain_instance_node.dart';
import 'package:reactter_devtools_extension/src/nodes/dart/record_node.dart';
import 'package:reactter_devtools_extension/src/services/eval_service.dart';
import 'package:vm_service/vm_service.dart';

extension InstanceExt on Instance {
  Future<dynamic> evalValue([
    Disposable? isAlive,
    int? level,
    throwOnError = false,
  ]) async {
    if (level != null && level == 0) return this;

    switch (kind) {
      case InstanceKind.kNull:
        return null;
      case InstanceKind.kString:
        return valueAsString;
      case InstanceKind.kDouble:
        return double.tryParse(valueAsString!);
      case InstanceKind.kInt:
        return int.tryParse(valueAsString!);
      case InstanceKind.kBool:
        return bool.tryParse(valueAsString!);
      case InstanceKind.kMap:
        final dataNode = <dynamic, dynamic>{};

        for (final entry in associations!) {
          final InstanceRef keyRef = entry.key;
          final InstanceRef valueRef = entry.value;
          final key = await keyRef.evalValue(isAlive, null, throwOnError);
          final value = await valueRef.evalValue(
            isAlive,
            level == null ? null : level - 1,
            throwOnError,
          );

          dataNode[key] = value;
        }

        return dataNode;
      case InstanceKind.kList:
        final list = elements!.cast<InstanceRef>();
        final listValues = <dynamic>[];

        for (final e in list) {
          final value = await e.evalValue(
            isAlive,
            level == null ? null : level - 1,
          );
          listValues.add(value);
        }

        return listValues;
      default:
        return valueAsString;
    }
  }

  dynamic evalValueFirstLevel() {
    switch (kind) {
      case InstanceKind.kNull:
        return null;
      case InstanceKind.kString:
        return valueAsString;
      case InstanceKind.kDouble:
        return double.tryParse(valueAsString!);
      case InstanceKind.kInt:
        return int.tryParse(valueAsString!);
      case InstanceKind.kBool:
        return bool.tryParse(valueAsString!);
      default:
        return this;
    }
  }

  String safeValue() {
    switch (kind) {
      case InstanceKind.kNull:
        return 'null';
      case InstanceKind.kString:
        return '"$valueAsString"';
      case InstanceKind.kMap:
        return 'Map{...}(length: ${associations?.length})';
      case InstanceKind.kList:
        return 'List[...](length: ${elements?.length})';
      case InstanceKind.kSet:
        return 'Set{...}(length: ${elements?.length})';
      case InstanceKind.kRecord:
        return 'Record(...)(length: ${fields?.length})';
      default:
        return valueAsString ?? 'unknown';
    }
  }
}

extension InstanceRefExt on InstanceRef {
  Node getNode(String key) {
    return switch (kind) {
      InstanceKind.kNull ||
      InstanceKind.kBool ||
      InstanceKind.kDouble ||
      InstanceKind.kInt =>
        KeyValueNode(
          kind: kind!,
          key: key,
          value: '$valueAsString',
        ),
      InstanceKind.kString => KeyValueNode(
          kind: kind!,
          key: key,
          value: '"$valueAsString"',
        ),
      InstanceKind.kMap => MapNode(key: key, instanceRef: this),
      InstanceKind.kList => IterableNode(
          key: key,
          instanceRef: this,
        ),
      InstanceKind.kSet => IterableNode(
          key: key,
          instanceRef: this,
        ),
      InstanceKind.kRecord => RecordNode(
          key: key,
          instanceRef: this,
        ),
      InstanceKind.kClosure => ClosureNode(
          key: key,
          instanceRef: this,
        ),
      InstanceKind.kPlainInstance => PlainInstanceNode(
          key: key,
          instanceRef: this,
        ),
      _ => PlainInstanceNode(key: key, instanceRef: this),
    };
  }

  Future<Instance?> safeGetInstance([
    Disposable? isAlive,
    throwOnError = false,
  ]) async {
    try {
      final eval = await EvalService.devtoolsEval;
      final instance = await EvalService.evalsQueue.add(
        () => eval.safeGetInstance(this, isAlive),
      );

      return instance;
    } catch (e) {
      if (!throwOnError) return null;
      rethrow;
    }
  }

  Future<dynamic> evalValue([
    Disposable? isAlive,
    int? level,
    throwOnError = false,
  ]) async {
    if (level != null && level == 0) return this;

    try {
      final instance = await safeGetInstance(isAlive, throwOnError);
      return await instance?.evalValue(isAlive, level);
    } catch (e) {
      if (!throwOnError) return null;

      rethrow;
    }
  }

  Future<dynamic> evalValueFirstLevel([Disposable? isAlive]) async {
    final instance = await safeGetInstance(isAlive);
    return instance?.evalValueFirstLevel();
  }

  Future<String> safeValue([Disposable? isAlive]) async {
    final instance = await safeGetInstance(isAlive);
    return instance?.safeValue() ?? 'unknown';
  }
}
