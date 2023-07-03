// coverage:ignore-file
part of '../objs.dart';

extension ObjSetExt<E> on Obj<Set<E>> {
  /// Provides a view of this set as a set of [R] instances.
  ///
  /// If this set contains only instances of [R], all read operations
  /// will work correctly. If any operation tries to access an element
  /// that is not an instance of [R], the access will throw instead.
  ///
  /// Elements added to the set (e.g., by using [add] or [addAll])
  /// must be instances of [R] to be valid arguments to the adding function,
  /// and they must be instances of [E] as well to be accepted by
  /// this set as well.
  ///
  /// Methods which accept one or more `Object?` as argument,
  /// like [contains], [remove] and [removeAll],
  /// will pass the argument directly to the this set's method
  /// without any checks.
  /// That means that you can do `setOfStrings.cast<int>().remove("a")`
  /// successfully, even if it looks like it shouldn't have any effect.
  Set<R> cast<R>() => value.cast<R>();

  /// An iterator that iterates over the elements of this set.
  ///
  /// The order of iteration is defined by the individual `Set` implementation,
  /// but must be consistent between changes to the set.
  Iterator<E> get iterator => value.iterator;

  /// Whether [value] is in the set.
  /// ```dart
  /// final characters = <String>{'A', 'B', 'C'};
  /// final containsB = characters.contains('B'); // true
  /// final containsD = characters.contains('D'); // false
  /// ```
  bool contains(Object? valueToEvaluate) => value.contains(valueToEvaluate);

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
  bool add(E valueToAdd) => value.add(valueToAdd);

  /// Adds all [elements] to this set.
  ///
  /// Equivalent to adding each element in [elements] using [add],
  /// but some collections may be able to optimize it.
  /// ```dart
  /// final characters = <String>{'A', 'B'};
  /// characters.addAll({'A', 'B', 'C'});
  /// print(characters); // {A, B, C}
  /// ```
  void addAll(Iterable<E> elements) => value.addAll(elements);

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
  bool remove(Object? valueToRemove) => value.remove(valueToRemove);

  /// If an object equal to [object] is in the set, return it.
  ///
  /// Checks whether [object] is in the set, like [contains], and if so,
  /// returns the object in the set, otherwise returns `null`.
  ///
  /// If the equality relation used by the set is not identity,
  /// then the returned object may not be *identical* to [object].
  /// Some set implementations may not be able to implement this method.
  /// If the [contains] method is computed,
  /// rather than being based on an actual object instance,
  /// then there may not be a specific object instance representing the
  /// set element.
  /// ```dart
  /// final characters = <String>{'A', 'B', 'C'};
  /// final containsB = characters.lookup('B');
  /// print(containsB); // B
  /// final containsD = characters.lookup('D');
  /// print(containsD); // null
  /// ```
  E? lookup(Object? object) => value.lookup(object);

  /// Removes each element of [elements] from this set.
  /// ```dart
  /// final characters = <String>{'A', 'B', 'C'};
  /// characters.removeAll({'A', 'B', 'X'});
  /// print(characters); // {C}
  /// ```
  void removeAll(Iterable<Object?> elements) => value.removeAll(elements);

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
  void retainAll(Iterable<Object?> elements) => value.retainAll(elements);

  /// Removes all elements of this set that satisfy [test].
  /// ```dart
  /// final characters = <String>{'A', 'B', 'C'};
  /// characters.removeWhere((element) => element.startsWith('B'));
  /// print(characters); // {A, C}
  /// ```
  void removeWhere(bool test(E element)) => value.removeWhere(test);

  /// Removes all elements of this set that fail to satisfy [test].
  /// ```dart
  /// final characters = <String>{'A', 'B', 'C'};
  /// characters.retainWhere(
  ///     (element) => element.startsWith('B') || element.startsWith('C'));
  /// print(characters); // {B, C}
  /// ```
  void retainWhere(bool test(E element)) => value.removeWhere(test);

  /// Whether this set contains all the elements of [other].
  /// ```dart
  /// final characters = <String>{'A', 'B', 'C'};
  /// final containsAB = characters.containsAll({'A', 'B'});
  /// print(containsAB); // true
  /// final containsAD = characters.containsAll({'A', 'D'});
  /// print(containsAD); // false
  /// ```
  bool containsAll(Iterable<Object?> other) => value.containsAll(other);

