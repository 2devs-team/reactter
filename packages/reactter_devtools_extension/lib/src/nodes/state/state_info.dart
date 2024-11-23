import 'package:reactter_devtools_extension/src/bases/node_info.dart';

final class StateInfo extends NodeInfo {
  final String? debugLabel;
  final String? boundInstanceKey;
  final List<String> kinds;

  StateInfo({
    super.dependencyRef,
    this.debugLabel,
    this.boundInstanceKey,
    this.kinds = const ['RtState'],
  });

  StateInfo copyWith({
    String? dependencyRef,
    String? debugLabel,
    String? boundInstanceKey,
  }) {
    return StateInfo(
      dependencyRef: dependencyRef ?? this.dependencyRef,
      debugLabel: debugLabel ?? this.debugLabel,
      boundInstanceKey: boundInstanceKey ?? this.boundInstanceKey,
    );
  }
}
