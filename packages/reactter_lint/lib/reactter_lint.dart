// This is the entrypoint of our custom linter
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:reactter_lint/src/rules/hook_late_convention.dart';
import 'package:reactter_lint/src/rules/hook_name_convention.dart';
import 'package:reactter_lint/src/rules/invalid_hook_position.dart';
import 'package:reactter_lint/src/rules/invalid_hook_register.dart';

PluginBase createPlugin() => _ReactterLinter();

/// The _ReactterLinter class is a plugin base for linting in Dart.
class _ReactterLinter extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) {
    return const [
      HookLateConvention(),
      HookNameConvention(),
      InvalidHookPosition(),
      InvalidHookRegister(),
    ];
  }
}
