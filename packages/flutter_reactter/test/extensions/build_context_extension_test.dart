import 'package:flutter/widgets.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:flutter_test/flutter_test.dart';

import '../shareds/iterable_extension.dart';
import '../shareds/reactter_provider_builder.dart';
import '../shareds/reactter_providers_builder.dart';
import '../shareds/test_builder.dart';
import '../shareds/test_controller.dart';

void main() {
  group("context.use", () {
    testWidgets("should throw exception when dependency not found",
        (tester) async {
      await tester.pumpWidget(
        TestBuilder(
          child: Builder(
            builder: (context) {
              context.use<TestController>();
              return const Text("Rendered");
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        tester.takeException(),
        isInstanceOf<ReactterDependencyNotFoundException>(),
      );
      expect(find.text("Rendered"), findsNothing);
    });

    testWidgets("should get dependency instance", (tester) async {
      late TestController instanceObtained;

      await tester.pumpWidget(
        TestBuilder(
          child: ReactterProviderBuilder(
            builder: (context, _, __) {
              instanceObtained = context.use<TestController>();
              final testController = context.use<TestController?>();

              expect(testController, isNotNull);
              expect(testController, instanceObtained);
              expect(testController, isInstanceOf<TestController>());

              return const Text("Rendered");
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expectLater(instanceObtained, isInstanceOf<TestController>());
      expect(find.text("Rendered"), findsOneWidget);
    });

    testWidgets("should get null when dependency not found", (tester) async {
      late TestController? instanceObtained;

      await tester.pumpWidget(
        TestBuilder(
          child: Builder(
            builder: (context) {
              instanceObtained = context.use<TestController?>();

              return Text(
                "stateString: ${instanceObtained?.stateString.value ?? 'not found'}",
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expectLater(instanceObtained, null);
      expect(find.text("stateString: not found"), findsOneWidget);
    });
  });

  group("context.watch", () {
    testWidgets("should watch dependency changes", (tester) async {
      late TestController instanceObtained;

      await tester.pumpWidget(
        TestBuilder(
          child: ReactterProviderBuilder(
            builder: (context, _, __) {
              instanceObtained = context.watch<TestController>();

              return Text(
                "stateString: ${instanceObtained.stateString.value}",
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expectLater(instanceObtained, isInstanceOf<TestController>());
      expect(find.text("stateString: initial"), findsOneWidget);

      instanceObtained.stateString.value = "new value";
      await tester.pumpAndSettle();

      expect(find.text("stateString: new value"), findsOneWidget);
    });

    testWidgets("should watch dependency's states", (tester) async {
      late TestController instanceObtained;

      await tester.pumpWidget(
        TestBuilder(
          child: ReactterProviderBuilder(
            builder: (context, _, __) {
              instanceObtained = context.watch<TestController>(
                (inst) => [inst.stateInt],
              );

              return Column(
                children: [
                  Text("stateString: ${instanceObtained.stateString.value}"),
                  Text("stateInt: ${instanceObtained.stateInt.value}"),
                ],
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expectLater(instanceObtained, isInstanceOf<TestController>());
      expect(find.text("stateString: initial"), findsOneWidget);
      expect(find.text("stateInt: 0"), findsOneWidget);

      instanceObtained.stateString.value = "new value";
      await tester.pumpAndSettle();

      expect(find.text("stateString: initial"), findsOneWidget);
      expect(find.text("stateInt: 0"), findsOneWidget);

      instanceObtained.stateInt.value += 2;
      await tester.pumpAndSettle();

      expect(find.text("stateString: new value"), findsOneWidget);
      expect(find.text("stateInt: 2"), findsOneWidget);
    });

    testWidgets(
        "should watch multiple dependency's states, using different context.watch",
        (tester) async {
      late TestController instanceObtained;
      late TestController instanceObtainedWithId;

      await tester.pumpWidget(
        TestBuilder(
          child: ReactterProvidersBuilder(
            builder: (context, _) {
              instanceObtained = context.use<TestController>();
              instanceObtainedWithId = context.use<TestController>('uniqueId');

              return Column(
                children: [
                  Builder(builder: (context) {
                    // any change of any states without id
                    context.watch<TestController>((inst) => [inst.stateString]);
                    context.watch<TestController>();

                    return Column(
                      children: [
                        Text(
                          "stateStringByIdDontWatch: ${instanceObtainedWithId.stateString.value}",
                        ),
                        Text(
                          "stateString: ${instanceObtained.stateString.value}",
                        ),
                      ],
                    );
                  }),
                  Builder(builder: (context) {
                    // only change of stateString with id
                    context.watchId<TestController>(
                      'uniqueId',
                      (inst) => [inst.stateString],
                    );

                    return Text(
                      "stateStringById: ${instanceObtainedWithId.stateString.value}",
                    );
                  }),
                  Builder(
                    builder: (context) {
                      // any change of stateInt
                      context.watch<TestController>((inst) => [inst.stateInt]);
                      context.watch((_) => [instanceObtainedWithId.stateInt]);

                      return Column(
                        children: [
                          Text(
                            "stateIntById: ${instanceObtainedWithId.stateInt.value}",
                          ),
                          Text("stateInt: ${instanceObtained.stateInt.value}"),
                        ],
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expectLater(instanceObtained, isInstanceOf<TestController>());
      expectLater(instanceObtainedWithId, isInstanceOf<TestController>());

      expect(
        find.text("stateStringByIdDontWatch: from uniqueId"),
        findsOneWidget,
      );
      expect(find.text("stateString: initial"), findsOneWidget);
      expect(find.text("stateStringById: from uniqueId"), findsOneWidget);
      expect(find.text("stateIntById: 0"), findsOneWidget);
      expect(find.text("stateInt: 0"), findsOneWidget);

      instanceObtained.stateString.value = "new value";
      await tester.pumpAndSettle();

      expect(
        find.text("stateStringByIdDontWatch: from uniqueId"),
        findsOneWidget,
      );
      expect(find.text("stateString: new value"), findsOneWidget);
      expect(find.text("stateStringById: from uniqueId"), findsOneWidget);
      expect(find.text("stateIntById: 0"), findsOneWidget);
      expect(find.text("stateInt: 0"), findsOneWidget);

      instanceObtainedWithId.stateString.value = "new value";
      await tester.pumpAndSettle();

      expect(
          find.text("stateStringByIdDontWatch: from uniqueId"), findsOneWidget);
      expect(find.text("stateString: new value"), findsOneWidget);
      expect(find.text("stateStringById: new value"), findsOneWidget);
      expect(find.text("stateIntById: 0"), findsOneWidget);
      expect(find.text("stateInt: 0"), findsOneWidget);

      instanceObtained.stateInt.value += 2;
      await tester.pumpAndSettle();

      expect(find.text("stateStringByIdDontWatch: new value"), findsOneWidget);
      expect(find.text("stateString: new value"), findsOneWidget);
      expect(find.text("stateStringById: new value"), findsOneWidget);
      expect(find.text("stateIntById: 0"), findsOneWidget);
      expect(find.text("stateInt: 2"), findsOneWidget);

      instanceObtainedWithId.stateInt.value += 5;
      await tester.pumpAndSettle();

      expect(find.text("stateStringByIdDontWatch: new value"), findsOneWidget);
      expect(find.text("stateString: new value"), findsOneWidget);
      expect(find.text("stateStringById: new value"), findsOneWidget);
      expect(find.text("stateIntById: 5"), findsOneWidget);
      expect(find.text("stateInt: 2"), findsOneWidget);
    });
  });

  group("context.select", () {
    testWidgets(
      "should throw exception when ReactterScope not found",
      (tester) async {
        await tester.pumpWidget(
          TestBuilder(
            child: Builder(
              builder: (context) {
                context.select((_, __) => 0);
                return const Text("Rendered");
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(
          tester.takeException(),
          isInstanceOf<ReactterScopeNotFoundException>(),
        );
        expect(find.text("Rendered"), findsNothing);
      },
    );

    testWidgets(
      "should throw exception when dependency not found",
      (tester) async {
        await tester.pumpWidget(
          TestBuilder(
            child: Builder(
              builder: (context) {
                context.select<TestController, int>((_, __) => 0);
                return const Text("Rendered");
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(
          tester.takeException(),
          isInstanceOf<ReactterDependencyNotFoundException>(),
        );
        expect(find.text("Rendered"), findsNothing);
      },
    );

    testWidgets("should rebuild without type defined", (tester) async {
      late TestController instanceObtained;
      int countRender = 0;

      await tester.pumpWidget(
        TestBuilder(
          child: ReactterProvidersBuilder(
            builder: (context, _) {
              instanceObtained = context.use<TestController>();

              final len = context.select(
                (_, $) => $(instanceObtained.stateList).value.length,
              );

              countRender++;

              return Column(
                children: [
                  Text('stateList.length: $len'),
                  Text(
                    'stateList.first: ${instanceObtained.stateList.value.firstOrNull}',
                  ),
                  Text(
                    'stateList.last: ${instanceObtained.stateList.value.lastOrNull}',
                  ),
                ],
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expectLater(instanceObtained, isInstanceOf<TestController>());
      expect(countRender, 1);
      expect(find.text("stateList.length: 0"), findsOneWidget);
      expect(find.text("stateList.first: null"), findsOneWidget);
      expect(find.text("stateList.last: null"), findsOneWidget);

      instanceObtained.stateList.update(() {
        instanceObtained.stateList.value.add('test');
      });
      await tester.pumpAndSettle();

      expect(countRender, 2);
      expect(find.text("stateList.length: 1"), findsOneWidget);
      expect(find.text("stateList.first: test"), findsOneWidget);
      expect(find.text("stateList.last: test"), findsOneWidget);

      instanceObtained.stateList.value.add('test2');
      await tester.pumpAndSettle();

      expect(countRender, 2);
      expect(find.text("stateList.length: 1"), findsOneWidget);
      expect(find.text("stateList.first: test"), findsOneWidget);
      expect(find.text("stateList.last: test"), findsOneWidget);

      instanceObtained.stateList.update();
      await tester.pumpAndSettle();

      expect(countRender, 3);
      expect(find.text("stateList.length: 2"), findsOneWidget);
      expect(find.text("stateList.first: test"), findsOneWidget);
      expect(find.text("stateList.last: test2"), findsOneWidget);

      instanceObtained.stateList.update();
      await tester.pumpAndSettle();

      expect(countRender, 3);
      expect(find.text("stateList.length: 2"), findsOneWidget);
      expect(find.text("stateList.first: test"), findsOneWidget);
      expect(find.text("stateList.last: test2"), findsOneWidget);
    });

    testWidgets("should rebuild without selecting states", (tester) async {
      late TestController instanceObtained;
      int countRender = 0;

      await tester.pumpWidget(
        TestBuilder(
          child: ReactterProvidersBuilder(
            builder: (context, _) {
              final len = context.select<TestController, int>(
                (inst, $) {
                  instanceObtained = inst;
                  return inst.stateList.value.length;
                },
              );

              countRender++;

              return Column(
                children: [
                  Text('stateList.length: $len'),
                  Text(
                    'stateList.first: ${instanceObtained.stateList.value.firstOrNull}',
                  ),
                  Text(
                    'stateList.last: ${instanceObtained.stateList.value.lastOrNull}',
                  ),
                ],
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expectLater(instanceObtained, isInstanceOf<TestController>());
      expect(countRender, 1);
      expect(find.text("stateList.length: 0"), findsOneWidget);
      expect(find.text("stateList.first: null"), findsOneWidget);
      expect(find.text("stateList.last: null"), findsOneWidget);

      instanceObtained.stateList.update(() {
        instanceObtained.stateList.value.add('test');
      });
      await tester.pumpAndSettle();

      expect(countRender, 2);
      expect(find.text("stateList.length: 1"), findsOneWidget);
      expect(find.text("stateList.first: test"), findsOneWidget);
      expect(find.text("stateList.last: test"), findsOneWidget);

      instanceObtained.stateList.value.add('test2');
      await tester.pumpAndSettle();

      expect(countRender, 2);
      expect(find.text("stateList.length: 1"), findsOneWidget);
      expect(find.text("stateList.first: test"), findsOneWidget);
      expect(find.text("stateList.last: test"), findsOneWidget);

      instanceObtained.stateList.update();
      await tester.pumpAndSettle();

      expect(countRender, 3);
      expect(find.text("stateList.length: 2"), findsOneWidget);
      expect(find.text("stateList.first: test"), findsOneWidget);
      expect(find.text("stateList.last: test2"), findsOneWidget);

      instanceObtained.stateList.update();
      await tester.pumpAndSettle();

      expect(countRender, 3);
      expect(find.text("stateList.length: 2"), findsOneWidget);
      expect(find.text("stateList.first: test"), findsOneWidget);
      expect(find.text("stateList.last: test2"), findsOneWidget);
    });

    testWidgets("with context.watch should rebuild", (tester) async {
      late TestController instanceObtained;
      int countRender = 0;

      await tester.pumpWidget(
        TestBuilder(
          child: ReactterProvidersBuilder(
            builder: (context, _) {
              instanceObtained = context.watch<TestController>(
                (inst) => [inst.stateList],
              );
              final total = context.select<TestController, int>(
                (inst, $) {
                  return $(inst.stateList).value.length +
                      $(inst.stateInt).value;
                },
              );
              context.watch<TestController>((inst) => [inst.stateString]);

              countRender++;

              return Column(
                children: [
                  Text('total: $total'),
                  Text(
                    'stateList.first: ${instanceObtained.stateList.value.firstOrNull}',
                  ),
                  Text(
                    'stateList.last: ${instanceObtained.stateList.value.lastOrNull}',
                  ),
                  Text('stateString: ${instanceObtained.stateString.value}'),
                ],
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expectLater(instanceObtained, isInstanceOf<TestController>());
      expect(countRender, 1);
      expect(find.text("total: 0"), findsOneWidget);
      expect(find.text("stateList.first: null"), findsOneWidget);
      expect(find.text("stateList.last: null"), findsOneWidget);
      expect(find.text("stateString: initial"), findsOneWidget);

      instanceObtained.stateList.update(() {
        instanceObtained.stateList.value.add('test');
      });
      await tester.pumpAndSettle();

      expect(countRender, 2);
      expect(find.text("total: 1"), findsOneWidget);
      expect(find.text("stateList.first: test"), findsOneWidget);
      expect(find.text("stateList.last: test"), findsOneWidget);
      expect(find.text("stateString: initial"), findsOneWidget);

      instanceObtained.stateList.value.add('test2');
      await tester.pumpAndSettle();

      expect(countRender, 2);
      expect(find.text("total: 1"), findsOneWidget);
      expect(find.text("stateList.first: test"), findsOneWidget);
      expect(find.text("stateList.last: test"), findsOneWidget);
      expect(find.text("stateString: initial"), findsOneWidget);

      instanceObtained.stateList.update();
      await tester.pumpAndSettle();

      expect(countRender, 3);
      expect(find.text("total: 2"), findsOneWidget);
      expect(find.text("stateList.first: test"), findsOneWidget);
      expect(find.text("stateList.last: test2"), findsOneWidget);
      expect(find.text("stateString: initial"), findsOneWidget);

      instanceObtained.stateList.update();
      await tester.pumpAndSettle();

      expect(countRender, 4);
      expect(find.text("total: 2"), findsOneWidget);
      expect(find.text("stateList.first: test"), findsOneWidget);
      expect(find.text("stateList.last: test2"), findsOneWidget);
      expect(find.text("stateString: initial"), findsOneWidget);

      instanceObtained.stateInt.value++;
      await tester.pumpAndSettle();

      expect(countRender, 5);
      expect(find.text("total: 3"), findsOneWidget);
      expect(find.text("stateList.first: test"), findsOneWidget);
      expect(find.text("stateList.last: test2"), findsOneWidget);
      expect(find.text("stateString: initial"), findsOneWidget);

      instanceObtained.stateString.value = "hello";
      await tester.pumpAndSettle();

      expect(countRender, 6);
      expect(find.text("total: 3"), findsOneWidget);
      expect(find.text("stateList.first: test"), findsOneWidget);
      expect(find.text("stateList.last: test2"), findsOneWidget);
      expect(find.text("stateString: hello"), findsOneWidget);
    });

    testWidgets("should rebuild using multiple select", (tester) async {
      late TestController instanceObtained;
      int countRender = 0;

      await tester.pumpWidget(
        TestBuilder(
          child: ReactterProvidersBuilder(
            builder: (context, _) {
              instanceObtained = context.use<TestController>();
              final len = context.select<TestController, int>(
                (inst, $) => $(inst.stateList).value.length,
              );

              countRender++;

              return ListView.builder(
                itemCount: len,
                itemBuilder: (context, index) {
                  return Builder(
                    builder: (context) {
                      final item = context.select(
                        (_, $) {
                          return $(instanceObtained.stateList)
                              .value
                              .elementAtOrNull(index);
                        },
                      );

                      return Text("item[$index]: $item");
                    },
                  );
                },
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expectLater(instanceObtained, isInstanceOf<TestController>());
      expect(countRender, 1);
      expect(find.text("item[0]: test"), findsNothing);

      instanceObtained.stateList.update(() {
        instanceObtained.stateList.value.add('test');
      });
      await tester.pumpAndSettle();

      expect(countRender, 2);
      expect(find.text("item[0]: test"), findsOneWidget);

      instanceObtained.stateList.value.add('test2');
      await tester.pumpAndSettle();

      expect(countRender, 2);
      expect(find.text("item[0]: test"), findsOneWidget);
      expect(find.text("item[1]: test2"), findsNothing);

      instanceObtained.stateList.update();
      await tester.pumpAndSettle();

      expect(countRender, 3);
      expect(find.text("item[0]: test"), findsOneWidget);
      expect(find.text("item[1]: test2"), findsOneWidget);

      instanceObtained.stateList.value[0] = 'test*';
      instanceObtained.stateList.update();
      await tester.pumpAndSettle();

      expect(countRender, 3);
      expect(find.text("item[0]: test*"), findsOneWidget);
      expect(find.text("item[1]: test2"), findsOneWidget);
    });
  });
}
