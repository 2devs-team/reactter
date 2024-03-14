import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import '../shareds/reactter_providers_builder.dart';
import '../shareds/test_builder.dart';
import '../shareds/test_controller.dart';

void main() {
  group("ReactterComponent", () {
    late TestController instanceObtained;

    testWidgets("should render and get instance", (tester) async {
      await tester.pumpWidget(
        TestBuilder(
          child: TestBuilder(
            child: ReactterComponentTest(
              getInstance: (inst) {
                instanceObtained = inst;
              },
            ),
          ),
        ),
      );

      await _testReactterComponent(tester: tester, instance: instanceObtained);
    });

    testWidgets("should renders and get instance by id", (tester) async {
      late TestController instanceObtained;

      await tester.pumpWidget(
        TestBuilder(
          child: ReactterProvidersBuilder(
            builder: (_, __) {
              return ReactterComponentTest(
                id: "uniqueId",
                getInstance: (inst) {
                  instanceObtained = inst;
                },
              );
            },
          ),
        ),
      );

      await _testReactterComponent(
        tester: tester,
        instance: instanceObtained,
        byId: true,
      );

      final rectterCompontentElement =
          tester.element(find.bySubtype<ReactterComponent>().first)
            ..deactivate()
            ..activate();

      final diagnostic =
          rectterCompontentElement.toDiagnosticsNode().toTimelineArguments();

      expect(diagnostic?['id'], '"uniqueId"');
    });

    testWidgets("should render and get instance without builder instance",
        (tester) async {
      late TestController instanceObtained;

      await tester.pumpWidget(
        TestBuilder(
          child: ReactterProvidersBuilder(
            builder: (_, __) {
              return ReactterComponentTest(
                withoutBuilder: true,
                getInstance: (inst) {
                  instanceObtained = inst;
                },
              );
            },
          ),
        ),
      );

      await _testReactterComponent(tester: tester, instance: instanceObtained);
    });

    testWidgets("should render and get instance without listen hooks",
        (tester) async {
      late TestController instanceObtained;

      await tester.pumpWidget(
        TestBuilder(
          child: ReactterProvidersBuilder(
            builder: (_, __) {
              return ReactterComponentTest(
                withoutListenStates: true,
                getInstance: (inst) {
                  instanceObtained = inst;
                },
              );
            },
          ),
        ),
      );

      await _testReactterComponent(
        tester: tester,
        instance: instanceObtained,
        withoutListenStates: true,
      );
    });
  });
}

_testReactterComponent({
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

class ReactterComponentTest extends StatelessWidget {
  const ReactterComponentTest({
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
      return ReactterComponentTestWithoutBuilder(
        id: id,
        getInstance: getInstance,
      );
    }

    if (withoutListenStates) {
      return ReactterComponentTestWithoutListenStates(
        id: id,
        getInstance: getInstance,
      );
    }

    if (id == null) {
      return ReactterComponentTestWithoutId(
        getInstance: getInstance,
      );
    }

    return ReactterComponentTestAll(
      id: id,
      getInstance: getInstance,
    );
  }
}

class ReactterComponentTestWithoutId extends ReactterComponent<TestController> {
  const ReactterComponentTestWithoutId({
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

class ReactterComponentTestWithoutBuilder
    extends ReactterComponent<TestController> {
  const ReactterComponentTestWithoutBuilder({
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

class ReactterComponentTestWithoutListenStates
    extends ReactterComponent<TestController> {
  const ReactterComponentTestWithoutListenStates({
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

class ReactterComponentTestAll extends ReactterComponent<TestController> {
  const ReactterComponentTestAll({
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
