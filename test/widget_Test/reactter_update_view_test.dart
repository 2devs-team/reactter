import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reactter/reactter.dart';

void main() {
  testWidgets(
    'GIVEN user with name Leo WHEN age is setted to 50 THEN age is 50',
    (WidgetTester tester) async {
      // ASSEMLE
      await tester.pumpWidget(
        const App(),
      );

      final button = find.byType(FloatingActionButton);

      // ACT
      await tester.tap(button);
      await tester.pump();

      // ASSERT
      final text = find.text("User: Leo, Age: 50");
      expect(text, findsOneWidget);
    },
  );
}

class UserContext extends ReactterContext {
  late final name = UseState<String>("Leo", this);
  late final age = UseState<int>(26, this);
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ReactterProvider(
        contexts: [
          UseContext(() => UserContext(), init: true),
        ],
        builder: (context, _) {
          final userContext = context.of<UserContext>();

          return Column(
            children: [
              FloatingActionButton(
                onPressed: () {
                  userContext.age.value = 50;
                },
              ),
              Text(
                  "User: ${userContext.name.value}, Age: ${userContext.age.value}")
            ],
          );
        },
      ),
    );
  }
}
