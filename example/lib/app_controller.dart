// ignore_for_file: avoid_print

import 'package:reactter/reactter.dart';
import 'package:reactter/utils/helpers/reactter_future_helper.dart';

class AppController extends ReactterController {
  late Reactter<int> counter = useState(
    'counter',
    700,
    willUpdate: (prev, _) => {
      print("Before update!"),
    },
    didUpdate: (_, n) => {
      print("After update!"),
    },
  );

  Future<void> getData() async {
    await callAsync(() async {
      await delay(2000);
      print("Data getted!");
    });
  }

  void onClick() async {
    // await getData();
    counter.value = counter.value + 1;
  }
}
