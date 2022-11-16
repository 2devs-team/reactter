// coverage:ignore-file
part of '../../core.dart';

extension ObjMapExt<K, V> on Obj<Map<K, V>> {
  /// Provides a view of this map as having [RK] keys and [RV] instances,
  /// if necessary.
  ///
  /// If this map is already a `Map<RK, RV>`, it is returned unchanged.
  ///
  /// If this set contains only keys of type [RK] and values of type [RV],
  /// all read operations will work correctly.
  /// If any operation exposes a non-[RK] key or non-[RV] value,
  /// the operation will throw instead.
  ///
  /// Entries added to the map must be valid for both a `Map<K, V>` and a
  /// `Map<RK, RV>`.
  ///
  /// Methods which accept `Object?` as argument,
  /// like [containsKey], [remove] and [operator []],
  /// will pass the argument directly to the this map's method
  /// without any checks.
  /// That means that you can do `mapWithStringKeys.cast<int,int>().remove("a")`
  /// successfully, even if it looks like it shouldn't have any effect.
  Map<RK, RV> cast<RK, RV>() => value.cast<RK, RV>();

  /// Whether this map contains the given [value].
  ///
  /// Returns true if any of the values in the map are equal to `value`
  /// according to the `==` operator.
  /// ```dart
  /// final moonCount = <String, int>{'Mercury': 0, 'Venus': 0, 'Earth': 1,
  ///   'Mars': 2, 'Jupiter': 79, 'Saturn': 82, 'Uranus': 27, 'Neptune': 14 };
  /// final moons3 = moonCount.containsValue(3); // false
  /// final moons82 = moonCount.containsValue(82); // true
  /// ```
  bool containsValue(Object? valueToEvaluate) =>
      value.containsValue(valueToEvaluate);

  /// Whether this map contains the given [key].
  ///
  /// Returns true if any of the keys in the map are equal to `key`
  /// according to the equality used by the map.
  /// ```dart
  /// final moonCount = <String, int>{'Mercury': 0, 'Venus': 0, 'Earth': 1,
  ///   'Mars': 2, 'Jupiter': 79, 'Saturn': 82, 'Uranus': 27, 'Neptune': 14 };
  /// final containsUranus = moonCount.containsKey('Uranus'); // true
  /// final containsPluto = moonCount.containsKey('Pluto'); // false
  /// ```
  bool containsKey(Object? key) => value.containsKey(key);

  /// The value for the given [key], or `null` if [key] is not in the map.
  ///
  /// Some maps allow `null` as a value.
  /// For those maps, a lookup using this operator cannot distinguish between a
  /// key not being in the map, and the key being there with a `null` value.
  /// Methods like [containsKey] or [putIfAbsent] can be used if the distinction
  /// is important.
  V? operator [](Object? key) => value[key];

  /// Associates the [key] with the given [value].
  ///
  /// If the key was already in the map, its associated value is changed.
  /// Otherwise the key/value pair is added to the map.
  void operator []=(K key, V valueToSet) => value[key] = valueToSet;

  /// The map entries of [this].
  Iterable<MapEntry<K, V>> get entries => value.entries;

