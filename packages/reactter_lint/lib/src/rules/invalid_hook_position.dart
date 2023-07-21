import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:reactter_lint/src/consts.dart';
import 'package:reactter_lint/src/extensions.dart';
import 'package:reactter_lint/src/helpers.dart';
import 'package:reactter_lint/src/types.dart';

class InvalidHookPosition extends DartLintRule {
  const InvalidHookPosition() : super(code: _code);

  static const _code = LintCode(
    name: "invalid_hook_position",
    errorSeverity: ErrorSeverity.WARNING,
    problemMessage:
        "The '{0}' must be defined after hook register('$HOOK_REGISTER_VAR').",
    correctionMessage:
        "Try moving '{0}' after hook register('$HOOK_REGISTER_VAR').",
  );

  static whenIsInvalid({
    required CustomLintContext context,
    required Function(Declaration node, Element element) onInvalid,
  }) {

    context.registry.addClassDeclaration((node) {
      final declaredElement = node.declaredElement;

      if (declaredElement == null) return;

      if (!reactterHookType.isAssignableFrom(declaredElement)) return;

      final hookRegisterNode = node.members.firstWhereOrNull(isHookRegister);

      if (hookRegisterNode == null) return;

      final hooks = node.members.whereType<FieldDeclaration>().where((node) {
        final element = getElementFromDeclaration(node);

        if (element == null) return false;

        return reactterHookType.isAssignableFrom(element);
      }).toList();

      for (final hook in hooks) {
        if (hook.offset < hookRegisterNode.offset) {
          onInvalid(hook, hook.fields.variables.first.declaredElement!);
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
        reporter.reportErrorForElement(code, element, [
          element.name!,
        ]);
      },
    );
  }
}
