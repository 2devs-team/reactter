part of '../extensions.dart';

/// Exposes methods to helps to get dependency and listen the dependency or states.
extension ReactterBuildContextExtension on BuildContext {
  /// Uses the [selector] callback(first argument), for determining if
  /// the widget tree of [context] needs to be rebuild by comparing
  /// the previous and new result of [selector], and returns it.
  /// This evaluation only occurs if one of the selected [RtState]s gets updated,
  /// or by the dependency if the [selector] does not have any selected [RtState]s.
  ///
  /// The [selector] callback has two parameters, the first one is
  /// the dependency of [T] type which is obtained from the closest ancestor
  /// of [RtProvider] and the second one is a [Select] function which
  /// allows to wrapper any [RtState]s to listen.
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
  /// // or simply don´t use Select($) and react with to any changes in the dependency(low performance)
  /// final int value = context.select<MyController, int>(
  ///   (inst, $) => inst.stateA.value.length,
  /// );
  /// ```
  ///
  /// If [T] is not defined and [RtScope] is not found,
  /// will throw [RtScopeNotFoundException].
  ///
  /// If [T] is non-nullable and the instance of [T] dependency obtained returned `null`,
  /// will throw [RtDependencyNotFoundException].
  ///
  /// If [T] is nullable and no matching dependency is found,
  /// [Selector] first argument will return `null`.
  ///
  /// This method is equivalent to calling:
  ///
  /// ```dart
  /// RtSelector.contextOf<T>(context, selector, id);
  /// ```
  R select<T extends Object?, R>(
    Selector<T, R> selector, [
    String? id,
  ]) {
    return RtSelector.contextOf(this, id: id, selector: selector);
  }

  /// Gets the dependency of [T] type from the closest ancestor [RtProvider]
  /// and listens changes to the dependency or the states([RtState]) defined
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
  /// If [T] is nullable and no matching dependency is found,
  /// [watch] will return `null`.
  ///
  /// If [T] is non-nullable and the dependency obtained returned `null`,
  /// will throw [ProviderNullException].
  ///
  /// This method is equivalent to calling:
  ///
  /// ```dart
  /// RtProvider.contextOf<T>(context, listenStates: listenStates);
  /// ```
  T watch<T extends Object?>([ListenStates<T>? listenStates, String? id]) {
    return RtProvider.contextOf<T>(
      this,
      listenStates: listenStates,
      id: id,
    );
  }

  /// Gets the dependency of [T] type by [id] from the closest ancestor
  /// of [RtProvider] and watchs changes to the dependency or
  /// the states([RtState]) defined in first parameter([listenStates])
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
  /// If [T] is nullable and no matching dependency is found,
  /// [watchId] will return `null`.
  ///
  /// If [T] is non-nullable and the dependency obtained returned `null`,
  /// will throw [ProviderNullException].
  ///
  /// This method is equivalent to calling:
  ///
  /// ```dart
  /// RtProvider.contextOf<T>(context, id: id, listenStates: listenStates);
  /// ```
  T watchId<T extends Object?>(
    String id, [
    ListenStates<T>? listenStates,
  ]) {
    return RtProvider.contextOf<T>(
      this,
      id: id,
      listenStates: listenStates,
    );
  }

  /// Gets the dependency of [T] type with/without [id]
  /// from the closest ancestor [RtProvider].
  ///
  /// ```dart
  /// final appController = context.use<AppController>();
  /// final appControllerId = context.use<AppController>('uniqueId');
  /// final appControllerNullable = context.use<AppController?>();
  /// ```
  ///
  /// If [T] is nullable and no matching dependency is found,
  /// [use] will return `null`.
  ///
  /// If [T] is non-nullable and the dependency obtained returned `null`,
  /// will throw [ProviderNullException].
  ///
  /// This method is equivalent to calling:
  ///
  /// ```dart
  /// RtProvider.contextOf<T>(context, id: id, listen: false);
  /// ```
  T use<T extends Object?>([String? id]) {
    return RtProvider.contextOf<T>(this, id: id, listen: false);
  }
}