  /// Returns a new map where all entries of this map are transformed by
  /// the given [convert] function.
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> convert(K key, V value)) =>
      value.map<K2, V2>(convert);

  /// Adds all key/value pairs of [newEntries] to this map.
  ///
  /// If a key of [newEntries] is already in this map,
  /// the corresponding value is overwritten.
  ///
  /// The operation is equivalent to doing `this[entry.key] = entry.value`
  /// for each [MapEntry] of the iterable.
  /// ```dart
  /// final planets = <int, String>{1: 'Mercury', 2: 'Venus',
  ///   3: 'Earth', 4: 'Mars'};
  /// final gasGiants = <int, String>{5: 'Jupiter', 6: 'Saturn'};
  /// final iceGiants = <int, String>{7: 'Uranus', 8: 'Neptune'};
  /// planets.addEntries(gasGiants.entries);
  /// planets.addEntries(iceGiants.entries);
  /// print(planets);
  /// // {1: Mercury, 2: Venus, 3: Earth, 4: Mars, 5: Jupiter, 6: Saturn,
  /// //  7: Uranus, 8: Neptune}
  /// ```
  void addEntries(Iterable<MapEntry<K, V>> newEntries) =>
      value.addEntries(newEntries);

  /// Updates the value for the provided [key].
  ///
  /// Returns the new value associated with the key.
  ///
  /// If the key is present, invokes [update] with the current value and stores
  /// the new value in the map.
  ///
  /// If the key is not present and [ifAbsent] is provided, calls [ifAbsent]
  /// and adds the key with the returned value to the map.
  ///
  /// If the key is not present, [ifAbsent] must be provided.
  /// ```dart
  /// final planetsFromSun = <int, String>{1: 'Mercury', 2: 'unknown',
  ///   3: 'Earth'};
  /// // Update value for known key value 2.
  /// planetsFromSun.update(2, (value) => 'Venus');
  /// print(planetsFromSun); // {1: Mercury, 2: Venus, 3: Earth}
  ///
  /// final largestPlanets = <int, String>{1: 'Jupiter', 2: 'Saturn',
  ///   3: 'Neptune'};
  /// // Key value 8 is missing from list, add it using [ifAbsent].
  /// largestPlanets.update(8, (value) => 'New', ifAbsent: () => 'Mercury');
  /// print(largestPlanets); // {1: Jupiter, 2: Saturn, 3: Neptune, 8: Mercury}
  /// ```
  V updateMap(K key, V update(V value), {V ifAbsent()?}) =>
      value.update(key, update, ifAbsent: ifAbsent);

  /// Updates all values.
  ///
  /// Iterates over all entries in the map and updates them with the result
  /// of invoking [update].
  /// ```dart
  /// final terrestrial = <int, String>{1: 'Mercury', 2: 'Venus', 3: 'Earth'};
  /// terrestrial.updateAll((key, value) => value.toUpperCase());
  /// print(terrestrial); // {1: MERCURY, 2: VENUS, 3: EARTH}
  /// ```
  void updateAll(V update(K key, V value)) => value.updateAll(update);

  /// Removes all entries of this map that satisfy the given [test].
  /// ```dart
  /// final terrestrial = <int, String>{1: 'Mercury', 2: 'Venus', 3: 'Earth'};
  /// terrestrial.removeWhere((key, value) => value.startsWith('E'));
  /// print(terrestrial); // {1: Mercury, 2: Venus}
  /// ```
  void removeWhere(bool test(K key, V value)) => value.removeWhere(test);

  /// Look up the value of [key], or add a new entry if it isn't there.
  ///
  /// Returns the value associated to [key], if there is one.
  /// Otherwise calls [ifAbsent] to get a new value, associates [key] to
  /// that value, and then returns the new value.
  /// ```dart
  /// final diameters = <num, String>{1.0: 'Earth'};
  /// final otherDiameters = <double, String>{0.383: 'Mercury', 0.949: 'Venus'};
  ///
  /// for (final item in otherDiameters.entries) {
  ///   diameters.putIfAbsent(item.key, () => item.value);
  /// }
  /// print(diameters); // {1.0: Earth, 0.383: Mercury, 0.949: Venus}
  ///
  /// // If the key already exists, the current value is returned.
  /// final result = diameters.putIfAbsent(0.383, () => 'Random');
  /// print(result); // Mercury
  /// print(diameters); // {1.0: Earth, 0.383: Mercury, 0.949: Venus}
  /// ```
  /// Calling [ifAbsent] must not add or remove keys from the map.
  V putIfAbsent(K key, V ifAbsent()) => value.putIfAbsent(key, ifAbsent);

  /// Adds all key/value pairs of [other] to this map.
  ///
  /// If a key of [other] is already in this map, its value is overwritten.
  ///
  /// The operation is equivalent to doing `this[key] = value` for each key
  /// and associated value in other. It iterates over [other], which must
  /// therefore not change during the iteration.
  /// ```dart
  /// final planets = <int, String>{1: 'Mercury', 2: 'Earth'};
  /// planets.addAll({5: 'Jupiter', 6: 'Saturn'});
  /// print(planets); // {1: Mercury, 2: Earth, 5: Jupiter, 6: Saturn}
  /// ```
  void addAll(Map<K, V> other) => value.addAll(other);

  /// Removes [key] and its associated value, if present, from the map.
  ///
  /// Returns the value associated with `key` before it was removed.
  /// Returns `null` if `key` was not in the map.
  ///
  /// Note that some maps allow `null` as a value,
  /// so a returned `null` value doesn't always mean that the key was absent.
  /// ```dart
  /// final terrestrial = <int, String>{1: 'Mercury', 2: 'Venus', 3: 'Earth'};
  /// final removedValue = terrestrial.remove(2); // Venus
  /// print(terrestrial); // {1: Mercury, 3: Earth}
  /// ```
  V? remove(Object? key) => value.remove(key);

  /// Removes all entries from the map.
  ///
  /// After this, the map is empty.
  /// ```dart
  /// final planets = <int, String>{1: 'Mercury', 2: 'Venus', 3: 'Earth'};
  /// planets.clear(); // {}
  /// ```
  void clear() => value.clear();

  /// Applies [action] to each key/value pair of the map.
  ///
  /// Calling `action` must not add or remove keys from the map.
  /// ```dart
  /// final planetsByMass = <num, String>{0.81: 'Venus', 1: 'Earth',
  ///   0.11: 'Mars', 17.15: 'Neptune'};
  ///
  /// planetsByMass.forEach((key, value) {
  ///   print('$key: $value');
  ///   // 0.81: Venus
  ///   // 1: Earth
  ///   // 0.11: Mars
  ///   // 17.15: Neptune
  /// });
  /// ```
  void forEach(void action(K key, V value)) => value.forEach(action);

  /// The keys of [this].
  ///
  /// The returned iterable has efficient `length` and `contains` operations,
  /// based on [length] and [containsKey] of the map.
  ///
  /// The order of iteration is defined by the individual `Map` implementation,
  /// but must be consistent between changes to the map.
  ///
  /// Modifying the map while iterating the keys may break the iteration.
  Iterable<K> get keys => value.keys;

  /// The values of [this].
  ///
  /// The values are iterated in the order of their corresponding keys.
  /// This means that iterating [keys] and [values] in parallel will
  /// provide matching pairs of keys and values.
  ///
  /// The returned iterable has an efficient `length` method based on the
  /// [length] of the map. Its [Iterable.contains] method is based on
  /// `==` comparison.
  ///
  /// Modifying the map while iterating the values may break the iteration.
  Iterable<V> get values => value.values;

  /// The number of key/value pairs in the map.
  int get length => value.length;

  /// Whether there is no key/value pair in the map.
  bool get isEmpty => value.isEmpty;

  /// Whether there is at least one key/value pair in the map.
  bool get isNotEmpty => value.isNotEmpty;
}

