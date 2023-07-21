import 'package:analyzer/dart/ast/ast.dart';
import 'package:reactter_lint/src/consts.dart';

bool isHookRegister(Declaration node) {
  if (node is FieldDeclaration) {
    final name = node.fields.variables.first.name.toString();
    return name == HOOK_REGISTER_VAR;
  }

  if (node is MethodDeclaration) {
    return node.name.toString() == HOOK_REGISTER_VAR;
  }

  return false;
}
