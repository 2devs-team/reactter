// This is the entrypoint of our custom linter
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:reactter_lint/src/rules/rt_state_late_convention.dart';
import 'package:reactter_lint/src/rules/rt_hook_name_convention.dart';
import 'package:reactter_lint/src/rules/rt_invalid_hook_position.dart';
import 'package:reactter_lint/src/rules/rt_invalid_hook_register.dart';
import 'package:reactter_lint/src/rules/rt_no_logic_in_create_state.dart';
import 'package:reactter_lint/src/rules/rt_invalid_state_creation.dart';

/// The function creates an instance of the _ReactterLinter class and returns it as a PluginBase object.
PluginBase createPlugin() => _ReactterLinter();

/// The _ReactterLinter class is a plugin base for linting in Dart.
class _ReactterLinter extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) {
    return const [
      RtStateLateConvention(),
      RtHookNameConvention(),
      RtInvalidHookPosition(),
      RtInvalidHookRegister(),
      RtNoLogicInRegisterState(),
      RtInvalidStateCreation(),
    ];
  }
}
