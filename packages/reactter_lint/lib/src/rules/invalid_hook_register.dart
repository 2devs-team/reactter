import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:reactter_lint/src/consts.dart';
import 'package:reactter_lint/src/helpers.dart';
import 'package:reactter_lint/src/types.dart';

/// The InvalidHookRegister class is a DartLintRule that detects and reports invalid hook registrations.
class InvalidHookRegister extends DartLintRule {
  const InvalidHookRegister() : super(code: _code);

  static const _code = LintCode(
    name: "invalid_hook_register",
    errorSeverity: ErrorSeverity.ERROR,
    problemMessage:
        "The hook register('$HOOK_REGISTER_VAR' field) must be final only.",
    correctionMessage:
        "Try changing the keyword('get', 'set', 'var') to 'final' keyword.\n"
        "Example: final $HOOK_REGISTER_VAR = RtHook.\$register;",
  );

  @override
  List<Fix> getFixes() => [_HookRegisterFix()];

  static whenIsInvalid({
    required CustomLintContext context,
    required Function(Declaration node, Element element) onInvalid,
  }) {
    context.registry.addClassDeclaration((node) {
      final declaredElement = node.declaredElement;

      if (declaredElement == null) return;

      if (!reactterHookType.isAssignableFrom(declaredElement)) return;

      final hookRegisterNodes = node.members.where(isHookRegister);

      if (hookRegisterNodes.isEmpty) return;

      for (final hookRegisterNode in hookRegisterNodes) {
        final hookRegisterElement = getElementFromDeclaration(hookRegisterNode);

        if (hookRegisterElement is PropertyAccessorElement) {
          onInvalid(hookRegisterNode, hookRegisterElement);
          continue;
        }

        if (hookRegisterElement is FieldElement) {
          if (!hookRegisterElement.isFinal || hookRegisterElement.isLate) {
            onInvalid(hookRegisterNode, hookRegisterElement);
            continue;
          }
        }
      }
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
        reporter.reportErrorForElement(code, element);
      },
    );
  }
}

/// The `_HookRegisterFix` class is a Dart fix that performs a specific action related to hook
/// registration.
class _HookRegisterFix extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    InvalidHookRegister.whenIsInvalid(
      context: context,
      onInvalid: (node, element) {
        try {
          if (element is FieldElement) {
            final fieldNode = node as FieldDeclaration;
            final offset = fieldNode.fields.lateKeyword?.offset ??
                fieldNode.fields.keyword?.offset ??
                fieldNode.fields.type!.offset;
            final length =
                fieldNode.fields.variables.first.name.offset - offset - 1;

            final changeBuilder = reporter.createChangeBuilder(
              message: "Convert '$HOOK_REGISTER_VAR' to final variable.",
              priority: 1,
            );

            changeBuilder.addDartFileEdit((builder) {
              builder.addSimpleReplacement(
                SourceRange(offset, length),
                "final",
              );
            });

            return;
          }

          if (element is PropertyAccessorElement) {
            if (element.isSetter) {
              final changeBuilder = reporter.createChangeBuilder(
                message: "Remove '$HOOK_REGISTER_VAR' setter.",
                priority: 1,
              );

              changeBuilder.addDartFileEdit((builder) {
                builder.addDeletion(node.sourceRange);
              });
              return;
            }

            final expresion =
                node.childEntities.whereType<ExpressionFunctionBody>().first;
            final prefixedIdentifier =
                expresion.childEntities.whereType<PrefixedIdentifier>().first;

            final changeBuilder = reporter.createChangeBuilder(
              message: "Convert '$HOOK_REGISTER_VAR' to final field.",
              priority: 1,
            );

            changeBuilder.addDartFileEdit((builder) {
              builder
                ..addSimpleReplacement(
                  SourceRange(
                    node.firstTokenAfterCommentAndMetadata.offset,
                    node.end - node.firstTokenAfterCommentAndMetadata.offset,
                  ),
                  "final $HOOK_REGISTER_VAR = $prefixedIdentifier;",
                );
            });
          }
        } catch (e) {
          print(e);
        }
      },
    );
  }
}
