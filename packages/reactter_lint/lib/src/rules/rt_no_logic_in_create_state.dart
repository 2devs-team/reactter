import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:reactter_lint/src/extensions.dart';
import 'package:reactter_lint/src/types.dart';

class RtNoLogicInRegisterState extends DartLintRule {
  const RtNoLogicInRegisterState() : super(code: _code);

  static const _code = LintCode(
    name: "rt_no_logic_in_create_state",
    errorSeverity: ErrorSeverity.WARNING,
    problemMessage: "Don't put logic in `registerState` method.",
    correctionMessage: "Try moving the logic out of `registerState` method.",
  );

  static whenIsInvalid({
    required LintCode code,
    required CustomLintContext context,
    required Function(MethodInvocation node) onInvalid,
  }) {
    context.registry.addMethodInvocation((node) {
      final targetType = node.realTarget?.staticType;
      final methodName = node.methodName.staticElement;

      if (targetType == null || methodName == null) return;
      if (!rtInterface.isAssignableFromType(targetType)) return;
      if (!registerStateType.isAssignableFrom(methodName)) return;
      final functionArg = _getFunctionFromArgument(node);

      if (functionArg == null || functionArg.body is! BlockFunctionBody) return;

      final functionBody = functionArg.body as BlockFunctionBody;
      final statements = functionBody.block.statements;

      if (statements.length > 1) return onInvalid(node);
      if (statements.firstOrNull is! ReturnStatement) return onInvalid(node);
    });
  }

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    whenIsInvalid(
      code: code,
      context: context,
      onInvalid: (node) {
        reporter.reportErrorForNode(code, node, [node.toString()]);
      },
    );
  }

  static FunctionExpression? _getFunctionFromArgument(MethodInvocation node) {
    return node.argumentList.arguments
        .whereType<FunctionExpression>()
        .firstOrNull;
  }
}
