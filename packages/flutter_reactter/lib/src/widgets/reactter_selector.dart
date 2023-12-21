part of '../widgets.dart';

/// {@template reactter_selector}
/// A [StatelessWidget] similar to [ReactterConsumer] but allowing to control
/// the rebuilding of widget tree by selecting the [ReactterState]s,
/// and a computed value.
///
/// [ReactterSelector] determines if [builder] needs to be rebuild again
/// by comparing the previous and new result of [Selector] and returns it.
/// This evaluation only occurs if one of the selected [ReactterState]s gets updated,
/// or by the instance if the [selector] does not have any selected [ReactterState]s.
///
/// The [selector] property has a two arguments, the first one is the instance
/// of [T] type which is obtained from the closest ancestor [ReactterProvider].
/// and the second one is a [Select] function which allows to wrapper any
/// [ReactterState]s to listen, and returns the value in each build. e.g:
///
/// ```dart
/// ReactterSelector<MyController, double>(
///   selector: (MyController inst, Select $) {
///     final num1 = $(inst.intState).value;
///     final num2 = $(inst.doubleState).value;
///
///     return (num1 + num2).clamp(0, 100);
///   },
///   builder: (BuildContext context, MyController inst, double value, Widget? child) {
///     return Text('Computed value: $value');
///   },
/// )
/// ```
///
/// It does not have the [T] tyoe, it is necessary
/// to wrap the app with [ReactterScope] for it to work properly. e.g:
///
/// ```dart
/// ReactterScope(
///   child: MyApp(),
/// )
///
/// // Now can use it without type like:
///
/// ReactterSelector(
///   selector: (_, $) => $(myListState).value.length,
///   builder: (context, _, itemCount, child) {
///     return ListView.builder(
///       itemCount: itemCount,
///       itemBuilder: (context, index) {
///         [...]
///       },
///     );
///   },
/// )
/// ```
///
/// [ReactterSelector] has same functionality as [ReactterSelector.contextOf].
///
///
/// Use [id] property to identify the [T] instance.
///
/// Use [child] property to pass a [Widget] which to be built once only.
/// It will be sent through the [builder] callback, so you can incorporate it
/// into your build:
///
///```dart
/// ReactterSelector<MyController, String>(
///   selector: (inst, $) => $(inst.strState).value.trim(),
///   child: Text("This widget build only once"),
///   builder: (context inst, value, child) {
///     return Column(
///       children: [
///         Text("value: $value"),
///         child,
///       ],
///     );
///   },
/// )
///```
///
/// See also:
///
/// * [ReactterState], a state in reactter.
/// * [ReactterConsumer], a widget that obtains an instance of [T] type
/// from the closest ancestor [ReactterProvider].
/// * [ReactterProvider], a widget that provides a [T] instance through Widget.
/// {@endtemplate}
///

class ReactterSelector<T extends Object?, V> extends StatelessWidget {
  /// This identifier can be used to differentiate
  /// between multiple instances of the same [T] type
  /// in the widget tree when using [ReactterProvider].
  final String? id;

  /// Takes an instance of [T] type and a [Select] function, and returns a
  /// value of [R] type.
  /// It can be used to compute a value based on the provided arguments.
  final Selector<T, V> selector;

  /// Use to pass a single child widget that will be built once
  /// and incorporated into the widget tree.
  final Widget? child;

  /// Method which is responsible for building the widget tree.
  ///
  /// Exposes the [BuildContext], the instance of [T] type,
  /// the comptued value of [V] type and the [child] widget as arguments,
  /// and returns a widget.
  final InstanceValueBuilder<T, V> builder;

  /// {@macro reactter_selector}
  const ReactterSelector({
    Key? key,
    this.id,
    required this.selector,
    this.child,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late T instance;
    final value = context.select<T, V>(
      (inst, $) {
        instance = inst;
        return selector(inst, $);
      },
      id,
    );

    return builder(context, instance, value, child);
  }

  /// Uses the [selector] callback, for determining if
  /// the widget tree of [context] needs to be rebuild by comparaing
  /// the previous and new result of [selector], and returns it.
  /// This evaluation only occurs if one of the selected [ReactterState]s gets updated,
  /// or by the instance if the [selector] does not have any selected [ReactterState]s.
  ///
  /// The [selector] callback has a two arguments, the first one is
  /// the instance of [T] type which is obtained from the closest ancestor
  /// of [ReactterProvider] and the second one is a [Select] function which
  /// allows to wrapper any [ReactterState]s to listen.
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
  static V contextOf<T extends Object?, V>(
    BuildContext context, {
    String? id,
    required Selector<T, V> selector,
  }) {
    final shouldFindProvider = T != getType<Object?>();
    final inheritedElement = shouldFindProvider
        ? ReactterProvider._getProviderInheritedElement<T>(context, id)
        : ReactterScope._getScopeInheritedElement(context);
    final instance = inheritedElement is ReactterProviderElement<T>
        ? inheritedElement.instance
        : null;

    final dependency = ReactterSelectDependency(
      instance: instance as T,
      computeValue: selector as dynamic,
    );

    context.dependOnInheritedElement(
      inheritedElement!,
      aspect: dependency,
    );

    return dependency.value;
  }
}
