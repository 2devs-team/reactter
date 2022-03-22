library reactter;

class ReactterFactory {
  static final ReactterFactory _reactterFactory = ReactterFactory._();

  factory ReactterFactory() {
    return _reactterFactory;
  }

  ReactterFactory._();

  Map<Type, Object Function()> constructors = {};
  Map<Type, List<Object>> instances = {};
  Map<Type, List<int>> instancesRunning = {};

  void register<T extends Object>(T Function() creator) {
    _reactterFactory.constructors.addEntries([MapEntry(T, creator)]);
  }

  bool isRegistered<T extends Object>() {
    return _reactterFactory.instances[T] != null;
  }

  T? getInstance<T extends Object>([
    int? hashCode,
    bool create = false,
    String from = "",
  ]) {
    print('[REACTTER] getInstance called from ' + from);
    if (!isRegistered<T>()) {
      final creator = _reactterFactory.constructors[T];

      if (creator == null) {
        return null;
      }

      _reactterFactory.instances[T] ??= [];
      _reactterFactory.instances[T]?.add(creator());

      if (hashCode != null) {
        _reactterFactory.instancesRunning[T] ??= [];
        _reactterFactory.instancesRunning[T]?.add(hashCode);
      }
    }

    if (create) {
      final creator = _reactterFactory.constructors[T];

      _reactterFactory.instances[T] ??= [];
      _reactterFactory.instances[T]?.add(creator!());

      print("[REACTTER] Instance has been created from getInstance");
    }

    // final test = _reactterFactory.instances;

    // final instances = _reactterFactory.instances[T];
    // final instancesRunning = _reactterFactory.instancesRunning[T];

    final instance = _reactterFactory.instances[T]?.last;

    return instance as T;
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
