import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import '../../../flutter_reactter/test/shareds/test_builder.dart';

import '../shareds/test_controllers.dart';

void main() {
  group("LifecycleObserver", () {
    testWidgets(
      "should resolve the lifecycle event of a LifecycleObserver instance",
      (tester) async {
        late TestLifecycleController? testLifecycleController;

        testLifecycleController = Reactter.find<TestLifecycleController>();

        expect(testLifecycleController, null);

        await tester.pumpWidget(
          TestBuilder(
            child: ReactterProvider<TestLifecycleController>(
              () => TestLifecycleController(),
              builder: (context, _, __) {
                expect(testLifecycleController, null);

                testLifecycleController = context.use<TestLifecycleController>();

                expect(testLifecycleController, isInstanceOf<TestLifecycleController>());

                return Container();
              },
            ),
          ),
        );

        expect(testLifecycleController?.onInitializedCalledCount, 1);
        expect(testLifecycleController?.onWillMountCalledCount, 1);
        expect(testLifecycleController?.onDidMountCalledCount, 1);
        expect(testLifecycleController?.onWillUpdateCalledCount, 0);
        expect(testLifecycleController?.onDidUpdateCalledCount, 0);
        expect(testLifecycleController?.onWillUnmountCalledCount, 0);
        expect(testLifecycleController?.onDidUnmountCalledCount, 0);
        expect(testLifecycleController?.lastState, null);

        testLifecycleController?.stateInt.value += 1;
        await tester.pumpAndSettle();

        expect(testLifecycleController?.onInitializedCalledCount, 1);
        expect(testLifecycleController?.onWillMountCalledCount, 1);
        expect(testLifecycleController?.onDidMountCalledCount, 1);
        expect(testLifecycleController?.onWillUpdateCalledCount, 1);
        expect(testLifecycleController?.onDidUpdateCalledCount, 1);
        expect(testLifecycleController?.onWillUnmountCalledCount, 0);
        expect(testLifecycleController?.onDidUnmountCalledCount, 0);
        expect(testLifecycleController?.lastState, testLifecycleController?.stateInt);

        testLifecycleController?.stateString.value = "new value";
        await tester.pumpAndSettle();

        expect(testLifecycleController?.onInitializedCalledCount, 1);
        expect(testLifecycleController?.onWillMountCalledCount, 1);
        expect(testLifecycleController?.onDidMountCalledCount, 1);
        expect(testLifecycleController?.onWillUpdateCalledCount, 2);
        expect(testLifecycleController?.onDidUpdateCalledCount, 2);
        expect(testLifecycleController?.onWillUnmountCalledCount, 0);
        expect(testLifecycleController?.onDidUnmountCalledCount, 0);
        expect(testLifecycleController?.lastState, testLifecycleController?.stateString);

        await tester.pumpWidget(Container());

        expect(testLifecycleController?.onInitializedCalledCount, 1);
        expect(testLifecycleController?.onWillMountCalledCount, 1);
        expect(testLifecycleController?.onDidMountCalledCount, 1);
        expect(testLifecycleController?.onWillUpdateCalledCount, 2);
        expect(testLifecycleController?.onDidUpdateCalledCount, 2);
        expect(testLifecycleController?.onWillUnmountCalledCount, 1);
        expect(testLifecycleController?.onDidUnmountCalledCount, 1);
        expect(testLifecycleController?.lastState, testLifecycleController?.stateString);
      },
    );
  });
}
