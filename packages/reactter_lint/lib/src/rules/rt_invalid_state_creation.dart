import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:reactter_lint/src/extensions.dart';
import 'package:reactter_lint/src/types.dart';

class RtInvalidStateCreation extends DartLintRule {
  const RtInvalidStateCreation() : super(code: _code);

  static const _code = LintCode(
    name: "rt_invalid_state_creation",
    errorSeverity: ErrorSeverity.WARNING,
    problemMessage: "The `{0}` state must be create under the Reactter context.",
    correctionMessage: "Use `Rt.createState` method.",
  );

  @override
  List<Fix> getFixes() => [_RtInvalidStateCreationFix()];

  static whenIsInvalid({
    required LintCode code,
    required CustomLintContext context,
    required Function(InstanceCreationExpression node) onInvalid,
  }) {
    context.registry.addInstanceCreationExpression((node) {
      final element = node.constructorName.staticElement;

      if (element == null ||
          element.isFactory ||
          rtHookType.isAssignableFromType(element.returnType) ||
          !rtStateBaseType.isAssignableFromType(element.returnType) ||
          iAutoRegisterStateType.isAssignableFromType(element.returnType)) {
        return;
      }

      final methodInvocation = node.thisOrAncestorOfType<MethodInvocation>();
      final targetType = methodInvocation?.realTarget?.staticType;
      final methodName = methodInvocation?.methodName.staticElement;
      final isCreateState = targetType != null &&
          methodName != null &&
          rtInterface.isAssignableFromType(targetType) &&
          createStateType.isAssignableFrom(methodName);

      if (methodInvocation == null || !isCreateState) return onInvalid(node);

      final functionArg = methodInvocation.argumentList.arguments
          .whereType<FunctionExpression>()
          .firstOrNull;
      final returnFunctionArg = functionArg?.returnExpression;

      if (returnFunctionArg == null) return onInvalid(node);

      bool isEqualReturnExpression;

      if (returnFunctionArg is SimpleIdentifier) {
        isEqualReturnExpression = returnFunctionArg.staticElement == element;
      } else {
        isEqualReturnExpression =
            returnFunctionArg.unParenthesized == node.unParenthesized;
      }

      if (!isEqualReturnExpression) return onInvalid(node);
    });
  }

  bool isUsedCreateStateMethod(Set<AstNode> nodes, FunctionBody body) {
    final returnExpression = body.returnExpression;
    print(
        "RETURN EXPRESSION: $returnExpression, ${returnExpression.runtimeType}");
    if (returnExpression == null) return false;

    if (body is ExpressionFunctionBody) return true;

    if (returnExpression is SimpleIdentifier) {
      final returnElement = returnExpression.staticElement;
      final variableDeclaration =
          nodes.whereType<VariableDeclaration>().firstOrNull;
      final variableElement = variableDeclaration?.declaredElement;

      return returnElement == variableElement;
    }

    return false;
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
}

class _RtInvalidStateCreationFix extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    RtInvalidStateCreation.whenIsInvalid(
      code: RtInvalidStateCreation._code,
      context: context,
      onInvalid: (node) {
        try {
          final changeBuilder = reporter.createChangeBuilder(
            message:
                "Convert '${node.toString()}' to use `Rt.createState` method.",
            priority: 1,
          );

          changeBuilder.addDartFileEdit((builder) {
            builder.addSimpleReplacement(
              node.sourceRange,
              "Rt.createState(() => ${node.toString()})",
            );
          });
        } catch (e) {
          print(e);
        }
      },
    );
  }
}
