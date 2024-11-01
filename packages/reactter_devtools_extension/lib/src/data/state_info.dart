import 'package:reactter_devtools_extension/src/interfaces/node_info.dart';

class StateInfo extends INodeInfo {
  final String? boundInstanceKey;
  final List<String> kinds;

  StateInfo({
    super.label,
    this.boundInstanceKey,
    this.kinds = const ['RtState'],
  });

  StateInfo copyWith({String? label, String? boundInstanceKey}) {
    return StateInfo(
      label: label ?? this.label,
      boundInstanceKey: boundInstanceKey ?? this.boundInstanceKey,
    );
  }
}
