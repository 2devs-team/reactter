import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:reactter_lint/src/extensions.dart';
import 'package:reactter_lint/src/types.dart';

/// The `HookLateConvention` class is a DartLint rule that enforces a specific naming convention for
/// hooks.
class HookLateConvention extends DartLintRule {
  const HookLateConvention() : super(code: _code);

  static const _code = LintCode(
    name: "hook_late_convention",
    errorSeverity: ErrorSeverity.WARNING,
    problemMessage: "The '{0}' hook late must be attached an instance.",
    correctionMessage:
        "Try removing 'late' keyword or wrapping the hook using 'Rt.lazyState'.\n"
        "Example: late final myHookLate = Rt.lazyState(() => UseState(0), this);",
  );

  @override
  List<Fix> getFixes() => [_HookLateFix()];

  static whenIsInvalid({
    required CustomLintContext context,
    required Function(Declaration node, Element element) onInvalid,
  }) {
    context.registry.addFieldDeclaration((node) {
      final element = node.fields.variables.first.declaredElement;

      if (element == null) return;

      if (!reactterHookType.isAssignableFromType(element.type)) return;

      if (!element.isLate) return;

      bool checkIsUseLazy(MethodInvocation method) {
        return method.target.toString() == "Reactter" &&
            method.methodName.toString() == "lazyState";
      }

      bool checkIsVariableUseLazy(VariableDeclaration variable) {
        return variable.childEntities.whereType<MethodInvocation>().any(
              checkIsUseLazy,
            );
      }

      final isUseLazy = node.fields.childEntities
          .whereType<VariableDeclaration>()
          .any(checkIsVariableUseLazy);

      if (isUseLazy) return;

      onInvalid(node, element);
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
      onInvalid: (node, element) {
        reporter.reportErrorForElement(code, element, [element.name!]);
      },
    );
  }
}

/// The `_HookLateFix` class is a Dart fix that provides a solution for a specific issue related to late
/// variables.
class _HookLateFix extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    HookLateConvention.whenIsInvalid(
      context: context,
      onInvalid: (node, element) {
        try {
          if (node is! FieldDeclaration) return;

          bool checkIsInstanceCreationExpression(VariableDeclaration variable) {
            return variable.childEntities
                .whereType<InstanceCreationExpression>()
                .isNotEmpty;
          }

          final variable = node.fields.childEntities
              .whereType<VariableDeclaration>()
              .firstWhereOrNull(checkIsInstanceCreationExpression);

          final instanceCreationExpression = variable?.childEntities
              .firstWhereOrNull((child) => child is InstanceCreationExpression);

          if (instanceCreationExpression == null) return;

          final changeBuilder = reporter.createChangeBuilder(
            message: "Wrap with 'Rt.lazyState'.",
            priority: 1,
          );

          changeBuilder.addDartFileEdit((builder) {
            builder.addSimpleReplacement(
              instanceCreationExpression.sourceRange,
              "Rt.lazyState(() => $instanceCreationExpression, this)",
            );
          });
        } catch (e) {
          print(e);
        }
      },
    );
  }
}
