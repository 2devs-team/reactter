import 'package:devtools_app_shared/service.dart';
import 'package:devtools_extensions/devtools_extensions.dart';

class EvalService {
  static final devtoolsEval = _getEvalOnDartLibrary(
    'package:reactter/src/devtools.dart',
  );
  static final dartEval = _getEvalOnDartLibrary('dart:io');
}

Future<EvalOnDartLibrary> _getEvalOnDartLibrary(String path) async {
  final vmService = await serviceManager.onServiceAvailable;

  return EvalOnDartLibrary(
    path,
    vmService,
    serviceManager: serviceManager,
  );
}
