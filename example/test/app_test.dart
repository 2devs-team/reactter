import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Reactter',
    () {
      FlutterDriver? driver;

      // When you run the app, need to copy and pase the url of VM Service:
      setUpAll(
        () async {
          driver = await FlutterDriver.connect(
              timeout: const Duration(seconds: 5),
              dartVmServiceUrl: 'ws://127.0.0.1:53989/SfhnLr2d018=/ws');
        },
      );

      tearDown(
        () async {
          // driver?.close();
        },
      );

      final addButton = find.byValueKey('addButton');
      final resetButton = find.byValueKey('resetButton');

      test(
        'GIVEN a counter WHEN any is setted THEN text has to change',
        () async {
          await driver?.tap(addButton);
          await driver?.tap(addButton);
          await driver?.tap(addButton);
          await driver?.tap(addButton);

          final counterText = find.text('Counter value: 4');
          final counterTextBy2 = find.text('Counter value * 2: 8');

          expect(await driver?.getText(counterText), 'Counter value: 4');
          expect(await driver?.getText(counterTextBy2), 'Counter value * 2: 8');
        },
      );

      test(
        'GIVEN a counter WHEN reset button is pressed THEN counter text is 0',
        () async {
          await driver?.tap(resetButton);

          final counterText = find.text('Counter value: 0');
          final counterTextBy2 = find.text('Counter value * 2: 0');

          expect(await driver?.getText(counterText), 'Counter value: 0');
          expect(await driver?.getText(counterTextBy2), 'Counter value * 2: 0');
        },
      );
    },
  );
}
