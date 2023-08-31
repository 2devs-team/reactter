part of '../framework.dart';

/// A class that represents an argument
class Arg<A> {
  final A arg;

  const Arg(this.arg);

  /// Returns a list containing all arguments.
  ///
  /// It allows access to these properties as a list,
  ///which can be useful for operations that require a list of arguments.
  List get arguments => [arg];

  /// Creates a new list with all [arguments] that have type [T].
  List<T> toList<T>() {
    return List<T>.from(arguments.whereType<T>());
  }
}

/// A class that represents a set of two arguments.
class Args2<A, A2> extends Arg<A> {
  final A2 arg2;

  const Args2(A arg, this.arg2) : super(arg);

  /// Returns a list containing all arguments.
  ///
  /// It allows access to these properties as a list,
  ///which can be useful for operations that require a list of arguments.
  @override
  List get arguments => [arg, arg2];
}

/// A class that represents a set of three arguments.
class Args3<A, A2, A3> extends Args2<A, A2> {
  final A3 arg3;

  const Args3(A arg, A2 arg2, this.arg3) : super(arg, arg2);

  /// Returns a list containing all arguments.
  ///
  /// It allows access to these properties as a list,
  ///which can be useful for operations that require a list of arguments.
  @override
  List get arguments => [arg, arg2, arg3];
}