extension ObjMapNullExt<K, V> on Obj<Map<K, V>?> {
  /// Provides a view of this map as having [RK] keys and [RV] instances,
  /// if necessary.
  ///
  /// If this map is already a `Map<RK, RV>`, it is returned unchanged.
  ///
  /// If this set contains only keys of type [RK] and values of type [RV],
  /// all read operations will work correctly.
  /// If any operation exposes a non-[RK] key or non-[RV] value,
  /// the operation will throw instead.
  ///
  /// Entries added to the map must be valid for both a `Map<K, V>` and a
  /// `Map<RK, RV>`.
  ///
  /// Methods which accept `Object?` as argument,
  /// like [containsKey], [remove] and [operator []],
  /// will pass the argument directly to the this map's method
  /// without any checks.
  /// That means that you can do `mapWithStringKeys.cast<int,int>().remove("a")`
  /// successfully, even if it looks like it shouldn't have any effect.
  Map<RK, RV>? cast<RK, RV>() => value?.cast<RK, RV>();

  /// Whether this map contains the given [value].
  ///
  /// Returns true if any of the values in the map are equal to `value`
  /// according to the `==` operator.
  /// ```dart
  /// final moonCount = <String, int>{'Mercury': 0, 'Venus': 0, 'Earth': 1,
  ///   'Mars': 2, 'Jupiter': 79, 'Saturn': 82, 'Uranus': 27, 'Neptune': 14 };
  /// final moons3 = moonCount.containsValue(3); // false
  /// final moons82 = moonCount.containsValue(82); // true
  /// ```
  bool? containsValue(Object? valueToEvaluate) =>
      value?.containsValue(valueToEvaluate);

  /// Whether this map contains the given [key].
  ///
  /// Returns true if any of the keys in the map are equal to `key`
  /// according to the equality used by the map.
  /// ```dart
  /// final moonCount = <String, int>{'Mercury': 0, 'Venus': 0, 'Earth': 1,
  ///   'Mars': 2, 'Jupiter': 79, 'Saturn': 82, 'Uranus': 27, 'Neptune': 14 };
  /// final containsUranus = moonCount.containsKey('Uranus'); // true
  /// final containsPluto = moonCount.containsKey('Pluto'); // false
  /// ```
  bool? containsKey(Object? key) => value?.containsKey(key);

