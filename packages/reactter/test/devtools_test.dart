import 'package:flutter_test/flutter_test.dart';
import 'package:reactter/reactter.dart';
import 'package:reactter/src/devtools.dart';

import 'shareds/test_controllers.dart';

void main() {
  group("Devtools", () {
    test('should be initialized', () {
      try {
        Rt.initializeDevTools();
      } catch (e) {
        expect(e, isInstanceOf<RtDevToolsInitializeAssertionError>());
      }

      expect(RtDevTools.instance, isNotNull);
    });

    test('should be register states and dependencies', () {
      try {
        Rt.initializeDevTools();
      } catch (e) {
        expect(e, isInstanceOf<RtDevToolsInitializeAssertionError>());
      }

      final devtools = RtDevTools.instance;

      final Type dependencyType = TestController;
      Rt.create<TestController>(() => TestController());

      final response = devtools?.getNodes(0, 100);

      expect(response, isNotNull);

      final nodes = response?['nodes'];

      bool isDependencyRegistered = false;
      void checkIsDependencyRegistered({
        required String kind,
        required String type,
      }) {
        isDependencyRegistered = isDependencyRegistered ||
            kind == NodeKind.dependency.toString() &&
                type.startsWith(dependencyType.toString());
      }

      bool isDependencyCreated = false;
      void checkIsDependencyCreated({
        required String kind,
        required String type,
      }) {
        isDependencyCreated = isDependencyCreated ||
            kind == NodeKind.instance.toString() &&
                type.startsWith(dependencyType.toString());
      }

      for (final node in nodes) {
        final kind = node['kind'];
        final type = node['type'];

        checkIsDependencyRegistered(kind: kind, type: type);
        checkIsDependencyCreated(kind: kind, type: type);
      }

      expect(nodes, isNotNull);
      expect(isDependencyRegistered, isTrue);
      expect(isDependencyCreated, isTrue);
    });
  });
}
