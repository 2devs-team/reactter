import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:reactter_lint/src/types.dart';

class RtStateLateConvention extends DartLintRule {
  const RtStateLateConvention() : super(code: _code);

  static const _code = LintCode(
    name: "rt_state_late_convention",
    errorSeverity: ErrorSeverity.WARNING,
    problemMessage: "The '{0}' state late must be attached an instance.",
    correctionMessage:
        "Try removing 'late' keyword or wrapping the state using 'Rt.lazyState'.\n"
        "Example: late final myStateLate = Rt.lazyState(() => UseState(0), this);",
  );

  @override
  List<Fix> getFixes() => [_RtStateLateFix()];

  static whenIsInvalid({
    required CustomLintContext context,
    required Function(FieldDeclaration node) onInvalid,
  }) {
    context.registry.addFieldDeclaration((node) {
      final variable = node.fields.variables.first;
      final element = variable.declaredElement;

      if (element == null ||
          !element.isLate ||
          !rtStateType.isAssignableFromType(element.type)) {
        return;
      }

      final initializer = variable.initializer?.unParenthesized;

      if (initializer is! MethodInvocation) return onInvalid(node);

      final targetType = initializer.realTarget?.staticType;
      final methodName = initializer.methodName.staticElement;
      final isLazyState = targetType != null &&
          methodName != null &&
          rtInterface.isAssignableFromType(targetType) &&
          lazyStateType.isAssignableFrom(methodName);

      if (isLazyState) return;

      onInvalid(node);
    });
  }

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    whenIsInvalid(
      context: context,
      onInvalid: (node) {
        final variable = node.fields.variables.first;
        final initializer = variable.initializer?.unParenthesized;

        if (initializer == null) return;

        reporter
            .reportErrorForNode(code, initializer, [initializer.toString()]);
      },
    );
  }
}

class _RtStateLateFix extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    RtStateLateConvention.whenIsInvalid(
      context: context,
      onInvalid: (node) {
        try {
          final variable = node.fields.variables.first;
          final initializer = variable.initializer?.unParenthesized;

          if (initializer == null) return;

          final changeBuilder = reporter.createChangeBuilder(
            message: "Wrap with 'Rt.lazyState'.",
            priority: 1,
          );

          changeBuilder.addDartFileEdit((builder) {
            builder.addSimpleReplacement(
              initializer.sourceRange,
              "Rt.lazyState(() => $initializer, this)",
            );
          });
        } catch (e) {
          print(e);
        }
      },
    );
  }
}
