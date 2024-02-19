import 'package:flutter/widgets.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:flutter_test/flutter_test.dart';

import '../shareds/reactter_provider_builder.dart';
import '../shareds/test_builder.dart';
import '../shareds/test_controller.dart';

void main() {
  group("LifecycleObserver", () {
    testWidgets(
      "should resolve the lifecycle event of a LifecycleObserver instance",
      (tester) async {
        late TestController? testController;

        testController = Reactter.find<TestController>();

        expect(testController, null);

        await tester.pumpWidget(
          TestBuilder(
            child: ReactterProviderBuilder(
              builder: (context, _, __) {
                expect(testController, null);

                testController = context.use<TestController>();

                expect(testController, isInstanceOf<TestController>());

                return Container();
              },
            ),
          ),
        );

        expect(testController?.onInitializedCalledCount, 1);
        expect(testController?.onWillMountCalledCount, 1);
        expect(testController?.onDidMountCalledCount, 1);
        expect(testController?.onWillUpdateCalledCount, 0);
        expect(testController?.onDidUpdateCalledCount, 0);
        expect(testController?.onWillUnmountCalledCount, 0);
        expect(testController?.onDidUnmountCalledCount, 0);
        expect(testController?.lastState, null);

        testController?.stateInt.value += 1;
        await tester.pumpAndSettle();

        expect(testController?.onInitializedCalledCount, 1);
        expect(testController?.onWillMountCalledCount, 1);
        expect(testController?.onDidMountCalledCount, 1);
        expect(testController?.onWillUpdateCalledCount, 1);
        expect(testController?.onDidUpdateCalledCount, 1);
        expect(testController?.onWillUnmountCalledCount, 0);
        expect(testController?.onDidUnmountCalledCount, 0);
        expect(testController?.lastState, testController?.stateInt);

        testController?.stateString.value = "new value";
        await tester.pumpAndSettle();

        expect(testController?.onInitializedCalledCount, 1);
        expect(testController?.onWillMountCalledCount, 1);
        expect(testController?.onDidMountCalledCount, 1);
        expect(testController?.onWillUpdateCalledCount, 2);
        expect(testController?.onDidUpdateCalledCount, 2);
        expect(testController?.onWillUnmountCalledCount, 0);
        expect(testController?.onDidUnmountCalledCount, 0);
        expect(testController?.lastState, testController?.stateString);

        await tester.pumpWidget(Container());

        expect(testController?.onInitializedCalledCount, 1);
        expect(testController?.onWillMountCalledCount, 1);
        expect(testController?.onDidMountCalledCount, 1);
        expect(testController?.onWillUpdateCalledCount, 2);
        expect(testController?.onDidUpdateCalledCount, 2);
        expect(testController?.onWillUnmountCalledCount, 1);
        expect(testController?.onDidUnmountCalledCount, 1);
        expect(testController?.lastState, testController?.stateString);
      },
    );
  });
}
