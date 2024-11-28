import 'package:flutter_reactter/reactter.dart';
import 'package:reactter_devtools_extension/src/nodes/dependency/dependency_info.dart';
import 'package:reactter_devtools_extension/src/nodes/instance/instance_node.dart';

final class DependencyNode extends InstanceNode<DependencyInfo> {
  final uIsLoading = UseState(false);

  DependencyNode.$({required super.key}) : super.$();

  factory DependencyNode({required String key}) {
    return Rt.createState(
      () => DependencyNode.$(key: key),
    );
  }
}
