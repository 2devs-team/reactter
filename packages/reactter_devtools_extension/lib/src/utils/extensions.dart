import 'package:devtools_app_shared/service.dart';
import 'package:reactter_devtools_extension/src/services/eval_service.dart';
import 'package:vm_service/vm_service.dart';

extension InstanceExt on Instance {
  Future<dynamic> evalValue([Disposable? isAlive]) async {
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
        final nodeInfo = <dynamic, dynamic>{};

        for (final entry in associations!) {
          final InstanceRef keyRef = entry.key;
          final InstanceRef valueRef = entry.value;

          nodeInfo[await keyRef.evalValue(isAlive)] =
              await valueRef.evalValue(isAlive);
        }

        return nodeInfo;
      case InstanceKind.kList:
        final list = elements!.cast<InstanceRef>();
        final listValues = <dynamic>[];

        for (final e in list) {
          final value = await e.evalValue(isAlive);
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
        return '{...}';
      case InstanceKind.kList:
        return '[...]';
      default:
        return valueAsString ?? 'unknown';
    }
  }
}

extension InstanceRefExt on InstanceRef {
  Future<Instance?> safeGetInstance([Disposable? isAlive]) async {
    try {
      final eval = await EvalService.devtoolsEval;

      final instance = await EvalService.evalsQueue.add(
        () => eval.safeGetInstance(this, isAlive),
      );

      return instance;
    } catch (e) {
      print('safeGetInstance error: $e');
      return null;
    }
  }

  Future<dynamic> evalValue([Disposable? isAlive]) async {
    final instance = await safeGetInstance(isAlive);
    return await instance?.evalValue(isAlive);
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