  /// Creates a new set which is the intersection between this set and [other].
  ///
  /// That is, the returned set contains all the elements of this [Set] that
  /// are also elements of [other] according to `other.contains`.
  /// ```dart
  /// final characters1 = <String>{'A', 'B', 'C'};
  /// final characters2 = <String>{'A', 'E', 'F'};
  /// final unionSet = characters1.intersection(characters2);
  /// print(unionSet); // {A}
  /// ```
  Set<E> intersection(Set<Object?> other) => value.intersection(other);

  /// Creates a new set which contains all the elements of this set and [other].
  ///
  /// That is, the returned set contains all the elements of this [Set] and
  /// all the elements of [other].
  /// ```dart
  /// final characters1 = <String>{'A', 'B', 'C'};
  /// final characters2 = <String>{'A', 'E', 'F'};
  /// final unionSet1 = characters1.union(characters2);
  /// print(unionSet1); // {A, B, C, E, F}
  /// final unionSet2 = characters2.union(characters1);
  /// print(unionSet2); // {A, E, F, B, C}
  /// ```
  Set<E> union(Set<E> other) => value.union(other);

  /// Creates a new set with the elements of this that are not in [other].
  ///
  /// That is, the returned set contains all the elements of this [Set] that
  /// are not elements of [other] according to `other.contains`.
  /// ```dart
  /// final characters1 = <String>{'A', 'B', 'C'};
  /// final characters2 = <String>{'A', 'E', 'F'};
  /// final differenceSet1 = characters1.difference(characters2);
  /// print(differenceSet1); // {B, C}
  /// final differenceSet2 = characters2.difference(characters1);
  /// print(differenceSet2); // {E, F}
  /// ```
  Set<E> difference(Set<Object?> other) => value.difference(other);

  /// Removes all elements from the set.
  /// ```dart
  /// final characters = <String>{'A', 'B', 'C'};
  /// characters.clear(); // {}
  /// ```
  void clear() => value.clear();

  /// Creates a [Set] with the same elements and behavior as this `Set`.
  ///
  /// The returned set behaves the same as this set
  /// with regard to adding and removing elements.
  /// It initially contains the same elements.
  /// If this set specifies an ordering of the elements,
  /// the returned set will have the same order.
  Set<E> toSet() => value.toSet();
}

extension ObjSetNullExt<E> on Obj<Set<E>?> {
  /// Provides a view of this set as a set of [R] instances.
  ///
  /// If this set contains only instances of [R], all read operations
  /// will work correctly. If any operation tries to access an element
  /// that is not an instance of [R], the access will throw instead.
  ///
  /// Elements added to the set (e.g., by using [add] or [addAll])
  /// must be instances of [R] to be valid arguments to the adding function,
  /// and they must be instances of [E] as well to be accepted by
  /// this set as well.
  ///
  /// Methods which accept one or more `Object?` as argument,
  /// like [contains], [remove] and [removeAll],
  /// will pass the argument directly to the this set's method
  /// without any checks.
  /// That means that you can do `setOfStrings.cast<int>().remove("a")`
  /// successfully, even if it looks like it shouldn't have any effect.
  Set<R>? cast<R>() => value?.cast<R>();

  /// An iterator that iterates over the elements of this set.
  ///
  /// The order of iteration is defined by the individual `Set` implementation,
  /// but must be consistent between changes to the set.
  Iterator<E>? get iterator => value?.iterator;

  /// Whether [value] is in the set.
  /// ```dart
  /// final characters = <String>{'A', 'B', 'C'};
  /// final containsB = characters.contains('B'); // true
  /// final containsD = characters.contains('D'); // false
  /// ```
  bool? contains(Object? valueToEvaluate) => value?.contains(valueToEvaluate);

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
  bool? add(E valueToAdd) => value?.add(valueToAdd);

  /// Adds all [elements] to this set.
  ///
  /// Equivalent to adding each element in [elements] using [add],
  /// but some collections may be able to optimize it.
  /// ```dart
  /// final characters = <String>{'A', 'B'};
  /// characters.addAll({'A', 'B', 'C'});
  /// print(characters); // {A, B, C}
  /// ```
  void addAll(Iterable<E> elements) => value?.addAll(elements);

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
  bool? remove(Object? valueToRemove) => value?.remove(valueToRemove);

