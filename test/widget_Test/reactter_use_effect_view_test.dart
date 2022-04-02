// ignore_for_file: avoid_relative_lib_imports

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../example/lib/main.dart';

void main() {
  testWidgets(
    'GIVEN a counter and counterByTwo WHEN any is setted THEN text has to change',
    (WidgetTester tester) async {
      // ASSEMLE
      await tester.pumpWidget(
        const MaterialApp(
          home: ReactterExample(),
        ),
      );

      final resetButton =
          find.widgetWithIcon(FloatingActionButton, Icons.clear);
      final addButton = find.widgetWithIcon(FloatingActionButton, Icons.add);

      // ACT
      await tester.tap(addButton);
      await tester.tap(addButton);
      await tester.tap(addButton);
      await tester.pump();

      // ASSERT
      final counter = find.text("Counter value: 3");
      final counterBy2 = find.text("Counter value * 2: 6");
      expect(counter, findsOneWidget);
      expect(counterBy2, findsOneWidget);

      // ACT
      await tester.tap(resetButton);
      await tester.pump();

      // ASSERT
      final resetedCounter = find.text("Counter value: 0");
      final resetedCounterBy2 = find.text("Counter value * 2: 0");
      expect(resetedCounter, findsOneWidget);
      expect(resetedCounterBy2, findsOneWidget);
    },
  );
}
