import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import '../shareds/reactter_providers_builder.dart';
import '../shareds/test_builder.dart';
import '../shareds/test_controller.dart';

void main() {
  group("RtComponent", () {
    late TestController instanceObtained;

    testWidgets("should render and get dependency", (tester) async {
      await tester.pumpWidget(
        TestBuilder(
          child: TestBuilder(
            child: RtComponentTest(
              getInstance: (inst) {
                instanceObtained = inst;
              },
            ),
          ),
        ),
      );

      await _testRtComponent(tester: tester, instance: instanceObtained);
    });

    testWidgets("should renders and get dependency by id", (tester) async {
      late TestController instanceObtained;

      await tester.pumpWidget(
        TestBuilder(
          child: ReactterProvidersBuilder(
            builder: (_, __) {
              return RtComponentTest(
                id: "uniqueId",
                getInstance: (inst) {
                  instanceObtained = inst;
                },
              );
            },
          ),
        ),
      );

      await _testRtComponent(
        tester: tester,
        instance: instanceObtained,
        byId: true,
      );

      final rectterCompontentElement =
          tester.element(find.bySubtype<RtComponent>().first)
            ..deactivate()
            ..activate();

      final diagnostic =
          rectterCompontentElement.toDiagnosticsNode().toTimelineArguments();

      expect(diagnostic?['id'], '"uniqueId"');
    });

    testWidgets("should render and get dependency without instance builder",
        (tester) async {
      late TestController instanceObtained;

      await tester.pumpWidget(
        TestBuilder(
          child: ReactterProvidersBuilder(
            builder: (_, __) {
              return RtComponentTest(
                withoutBuilder: true,
                getInstance: (inst) {
                  instanceObtained = inst;
                },
              );
            },
          ),
        ),
      );

      await _testRtComponent(tester: tester, instance: instanceObtained);
    });

    testWidgets("should render and get dependency without listen states",
        (tester) async {
      late TestController instanceObtained;

      await tester.pumpWidget(
        TestBuilder(
          child: ReactterProvidersBuilder(
            builder: (_, __) {
              return RtComponentTest(
                withoutListenStates: true,
                getInstance: (inst) {
                  instanceObtained = inst;
                },
              );
            },
          ),
        ),
      );

      await _testRtComponent(
        tester: tester,
        instance: instanceObtained,
        withoutListenStates: true,
      );
    });
  });
}

_testRtComponent({
  required WidgetTester tester,
  required TestController instance,
  bool withoutListenStates = false,
  bool byId = false,
}) async {
  await tester.pumpAndSettle();

  void expectInitial() {
    expect(find.text("stateBool: false"), findsOneWidget);

    if (byId) {
      expect(find.text("stateString: from uniqueId"), findsOneWidget);
    } else {
      expect(find.text("stateString: initial"), findsOneWidget);
    }
  }

  expectInitial();

  instance.stateBool.value = true;
  instance.stateString.value = "new value";

  await tester.pumpAndSettle();

  if (withoutListenStates) {
    expectInitial();
  } else {
    expect(find.text("stateBool: true"), findsOneWidget);
    expect(find.text("stateString: new value"), findsOneWidget);
  }
}

class RtComponentTest extends StatelessWidget {
  const RtComponentTest({
    Key? key,
    this.id,
    required this.getInstance,
    this.withoutBuilder = false,
    this.withoutListenStates = false,
  }) : super(key: key);

  final bool withoutBuilder;
  final bool withoutListenStates;

  final String? id;
  final void Function(TestController inst) getInstance;

  @override
  build(context) {
    if (withoutBuilder) {
      return RtComponentTestWithoutBuilder(
        id: id,
        getInstance: getInstance,
      );
    }

    if (withoutListenStates) {
      return RtComponentTestWithoutListenStates(
        id: id,
        getInstance: getInstance,
      );
    }

    if (id == null) {
      return RtComponentTestWithoutId(
        getInstance: getInstance,
      );
    }

    return RtComponentTestAll(
      id: id,
      getInstance: getInstance,
    );
  }
}

class RtComponentTestWithoutId extends RtComponent<TestController> {
  const RtComponentTestWithoutId({
    Key? key,
    required this.getInstance,
  }) : super(key: key);

  final void Function(TestController inst) getInstance;

  @override
  get builder => () => TestController();

  @override
  get listenStates => (inst) => [inst.stateBool, inst.stateString];

  @override
  Widget render(context, inst) {
    getInstance(inst);

    return _buildWidget(inst);
  }
}

class RtComponentTestWithoutBuilder extends RtComponent<TestController> {
  const RtComponentTestWithoutBuilder({
    Key? key,
    this.id,
    required this.getInstance,
  }) : super(key: key);

  final void Function(TestController inst) getInstance;

  @override
  final String? id;

  @override
  get listenStates => (inst) => [inst.stateBool, inst.stateString];

  @override
  Widget render(context, inst) {
    getInstance(inst);

    return _buildWidget(inst);
  }
}

class RtComponentTestWithoutListenStates extends RtComponent<TestController> {
  const RtComponentTestWithoutListenStates({
    Key? key,
    this.id,
    required this.getInstance,
  }) : super(key: key);

  final void Function(TestController inst) getInstance;

  @override
  final String? id;

  @override
  get builder => () => TestController();

  @override
  Widget render(context, inst) {
    getInstance(inst);

    return _buildWidget(inst);
  }
}

class RtComponentTestAll extends RtComponent<TestController> {
  const RtComponentTestAll({
    Key? key,
    this.id,
    required this.getInstance,
  }) : super(key: key);

  final void Function(TestController inst) getInstance;

  @override
  final String? id;

  @override
  get listenAll => true;

  @override
  get builder => () => TestController();

  @override
  Widget render(context, inst) {
    getInstance(inst);

    return _buildWidget(inst);
  }
}

Widget _buildWidget(TestController inst) {
  return Column(
    children: [
      Text("stateBool: ${inst.stateBool.value}"),
      Text("stateString: ${inst.stateString.value}"),
    ],
  );
}
