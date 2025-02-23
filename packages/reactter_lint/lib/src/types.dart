import 'package:custom_lint_builder/custom_lint_builder.dart';

final rtStateType = TypeChecker.fromName('RtState', packageName: 'reactter');
final iAutoRegisterStateType =
    TypeChecker.fromName('IAutoRegisterState', packageName: 'reactter');
final rtHookType = TypeChecker.fromName('RtHook', packageName: 'reactter');
final hookRegisterType =
    TypeChecker.fromName('HookRegister', packageName: 'reactter');

final reactterType = TypeChecker.fromPackage('reactter');

final rtInterface =
    TypeChecker.fromName('RtInterface', packageName: 'reactter');
final registerStateType =
    TypeChecker.fromName('registerState', packageName: 'reactter');
final lazyStateType =
    TypeChecker.fromName('lazyState', packageName: 'reactter');
