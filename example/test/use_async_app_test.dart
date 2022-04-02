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
              timeout: const Duration(
                seconds: 5,
              ),
              dartVmServiceUrl: 'ws://127.0.0.1:52973/cZ9TnqOlf-g=/ws');
        },
      );

      tearDown(
        () async {
          // driver?.close();
        },
      );

      final loadButton = find.byType('ElevatedButton');

      test(
        'GIVEN blanck username WHEN load button is pressed THEN user is filled',
        () async {
          await driver?.tap(loadButton);

          final loadedText = find.text('Username filled');

          expect(await driver?.getText(loadedText), 'Username filled');
        },
      );
    },
  );
}