  /// The value for the given [key], or `null` if [key] is not in the map.
  ///
  /// Some maps allow `null` as a value.
  /// For those maps, a lookup using this operator cannot distinguish between a
  /// key not being in the map, and the key being there with a `null` value.
  /// Methods like [containsKey] or [putIfAbsent] can be used if the distinction
  /// is important.
  V? operator [](Object? key) => value?[key];

  /// Associates the [key] with the given [value].
  ///
  /// If the key was already in the map, its associated value is changed.
  /// Otherwise the key/value pair is added to the map.
  void operator []=(K key, V valueToSet) => value?[key] = valueToSet;

  /// The map entries of [this].
  Iterable<MapEntry<K, V>>? get entries => value?.entries;

  /// Returns a new map where all entries of this map are transformed by
  /// the given [convert] function.
  Map<K2, V2>? map<K2, V2>(MapEntry<K2, V2> convert(K key, V value)) =>
      value?.map<K2, V2>(convert);

  /// Adds all key/value pairs of [newEntries] to this map.
  ///
  /// If a key of [newEntries] is already in this map,
  /// the corresponding value is overwritten.
  ///
  /// The operation is equivalent to doing `this[entry.key] = entry.value`
  /// for each [MapEntry] of the iterable.
  /// ```dart
  /// final planets = <int, String>{1: 'Mercury', 2: 'Venus',
  ///   3: 'Earth', 4: 'Mars'};
  /// final gasGiants = <int, String>{5: 'Jupiter', 6: 'Saturn'};
  /// final iceGiants = <int, String>{7: 'Uranus', 8: 'Neptune'};
  /// planets.addEntries(gasGiants.entries);
  /// planets.addEntries(iceGiants.entries);
  /// print(planets);
  /// // {1: Mercury, 2: Venus, 3: Earth, 4: Mars, 5: Jupiter, 6: Saturn,
  /// //  7: Uranus, 8: Neptune}
  /// ```
  void addEntries(Iterable<MapEntry<K, V>> newEntries) =>
      value?.addEntries(newEntries);

  /// Updates the value for the provided [key].
  ///
  /// Returns the new value associated with the key.
  ///
  /// If the key is present, invokes [update] with the current value and stores
  /// the new value in the map.
  ///
  /// If the key is not present and [ifAbsent] is provided, calls [ifAbsent]
  /// and adds the key with the returned value to the map.
  ///
  /// If the key is not present, [ifAbsent] must be provided.
  /// ```dart
  /// final planetsFromSun = <int, String>{1: 'Mercury', 2: 'unknown',
  ///   3: 'Earth'};
  /// // Update value for known key value 2.
  /// planetsFromSun.update(2, (value) => 'Venus');
  /// print(planetsFromSun); // {1: Mercury, 2: Venus, 3: Earth}
  ///
  /// final largestPlanets = <int, String>{1: 'Jupiter', 2: 'Saturn',
  ///   3: 'Neptune'};
  /// // Key value 8 is missing from list, add it using [ifAbsent].
  /// largestPlanets.update(8, (value) => 'New', ifAbsent: () => 'Mercury');
  /// print(largestPlanets); // {1: Jupiter, 2: Saturn, 3: Neptune, 8: Mercury}
  /// ```
  V? updateMap(K key, V update(V value), {V ifAbsent()?}) =>
      value?.update(key, update, ifAbsent: ifAbsent);

  /// Updates all values.
  ///
  /// Iterates over all entries in the map and updates them with the result
  /// of invoking [update].
  /// ```dart
  /// final terrestrial = <int, String>{1: 'Mercury', 2: 'Venus', 3: 'Earth'};
  /// terrestrial.updateAll((key, value) => value.toUpperCase());
  /// print(terrestrial); // {1: MERCURY, 2: VENUS, 3: EARTH}
  /// ```
  void updateAll(V update(K key, V value)) => value?.updateAll(update);

  /// Removes all entries of this map that satisfy the given [test].
  /// ```dart
  /// final terrestrial = <int, String>{1: 'Mercury', 2: 'Venus', 3: 'Earth'};
  /// terrestrial.removeWhere((key, value) => value.startsWith('E'));
  /// print(terrestrial); // {1: Mercury, 2: Venus}
  /// ```
  void removeWhere(bool test(K key, V value)) => value?.removeWhere(test);

