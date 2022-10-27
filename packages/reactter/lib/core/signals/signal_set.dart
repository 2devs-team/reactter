part of '../../core.dart';

extension SignalSetExt<E> on Signal<Set<E>> {
  /// Adds [value] to the set.
  ///
  /// Returns `true` if [value] (or an equal value) was not yet in the set.
  /// Otherwise returns `false` and the set is not changed.
  ///
  /// Example:
  /// ```dart
  /// final dateTimes = <DateTime>{};
  /// final time1 = DateTime.fromMillisecondsSinceEpoch(0);
  /// final time2 = DateTime.fromMillisecondsSinceEpoch(0);
  /// // time1 and time2 are equal, but not identical.
  /// assert(time1 == time2);
  /// assert(!identical(time1, time2));
  /// final time1Added = dateTimes.add(time1);
  /// print(time1Added); // true
  /// // A value equal to time2 exists already in the set, and the call to
  /// // add doesn't change the set.
  /// final time2Added = dateTimes.add(time2);
  /// print(time2Added); // false
  ///
  /// print(dateTimes); // {1970-01-01 02:00:00.000}
  /// assert(dateTimes.length == 1);
  /// assert(identical(time1, dateTimes.first));
  /// print(dateTimes.length);
  /// ```
  bool add(E valueToAdd) {
    late bool _result;
    update((_) => _result = value.add(valueToAdd));
    return _result;
  }

  /// Adds all [elements] to this set.
  ///
  /// Equivalent to adding each element in [elements] using [add],
  /// but some collections may be able to optimize it.
  /// ```dart
  /// final characters = <String>{'A', 'B'};
  /// characters.addAll({'A', 'B', 'C'});
  /// print(characters); // {A, B, C}
  /// ```
  void addAll(Iterable<E> elements) => update((_) => value.addAll(elements));

  /// Removes [value] from the set.
  ///
  /// Returns `true` if [value] was in the set, and `false` if not.
  /// The method has no effect if [value] was not in the set.
  /// ```dart
  /// final characters = <String>{'A', 'B', 'C'};
  /// final didRemoveB = characters.remove('B'); // true
  /// final didRemoveD = characters.remove('D'); // false
  /// print(characters); // {A, C}
  /// ```
  bool remove(Object? valueToRemove) {
    late bool _result;
    update((_) => _result = value.remove(valueToRemove));
    return _result;
  }

  /// Removes each element of [elements] from this set.
  /// ```dart
  /// final characters = <String>{'A', 'B', 'C'};
  /// characters.removeAll({'A', 'B', 'X'});
  /// print(characters); // {C}
  /// ```
  void removeAll(Iterable<Object?> elements) =>
      update((_) => value.removeAll(elements));

  /// Removes all elements of this set that are not elements in [elements].
  ///
  /// Checks for each element of [elements] whether there is an element in this
  /// set that is equal to it (according to `this.contains`), and if so, the
  /// equal element in this set is retained, and elements that are not equal
  /// to any element in [elements] are removed.
  /// ```dart
  /// final characters = <String>{'A', 'B', 'C'};
  /// characters.retainAll({'A', 'B', 'X'});
  /// print(characters); // {A, B}
  /// ```
  void retainAll(Iterable<Object?> elements) =>
      update((_) => value.retainAll(elements));

  /// Removes all elements of this set that satisfy [test].
  /// ```dart
  /// final characters = <String>{'A', 'B', 'C'};
  /// characters.removeWhere((element) => element.startsWith('B'));
  /// print(characters); // {A, C}
  /// ```
  void removeWhere(bool test(E element)) =>
      update((_) => value.removeWhere(test));

  /// Removes all elements of this set that fail to satisfy [test].
  /// ```dart
  /// final characters = <String>{'A', 'B', 'C'};
  /// characters.retainWhere(
  ///     (element) => element.startsWith('B') || element.startsWith('C'));
  /// print(characters); // {B, C}
  /// ```
  void retainWhere(bool test(E element)) =>
      update((_) => value.removeWhere(test));

  /// Removes all elements from the set.
  /// ```dart
  /// final characters = <String>{'A', 'B', 'C'};
  /// characters.clear(); // {}
  /// ```
  void clear() => update((_) => value.clear());
}

