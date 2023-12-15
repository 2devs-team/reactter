part of '../extensions.dart';

/// Exposes methods to helps to get and listen the Object instance.
extension ReactterBuildContextExtension on BuildContext {
  /// Uses the [selector] callback(first argument), for determining if
  /// the widget tree of [context] needs to be rebuild by comparing
  /// the previous and new result of [selector], and returns it.
  /// This evaluation only occurs if one of the selected [ReactterState]s gets updated,
  /// or by the instance if the [selector] does not have any selected [ReactterState]s.
  ///
  /// The [selector] callback has a two arguments, the first one is
  /// the instance of [T] type which is obtained from the closest ancestor
  /// of [ReactterProvider] and the second one is a [Select] function which
  /// allows to wrapper any [ReactterState]s to listen.
  ///
  /// ```dart
  /// final int value = context.select<MyController, int>(
  ///   (inst, $) => $(inst.stateA).value.length,
  /// );
  /// // more that one states can be wrapped with Select($):
  /// final String value = context.select<MyController, String>(
  ///   (inst, $) {
  ///     final stateA = $(inst.stateA).value.trim();
  ///     final stateB = $(inst.stateB).value.trim();
  ///
  ///     return '$stateA $stateB';
  ///   },
  /// );
  /// // or simply don´t use Select($) and react with to any changes in the instance(low performance)
  /// final int value = context.select<MyController, int>(
  ///   (inst, $) => inst.stateA.value.length,
  /// );
  /// ```
  ///
  /// If [T] is not defined and [ReactterScope] is not found,
  /// will throw [ReactterScopeNotFoundException].
  ///
  /// If [T] is non-nullable and the instance obtained returned `null`,
  /// will throw [ReactterInstanceNotFoundException].
  ///
  /// If [T] is nullable and no matching instance is found,
  /// [Selector] first argument will return `null`.
  ///
  /// This method is equivalent to calling:
  ///
  /// ```dart
  /// ReactterSelector.contextOf<T>(context, selector, id);
  /// ```
  R select<T extends Object?, R>(
    Selector<T, R> selector, [
    String? id,
  ]) {
    return ReactterSelector.contextOf(this, id: id, selector: selector);
  }

  /// Gets the instance of [T] type from the closest ancestor [ReactterProvider]
  /// and listens changes to the instance or the states([ReactterState]) defined
  /// in first parameter([listenStates]) to trigger rebuild of the Widget tree.
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
  /// to trigger rebuild of the Widget tree.
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
  /// from the closest ancestor [ReactterProvider].
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
