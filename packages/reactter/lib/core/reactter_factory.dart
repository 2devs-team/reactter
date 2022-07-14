part of '../core.dart';

/// A factory manager
class ReactterFactory {
  static final ReactterFactory _reactterFactory = ReactterFactory._();

  factory ReactterFactory() {
    return _reactterFactory;
  }

  ReactterFactory._();

  // All ReactterInstanceManager´s instances
  HashSet<ReactterInstance> instances = HashSet<ReactterInstance>();

  /// All UseEvent's events.
  HashMap<Object?, HashMap<Enum, Set<Function>>> events = HashMap();
}
