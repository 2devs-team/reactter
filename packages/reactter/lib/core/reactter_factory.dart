part of '../core.dart';

/// A factory manager
class ReactterFactory {
  static final ReactterFactory _reactterFactory = ReactterFactory._();

  factory ReactterFactory() {
    return _reactterFactory;
  }

  ReactterFactory._();

  /// Stores all instances.
  HashSet<ReactterInstance> instances = HashSet<ReactterInstance>();
}
