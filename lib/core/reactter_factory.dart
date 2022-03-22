library reactter;

class ReactterFactory {
  static final ReactterFactory _reactterFactory = ReactterFactory._();

  factory ReactterFactory() {
    return _reactterFactory;
  }

  ReactterFactory._();

  Map<Type, Object Function()> constructors = {};
  Map<Type, Object> instances = {};
  Map<Type, List<int>> instancesRunning = {};

  void register<T extends Object>(T Function() creator) {
    _reactterFactory.constructors.addEntries([MapEntry(T, creator)]);
  }

  bool isRegistered<T extends Object>() {
    return _reactterFactory.instances[T] != null;
  }

  T? getInstance<T extends Object>([int? hashCode]) {
    if (!isRegistered<T>()) {
      final creator = _reactterFactory.constructors[T];

      if (creator == null) {
        return null;
      }

      _reactterFactory.instances[T] = creator();

      if (hashCode != null) {
        _reactterFactory.instancesRunning[T] ??= [];
        _reactterFactory.instancesRunning[T]?.add(hashCode);
      }
    }

    return _reactterFactory.instances[T] as T;
  }

  destroy<T>([int? hashCode]) {
    _reactterFactory.instancesRunning[T] ??= [];
    _reactterFactory.instancesRunning[T]?.remove(hashCode);

    if ((_reactterFactory.instancesRunning[T] ?? []).isEmpty) {
      _reactterFactory.instances.remove(T);
    }
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
