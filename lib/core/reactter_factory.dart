library reactter;

class ReactterFactory {
  static final ReactterFactory _reactterFactory = ReactterFactory._();

  factory ReactterFactory() {
    return _reactterFactory;
  }

  ReactterFactory._();

  Map<Type, Object Function()> constructors = {};
  Map<Type, Object> instances = {};

  void register<T extends Object>(T Function() creator) {
    _reactterFactory.constructors.addEntries([MapEntry(T, creator)]);
  }

  bool isRegistered<T extends Object>() {
    return _reactterFactory.instances[T] != null;
  }

  T? getInstance<T extends Object>() {
    if (!isRegistered<T>()) {
      final creator = _reactterFactory.constructors[T];

      if (creator == null) {
        return null;
      }

      _reactterFactory.instances[T] = creator();
    }

    return _reactterFactory.instances[T] as T;
  }

  // T? getInstance<T extends Object>(T Function() creatorFn) {
  //   if (!isRegistered<T>()) {
  //     final creator = _reactterFactory.constructors[T];

  //     if (creator == null) {
  //       register<T>(creatorFn);

  //       //Recursivo
  //       return getInstance<T>(creatorFn);
  //     }

  //     _reactterFactory.instances[T] = creator();
  //   }

  //   return _reactterFactory.instances[T] as T;
  // }
}
