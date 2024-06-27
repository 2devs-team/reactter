import 'package:reactter/reactter.dart';
import 'package:test/test.dart';

import '../shareds/test_controllers.dart';

void main() {
  group("LifecycleObserver", () {
    test(
      "should resolve the lifecycle event of a LifecycleObserver instance",
      () {
        late TestLifecycleController? testLifecycleController;

        testLifecycleController = Reactter.find<TestLifecycleController>();

        expect(testLifecycleController, null);

        testLifecycleController = Reactter.create(
          () => TestLifecycleController(),
        )!;

        expect(testLifecycleController, isA<TestLifecycleController>());

        Reactter.emit(
          ReactterDependency<TestLifecycleController>(),
          Lifecycle.willMount,
        );

        expect(testLifecycleController.onCreatedCalledCount, 1);
        expect(testLifecycleController.onWillMountCalledCount, 1);
        expect(testLifecycleController.onDidMountCalledCount, 0);
        expect(testLifecycleController.onWillUpdateCalledCount, 0);
        expect(testLifecycleController.onDidUpdateCalledCount, 0);
        expect(testLifecycleController.onWillUnmountCalledCount, 0);
        expect(testLifecycleController.onDidUnmountCalledCount, 0);
        expect(testLifecycleController.lastState, null);

        Reactter.emit(
          ReactterDependency<TestLifecycleController>(),
          Lifecycle.didMount,
        );

        expect(testLifecycleController.onCreatedCalledCount, 1);
        expect(testLifecycleController.onWillMountCalledCount, 1);
        expect(testLifecycleController.onDidMountCalledCount, 1);
        expect(testLifecycleController.onWillUpdateCalledCount, 0);
        expect(testLifecycleController.onDidUpdateCalledCount, 0);
        expect(testLifecycleController.onWillUnmountCalledCount, 0);
        expect(testLifecycleController.onDidUnmountCalledCount, 0);
        expect(testLifecycleController.lastState, null);

        testLifecycleController.stateInt.value += 1;

        expect(testLifecycleController.onCreatedCalledCount, 1);
        expect(testLifecycleController.onWillMountCalledCount, 1);
        expect(testLifecycleController.onDidMountCalledCount, 1);
        expect(testLifecycleController.onWillUpdateCalledCount, 1);
        expect(testLifecycleController.onDidUpdateCalledCount, 1);
        expect(testLifecycleController.onWillUnmountCalledCount, 0);
        expect(testLifecycleController.onDidUnmountCalledCount, 0);
        expect(
          testLifecycleController.lastState,
          testLifecycleController.stateInt,
        );

        testLifecycleController.stateString.value = "new value";

        expect(testLifecycleController.onCreatedCalledCount, 1);
        expect(testLifecycleController.onWillMountCalledCount, 1);
        expect(testLifecycleController.onDidMountCalledCount, 1);
        expect(testLifecycleController.onWillUpdateCalledCount, 2);
        expect(testLifecycleController.onDidUpdateCalledCount, 2);
        expect(testLifecycleController.onWillUnmountCalledCount, 0);
        expect(testLifecycleController.onDidUnmountCalledCount, 0);
        expect(
          testLifecycleController.lastState,
          testLifecycleController.stateString,
        );

        Reactter.emit(
          ReactterDependency<TestLifecycleController>(),
          Lifecycle.willUnmount,
        );

        expect(testLifecycleController.onCreatedCalledCount, 1);
        expect(testLifecycleController.onWillMountCalledCount, 1);
        expect(testLifecycleController.onDidMountCalledCount, 1);
        expect(testLifecycleController.onWillUpdateCalledCount, 2);
        expect(testLifecycleController.onDidUpdateCalledCount, 2);
        expect(testLifecycleController.onWillUnmountCalledCount, 1);
        expect(testLifecycleController.onDidUnmountCalledCount, 0);
        expect(
          testLifecycleController.lastState,
          testLifecycleController.stateString,
        );

        Reactter.emit(
          ReactterDependency<TestLifecycleController>(),
          Lifecycle.didUnmount,
        );

        expect(testLifecycleController.onCreatedCalledCount, 1);
        expect(testLifecycleController.onWillMountCalledCount, 1);
        expect(testLifecycleController.onDidMountCalledCount, 1);
        expect(testLifecycleController.onWillUpdateCalledCount, 2);
        expect(testLifecycleController.onDidUpdateCalledCount, 2);
        expect(testLifecycleController.onWillUnmountCalledCount, 1);
        expect(testLifecycleController.onDidUnmountCalledCount, 1);
        expect(
          testLifecycleController.lastState,
          testLifecycleController.stateString,
        );
      },
    );
  });
}
