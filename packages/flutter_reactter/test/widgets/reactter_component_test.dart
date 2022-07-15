import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import '../shareds/reactter_providers_builder.dart';
import '../shareds/test_builder.dart';
import '../shareds/test_context.dart';

void main() {
  group("ReactterComponent", () {
    late TestContext instanceObtained;

    testWidgets("should renders and get instance", (tester) async {
      await tester.pumpWidget(
        TestBuilder(
          child: ReactterComponentTest(
            getInstance: (ctx) {
              instanceObtained = ctx;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text("stateBool: false"), findsOneWidget);
      expect(find.text("stateString: initial"), findsOneWidget);

      instanceObtained.stateBool.value = true;
      instanceObtained.stateString.value = "new value";

      await tester.pumpAndSettle();

      expect(find.text("stateBool: true"), findsOneWidget);
      expect(find.text("stateString: new value"), findsOneWidget);
    });

    testWidgets("should renders and gets instance by id", (tester) async {
      late TestContext instanceObtained;

      await tester.pumpWidget(
        TestBuilder(
          child: ReactterProvidersBuilder(
            builder: (_, __) {
              return ReactterComponentTest(
                id: "uniqueId",
                getInstance: (ctx) {
                  instanceObtained = ctx;
                },
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text("stateBool: false"), findsOneWidget);
      expect(find.text("stateString: from uniqueId"), findsOneWidget);

      instanceObtained.stateBool.value = true;
      instanceObtained.stateString.value = "new value";

      await tester.pumpAndSettle();

      expect(find.text("stateBool: true"), findsOneWidget);
      expect(find.text("stateString: new value"), findsOneWidget);
    });

    testWidgets("should renders and gets instance without builder instance",
        (tester) async {
      late TestContext instanceObtained;

      await tester.pumpWidget(
        TestBuilder(
          child: ReactterProvidersBuilder(
            builder: (_, __) {
              return ReactterComponentTest(
                withoutBuilder: true,
                getInstance: (ctx) {
                  instanceObtained = ctx;
                },
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text("stateBool: false"), findsOneWidget);
      expect(find.text("stateString: initial"), findsOneWidget);

      instanceObtained.stateBool.value = true;
      instanceObtained.stateString.value = "new value";

      await tester.pumpAndSettle();

      expect(find.text("stateBool: true"), findsOneWidget);
      expect(find.text("stateString: new value"), findsOneWidget);
    });
  });
}

class ReactterComponentTest extends ReactterComponent<TestContext> {
  const ReactterComponentTest({
    Key? key,
    this.id,
    this.withoutBuilder = false,
    required this.getInstance,
  }) : super(key: key);

  final void Function(TestContext ctx) getInstance;

  @override
  final String? id;

  final bool withoutBuilder;

  @override
  get builder => withoutBuilder ? null : () => TestContext();

  @override
  get listenHooks => (ctx) => [ctx.stateBool, ctx.stateString];

  @override
  Widget render(TestContext ctx, BuildContext context) {
    getInstance(ctx);

    return Column(
      children: [
        Text("stateBool: ${ctx.stateBool.value}"),
        Text("stateString: ${ctx.stateString.value}"),
      ],
    );
  }
}