  /// Look up the value of [key], or add a new entry if it isn't there.
  ///
  /// Returns the value associated to [key], if there is one.
  /// Otherwise calls [ifAbsent] to get a new value, associates [key] to
  /// that value, and then returns the new value.
  /// ```dart
  /// final diameters = <num, String>{1.0: 'Earth'};
  /// final otherDiameters = <double, String>{0.383: 'Mercury', 0.949: 'Venus'};
  ///
  /// for (final item in otherDiameters.entries) {
  ///   diameters.putIfAbsent(item.key, () => item.value);
  /// }
  /// print(diameters); // {1.0: Earth, 0.383: Mercury, 0.949: Venus}
  ///
  /// // If the key already exists, the current value is returned.
  /// final result = diameters.putIfAbsent(0.383, () => 'Random');
  /// print(result); // Mercury
  /// print(diameters); // {1.0: Earth, 0.383: Mercury, 0.949: Venus}
  /// ```
  /// Calling [ifAbsent] must not add or remove keys from the map.
  V? putIfAbsent(K key, V ifAbsent()) => value?.putIfAbsent(key, ifAbsent);

  /// Adds all key/value pairs of [other] to this map.
  ///
  /// If a key of [other] is already in this map, its value is overwritten.
  ///
  /// The operation is equivalent to doing `this[key] = value` for each key
  /// and associated value in other. It iterates over [other], which must
  /// therefore not change during the iteration.
  /// ```dart
  /// final planets = <int, String>{1: 'Mercury', 2: 'Earth'};
  /// planets.addAll({5: 'Jupiter', 6: 'Saturn'});
  /// print(planets); // {1: Mercury, 2: Earth, 5: Jupiter, 6: Saturn}
  /// ```
  void addAll(Map<K, V> other) => value?.addAll(other);

  /// Removes [key] and its associated value, if present, from the map.
  ///
  /// Returns the value associated with `key` before it was removed.
  /// Returns `null` if `key` was not in the map.
  ///
  /// Note that some maps allow `null` as a value,
  /// so a returned `null` value doesn't always mean that the key was absent.
  /// ```dart
  /// final terrestrial = <int, String>{1: 'Mercury', 2: 'Venus', 3: 'Earth'};
  /// final removedValue = terrestrial.remove(2); // Venus
  /// print(terrestrial); // {1: Mercury, 3: Earth}
  /// ```
  V? remove(Object? key) => value?.remove(key);

  /// Removes all entries from the map.
  ///
  /// After this, the map is empty.
  /// ```dart
  /// final planets = <int, String>{1: 'Mercury', 2: 'Venus', 3: 'Earth'};
  /// planets.clear(); // {}
  /// ```
  void clear() => value?.clear();

  /// Applies [action] to each key/value pair of the map.
  ///
  /// Calling `action` must not add or remove keys from the map.
  /// ```dart
  /// final planetsByMass = <num, String>{0.81: 'Venus', 1: 'Earth',
  ///   0.11: 'Mars', 17.15: 'Neptune'};
  ///
  /// planetsByMass.forEach((key, value) {
  ///   print('$key: $value');
  ///   // 0.81: Venus
  ///   // 1: Earth
  ///   // 0.11: Mars
  ///   // 17.15: Neptune
  /// });
  /// ```
  void forEach(void action(K key, V value)) => value?.forEach(action);

  /// The keys of [this].
  ///
  /// The returned iterable has efficient `length` and `contains` operations,
  /// based on [length] and [containsKey] of the map.
  ///
  /// The order of iteration is defined by the individual `Map` implementation,
  /// but must be consistent between changes to the map.
  ///
  /// Modifying the map while iterating the keys may break the iteration.
  Iterable<K>? get keys => value?.keys;

  /// The values of [this].
  ///
  /// The values are iterated in the order of their corresponding keys.
  /// This means that iterating [keys] and [values] in parallel will
  /// provide matching pairs of keys and values.
  ///
  /// The returned iterable has an efficient `length` method based on the
  /// [length] of the map. Its [Iterable.contains] method is based on
  /// `==` comparison.
  ///
  /// Modifying the map while iterating the values may break the iteration.
  Iterable<V>? get values => value?.values;

  /// The number of key/value pairs in the map.
  int? get length => value?.length;

  /// Whether there is no key/value pair in the map.
  bool? get isEmpty => value?.isEmpty;

  /// Whether there is at least one key/value pair in the map.
  bool? get isNotEmpty => value?.isNotEmpty;
}
