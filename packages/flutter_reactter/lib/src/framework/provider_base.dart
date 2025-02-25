// ignore_for_file: prefer_void_to_null

part of '../framework.dart';

@internal
abstract class ProviderBase<T extends Object?> extends Widget {
  /// {@template flutter_reactter.provider_base.id}
  /// It's used to identify the dependency of [T] type
  /// that is provided by the provider.
  ///
  /// It allows you to have multiple dependencies of the same [T] type in
  /// your widget tree and differentiate between them.
  ///
  /// This can be useful when you want to provide
  /// different dependencies of a class to different parts of your application.
  /// {@endtemplate}
  final String? id;

  /// {@template flutter_reactter.provider_base.mode}
  /// It's used to specify the type of dependency creation for the provided object.
  ///
  /// It is of mode [DependencyMode], which is an enum with three possible values:
  /// [DependencyMode.builder], [DependencyMode.factory] and [DependencyMode.singleton].
  /// {@endtemplate}
  final DependencyMode mode;

  /// {@template flutter_reactter.provider_base.instanceBuilder}
  /// Create a [T] instance.
  /// {@endtemplate}
  @protected
  final InstanceBuilder<T> instanceBuilder;

  /// {@template flutter_reactter.provider_base.init}
  /// Immediately create the dependency defined
  /// on firts parameter([instanceBuilder]).
  /// {@endtemplate}
  @protected
  final bool init;

  /// {@template flutter_reactter.provider_base.isLazy}
  /// Lazily create the dependency defined
  /// on firts parameter([instanceBuilder]).
  /// {@endtemplate}
  @protected
  final bool isLazy;

  /// {@template flutter_reactter.provider_base.builder}
  /// Method which has the render logic
  ///
  /// Exposes [BuilderContext], instance of the dependency and [child] widget as arguments.
  /// and returns a widget.
  /// {@endtemplate}
  @protected
  final InstanceChildBuilder<T>? builder;

  /// {@template flutter_reactter.provider_base.lazyBuilder}
  /// Method which has the render logic
  ///
  /// Exposes [BuilderContext] and [child] widget as arguments.
  /// and returns a widget.
  /// {@endtemplate}
  @protected
  final ChildBuilder? lazyBuilder;

  /// {@template flutter_reactter.provider_base.init}
  /// The child widget that will be wrapped by the provider.
  /// The child widget can be accessed within the `builder` method of the provider.
  /// {@endtemplate}
  final Widget? child;

  const ProviderBase(
    this.instanceBuilder, {
    Key? key,
    this.id,
    this.mode = DependencyMode.builder,
    this.init = false,
    this.isLazy = false,
    this.child,
    this.builder,
    this.lazyBuilder,
  }) : super(key: key);
}
