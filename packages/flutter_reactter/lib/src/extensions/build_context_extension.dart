part of '../extensions.dart';

/// Exposes methods to helps to get and listen the Object instance.
extension ReactterBuildContextExtension on BuildContext {
  /// Gets the instance of [T] type from the closest ancestor of [ReactterProvider]
  /// and listens changes to the instance or the states([ReactterState]) defined
  /// in first parameter([listenStates]) to trigger re-render of the Widget tree.
  ///
  /// ```dart
  /// final appController = context.watch<AppController>();
  /// final appControllerWatchStates = context.watch<AppController>(
  ///   (inst) => [inst.stateA],
  /// );
  /// final appControllerNullable = context.wath<AppController?>();
  /// ```
  ///
  /// If [T] is nullable and no matching instance is found,
  /// [watch] will return `null`.
  ///
  /// If [T] is non-nullable and the instance obtained returned `null`,
  /// will throw [ProviderNullException].
  ///
  /// This method is equivalent to calling:
  ///
  /// ```dart
  /// ReactterProvider.contextOf<T>(context, listenStates: listenStates);
  /// ```
  T watch<T extends Object?>([ListenStates<T>? listenStates]) {
    return ReactterProvider.contextOf<T>(this, listenStates: listenStates);
  }

  /// Gets the instance of [T] type by [id] from the closest ancestor
  /// of [ReactterProvider] and watchs changes to the instance or
  /// the states([ReactterState]) defined in first parameter([listenStates])
  /// to trigger re-render of the Widget tree.
  ///
  /// ```dart
  /// final appController = context.watchId<AppController>("UniqueId");
  /// final appControllerWatchHook = context.watchId<AppController>(
  ///   "UniqueId",
  ///   (inst) => [inst.stateA],
  /// );
  /// final appControllerNullable = context.wathId<AppController?>("UniqueId");
  /// ```
  ///
  /// If [T] is nullable and no matching instance is found,
  /// [watchId] will return `null`.
  ///
  /// If [T] is non-nullable and the instance obtained returned `null`,
  /// will throw [ProviderNullException].
  ///
  /// This method is equivalent to calling:
  ///
  /// ```dart
  /// ReactterProvider.contextOf<T>(context, id: id, listenStates: listenStates);
  /// ```
  T watchId<T extends Object?>(
    String id, [
    ListenStates<T>? listenStates,
  ]) {
    return ReactterProvider.contextOf<T>(
      this,
      id: id,
      listenStates: listenStates,
    );
  }

  /// Gets the instance of [T] type with/without [id]
  /// from the closest ancestor of [ReactterProvider].
  ///
  /// ```dart
  /// final appController = context.use<AppController>();
  /// final appControllerId = context.use<AppController>('uniqueId');
  /// final appControllerNullable = context.use<AppController?>();
  /// ```
  ///
  /// If [T] is nullable and no matching instance is found,
  /// [use] will return `null`.
  ///
  /// If [T] is non-nullable and the instance obtained returned `null`,
  /// will throw [ProviderNullException].
  ///
  /// This method is equivalent to calling:
  ///
  /// ```dart
  /// ReactterProvider.contextOf<T>(context, id: id, listen: false);
  /// ```
  T use<T extends Object?>([String? id]) {
    return ReactterProvider.contextOf<T>(this, id: id, listen: false);
  }
}
