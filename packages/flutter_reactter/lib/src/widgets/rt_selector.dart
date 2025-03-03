part of '../widgets.dart';

/// {@template flutter_reactter.rt_selector}
/// A [StatelessWidget] similar to [RtConsumer] but allowing to control
/// the rebuilding of widget tree by selecting the [RtState]s,
/// and a computed value.
///
/// [RtSelector] determines if [builder] needs to be rebuild again
/// by comparing the previous and new result of [Selector] and returns it.
/// This evaluation only occurs if one of the selected [RtState]s gets updated,
/// or by the dependency if the [selector] does not have any selected [RtState]s.
///
/// The [selector] property has two parameters, the first one is the instance
/// of [T] dependency which is obtained from the closest ancestor [RtProvider].
/// and the second one is a [Select] function which allows to wrapper any
/// [RtState]s to listen, and returns the value in each build. e.g:
///
/// ```dart
/// RtSelector<MyController, double>(
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
/// to wrap the app with [RtScope] for it to work properly. e.g:
///
/// ```dart
/// RtScope(
///   child: MyApp(),
/// )
///
/// // Now can use it without type like:
///
/// RtSelector(
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
/// [RtSelector] has same functionality as [RtSelector.contextOf].
///
///
/// Use [id] property to identify the [T] dependency.
///
/// Use [child] property to pass a [Widget] which to be built once only.
/// It will be sent through the [builder] callback, so you can incorporate it
/// into your build:
///
///```dart
/// RtSelector<MyController, String>(
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
/// * [RtState], a state in reactter.
/// * [RtConsumer], a widget that obtains an instance of [T] dependency
/// from the closest ancestor [RtProvider].
/// * [RtProvider], a widget that provides a [T] dependency through Widget.
/// {@endtemplate}
///

class RtSelector<T extends Object?, V> extends StatelessWidget {
  /// This identifier can be used to differentiate
  /// between multiple dependencies of the same [T] type
  /// in the widget tree when using [RtProvider].
  final String? id;

  /// Takes an [T] dependency and a [Select] function, and returns a
  /// value of [R] type.
  /// It can be used to compute a value based on the provided arguments.
  final Selector<T, V> selector;

  /// Use to pass a single child widget that will be built once
  /// and incorporated into the widget tree.
  final Widget? child;

  /// Method which is responsible for building the widget tree.
  ///
  /// Exposes the [BuildContext], the instance of [T] dependency,
  /// the comptued value of [V] type and the [child] widget as arguments,
  /// and returns a widget.
  final InstanceValueChildBuilder<T, V> builder;

  /// {@macro reactter_selector}
  const RtSelector({
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
  /// This evaluation only occurs if one of the selected [RtState]s gets updated,
  /// or by the dependency if the [selector] does not have any selected [RtState]s.
  ///
  /// The [selector] callback has two parameters, the first one is
  /// the instance of [T] dependency which is obtained from the closest ancestor
  /// of [RtProvider] and the second one is a [Select] function which
  /// allows to wrapper any [RtState]s to listen.
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
  static V contextOf<T extends Object?, V>(
    BuildContext context, {
    String? id,
    required Selector<T, V> selector,
  }) {
    final shouldFindProvider = T != getType<Object?>();
    final inheritedElement = shouldFindProvider
        ? ProvideImpl.getProviderInheritedElement<T>(context, id)
        : RtScope._getScopeInheritedElement(context);
    final instance = inheritedElement is ProviderElement<T?>
        ? inheritedElement.instance
        : null;

    final dependency = SelectDependency<T>(
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
