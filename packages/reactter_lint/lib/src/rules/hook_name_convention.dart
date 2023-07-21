import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:reactter_lint/src/consts.dart';
import 'package:reactter_lint/src/types.dart';

class HookNameConvention extends DartLintRule {
  const HookNameConvention() : super(code: _code);

  static const _code = LintCode(
    name: "hook_name_convention",
    errorSeverity: ErrorSeverity.WARNING,
    problemMessage:
        "The '{0}' hook name should be prefixed with '$HOOK_NAME_PREFIX'.",
    correctionMessage: "Try renaming '{0}' hook to '{1}'.",
  );

  @override
  List<Fix> getFixes() => [_HookNameFix()];

  static whenIsInvalid({
    required CustomLintContext context,
    required Function(Declaration node, Element element) onInvalid,
  }) {
    context.registry.addClassDeclaration((node) {
      final declaredElement = node.declaredElement;

      if (declaredElement == null) return;

      if (!reactterHookType.isAssignableFrom(declaredElement)) return;

      final name = declaredElement.name;

      if (name.startsWith(HOOK_NAME_PREFIX)) return;

      onInvalid(node, declaredElement);
    });
  }

  static String prefixUseName(String name) {
    return name.replaceFirstMapped(
      RegExp(r'\w'),
      (Match match) => HOOK_NAME_PREFIX + match[0]!.toUpperCase(),
    );
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
        final name = element.name!;

        reporter
            .reportErrorForElement(code, element, [name, prefixUseName(name)]);
      },
    );
  }
}

class _HookNameFix extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    HookNameConvention.whenIsInvalid(
      context: context,
      onInvalid: (node, element) {
        try {
          final name = element.name!;
          final nameUse = HookNameConvention.prefixUseName(name);

          final changeBuilder = reporter.createChangeBuilder(
            message: "Rename '$name' to '$nameUse'.",
            priority: 1,
          );

          changeBuilder.addDartFileEdit((builder) {
            builder.addSimpleReplacement(
              SourceRange(element.nameOffset, element.nameLength),
              nameUse,
            );
          });
        } catch (e) {
          print(e);
        }
      },
    );
  }
}