extension SignalSetNullExt<E> on Signal<Set<E>?> {
  /// Adds [value] to the set.
  ///
  /// Returns `true` if [value] (or an equal value) was not yet in the set.
  /// Otherwise returns `false` and the set is not changed.
  ///
  /// Example:
  /// ```dart
  /// final dateTimes = <DateTime>{};
  /// final time1 = DateTime.fromMillisecondsSinceEpoch(0);
  /// final time2 = DateTime.fromMillisecondsSinceEpoch(0);
  /// // time1 and time2 are equal, but not identical.
  /// assert(time1 == time2);
  /// assert(!identical(time1, time2));
  /// final time1Added = dateTimes.add(time1);
  /// print(time1Added); // true
  /// // A value equal to time2 exists already in the set, and the call to
  /// // add doesn't change the set.
  /// final time2Added = dateTimes.add(time2);
  /// print(time2Added); // false
  ///
  /// print(dateTimes); // {1970-01-01 02:00:00.000}
  /// assert(dateTimes.length == 1);
  /// assert(identical(time1, dateTimes.first));
  /// print(dateTimes.length);
  /// ```
  bool? add(E valueToAdd) {
    if (value == null) return null;
    late bool _result;
    update((_) => _result = value!.add(valueToAdd));
    return _result;
  }

  /// Adds all [elements] to this set.
  ///
  /// Equivalent to adding each element in [elements] using [add],
  /// but some collections may be able to optimize it.
  /// ```dart
  /// final characters = <String>{'A', 'B'};
  /// characters.addAll({'A', 'B', 'C'});
  /// print(characters); // {A, B, C}
  /// ```
  void addAll(Iterable<E> elements) {
    if (value == null) return null;
    update((_) => value!.addAll(elements));
  }

  /// Removes [value] from the set.
  ///
  /// Returns `true` if [value] was in the set, and `false` if not.
  /// The method has no effect if [value] was not in the set.
  /// ```dart
  /// final characters = <String>{'A', 'B', 'C'};
  /// final didRemoveB = characters.remove('B'); // true
  /// final didRemoveD = characters.remove('D'); // false
  /// print(characters); // {A, C}
  /// ```
  bool? remove(Object? valueToRemove) {
    if (value == null) return null;
    late bool _result;
    update((_) => _result = value!.remove(valueToRemove));
    return _result;
  }

  /// Removes each element of [elements] from this set.
  /// ```dart
  /// final characters = <String>{'A', 'B', 'C'};
  /// characters.removeAll({'A', 'B', 'X'});
  /// print(characters); // {C}
  /// ```
  void removeAll(Iterable<Object?> elements) {
    if (value == null) return null;
    update((_) => value!.removeAll(elements));
  }

  /// Removes all elements of this set that are not elements in [elements].
  ///
  /// Checks for each element of [elements] whether there is an element in this
  /// set that is equal to it (according to `this.contains`), and if so, the
  /// equal element in this set is retained, and elements that are not equal
  /// to any element in [elements] are removed.
  /// ```dart
  /// final characters = <String>{'A', 'B', 'C'};
  /// characters.retainAll({'A', 'B', 'X'});
  /// print(characters); // {A, B}
  /// ```
  void retainAll(Iterable<Object?> elements) {
    if (value == null) return null;
    update((_) => value!.retainAll(elements));
  }

  /// Removes all elements of this set that satisfy [test].
  /// ```dart
  /// final characters = <String>{'A', 'B', 'C'};
  /// characters.removeWhere((element) => element.startsWith('B'));
  /// print(characters); // {A, C}
  /// ```
  void removeWhere(bool test(E element)) {
    if (value == null) return null;
    update((_) => value!.removeWhere(test));
  }

  /// Removes all elements of this set that fail to satisfy [test].
  /// ```dart
  /// final characters = <String>{'A', 'B', 'C'};
  /// characters.retainWhere(
  ///     (element) => element.startsWith('B') || element.startsWith('C'));
  /// print(characters); // {B, C}
  /// ```
  void retainWhere(bool test(E element)) {
    if (value == null) return null;
    update((_) => value!.removeWhere(test));
  }

  /// Removes all elements from the set.
  /// ```dart
  /// final characters = <String>{'A', 'B', 'C'};
  /// characters.clear(); // {}
  /// ```
  void clear() {
    if (value == null) return null;
    update((_) => value!.clear());
  }
}
