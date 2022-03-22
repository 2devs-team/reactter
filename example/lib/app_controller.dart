// ignore_for_file: avoid_print

import 'package:reactter/reactter.dart';
import 'package:reactter/utils/helpers/reactter_future_helper.dart';

class AppController extends ReactterController {
  final counter = UseState<int>(
    0,
    willUpdate: (prev, _) => {
      print("Before update!"),
    },
    didUpdate: (_, n) => {
      print("After update!"),
    },
  );

  @override
  onInit() {
    super.onInit();

    // useEffect(() {
    //   //do anything
    // }, [counter]);
  }

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

class StateFactory {
  static final StateFactory _stateFactory = StateFactory._();

  factory StateFactory() {
    return _stateFactory;
  }

  StateFactory._();

  Map<Type, Object Function()> constructors = {};
  Map<Type, Object> instances = {};

  void register<T extends Object>(T Function() creator) {
    _stateFactory.constructors.addEntries([MapEntry(T, creator)]);
  }

  bool isRegistered<T extends Object>() {
    return _stateFactory.instances[T] != null;
  }

  T? getInstance<T extends Object>() {
    if (!isRegistered<T>()) {
      final creator = _stateFactory.constructors[T];

      if (creator == null) {
        return null;
      }

      _stateFactory.instances[T] = creator();
    }

    return _stateFactory.instances[T] as T;
  }
}
