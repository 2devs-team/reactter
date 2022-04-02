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
              dartVmServiceUrl: 'ws://127.0.0.1:49619/ORUFVm-84-s=/ws');
        },
      );

      test(
        'GIVEN a cart user WHEN gotToViewUser button is pressed THEN items in cart 5',
        () async {
          final gotToViewUserButton = find.byValueKey('button_Terrill');

          await driver?.tap(gotToViewUserButton);

          final itemsIncart = find.text('items in cart: 5');

          expect(await driver?.getText(itemsIncart), 'items in cart: 5');
        },
      );

      test(
        'GIVEN 5 items in cart WHEN remove button is pressed THEN items in cart - 1',
        () async {
          final removeButton = find.byValueKey('remove_1');

          // Remove action
          await driver?.tap(removeButton);

          final itemsIncart4 = find.text('items in cart: 4');

          expect(await driver?.getText(itemsIncart4), 'items in cart: 4');

          await Future.delayed(const Duration(milliseconds: 500));

          // Remove action
          await driver?.tap(removeButton);

          final itemsIncart3 = find.text('items in cart: 3');

          expect(await driver?.getText(itemsIncart3), 'items in cart: 3');

          await Future.delayed(const Duration(milliseconds: 500));

          // Remove action
          await driver?.tap(removeButton);

          final itemsIncart2 = find.text('items in cart: 2');

          expect(await driver?.getText(itemsIncart2), 'items in cart: 2');

          await Future.delayed(const Duration(milliseconds: 500));

          // Remove action
          await driver?.tap(removeButton);

          final itemsIncart1 = find.text('items in cart: 1');

          expect(await driver?.getText(itemsIncart1), 'items in cart: 1');

          await Future.delayed(const Duration(milliseconds: 500));

          // Remove action
          await driver?.tap(removeButton);

          final itemsIncart0 = find.text('items in cart: 0');

          expect(await driver?.getText(itemsIncart0), 'items in cart: 0');

          await Future.delayed(const Duration(milliseconds: 500));

          final back = find.pageBack();

          await driver?.tap(back);
        },
      );
    },
  );
}