  /// If an object equal to [object] is in the set, return it.
  ///
  /// Checks whether [object] is in the set, like [contains], and if so,
  /// returns the object in the set, otherwise returns `null`.
  ///
  /// If the equality relation used by the set is not identity,
  /// then the returned object may not be *identical* to [object].
  /// Some set implementations may not be able to implement this method.
  /// If the [contains] method is computed,
  /// rather than being based on an actual object instance,
  /// then there may not be a specific object instance representing the
  /// set element.
  /// ```dart
  /// final characters = <String>{'A', 'B', 'C'};
  /// final containsB = characters.lookup('B');
  /// print(containsB); // B
  /// final containsD = characters.lookup('D');
  /// print(containsD); // null
  /// ```
  E? lookup(Object? object) => value?.lookup(object);

  /// Removes each element of [elements] from this set.
  /// ```dart
  /// final characters = <String>{'A', 'B', 'C'};
  /// characters.removeAll({'A', 'B', 'X'});
  /// print(characters); // {C}
  /// ```
  void removeAll(Iterable<Object?> elements) => value?.removeAll(elements);

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
  void retainAll(Iterable<Object?> elements) => value?.retainAll(elements);

  /// Removes all elements of this set that satisfy [test].
  /// ```dart
  /// final characters = <String>{'A', 'B', 'C'};
  /// characters.removeWhere((element) => element.startsWith('B'));
  /// print(characters); // {A, C}
  /// ```
  void removeWhere(bool test(E element)) => value?.removeWhere(test);

  /// Removes all elements of this set that fail to satisfy [test].
  /// ```dart
  /// final characters = <String>{'A', 'B', 'C'};
  /// characters.retainWhere(
  ///     (element) => element.startsWith('B') || element.startsWith('C'));
  /// print(characters); // {B, C}
  /// ```
  void retainWhere(bool test(E element)) => value?.removeWhere(test);

  /// Whether this set contains all the elements of [other].
  /// ```dart
  /// final characters = <String>{'A', 'B', 'C'};
  /// final containsAB = characters.containsAll({'A', 'B'});
  /// print(containsAB); // true
  /// final containsAD = characters.containsAll({'A', 'D'});
  /// print(containsAD); // false
  /// ```
  bool? containsAll(Iterable<Object?> other) => value?.containsAll(other);

  /// Creates a new set which is the intersection between this set and [other].
  ///
  /// That is, the returned set contains all the elements of this [Set] that
  /// are also elements of [other] according to `other.contains`.
  /// ```dart
  /// final characters1 = <String>{'A', 'B', 'C'};
  /// final characters2 = <String>{'A', 'E', 'F'};
  /// final unionSet = characters1.intersection(characters2);
  /// print(unionSet); // {A}
  /// ```
  Set<E>? intersection(Set<Object?> other) => value?.intersection(other);

  /// Creates a new set which contains all the elements of this set and [other].
  ///
  /// That is, the returned set contains all the elements of this [Set] and
  /// all the elements of [other].
  /// ```dart
  /// final characters1 = <String>{'A', 'B', 'C'};
  /// final characters2 = <String>{'A', 'E', 'F'};
  /// final unionSet1 = characters1.union(characters2);
  /// print(unionSet1); // {A, B, C, E, F}
  /// final unionSet2 = characters2.union(characters1);
  /// print(unionSet2); // {A, E, F, B, C}
  /// ```
  Set<E>? union(Set<E> other) => value?.union(other);

  /// Creates a new set with the elements of this that are not in [other].
  ///
  /// That is, the returned set contains all the elements of this [Set] that
  /// are not elements of [other] according to `other.contains`.
  /// ```dart
  /// final characters1 = <String>{'A', 'B', 'C'};
  /// final characters2 = <String>{'A', 'E', 'F'};
  /// final differenceSet1 = characters1.difference(characters2);
  /// print(differenceSet1); // {B, C}
  /// final differenceSet2 = characters2.difference(characters1);
  /// print(differenceSet2); // {E, F}
  /// ```
  Set<E>? difference(Set<Object?> other) => value?.difference(other);

  /// Removes all elements from the set.
  /// ```dart
  /// final characters = <String>{'A', 'B', 'C'};
  /// characters.clear(); // {}
  /// ```
  void clear() => value?.clear();

  /// Creates a [Set] with the same elements and behavior as this `Set`.
  ///
  /// The returned set behaves the same as this set
  /// with regard to adding and removing elements.
  /// It initially contains the same elements.
  /// If this set specifies an ordering of the elements,
  /// the returned set will have the same order.
  Set<E>? toSet() => value?.toSet();
}
