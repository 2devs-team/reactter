// ignore_for_file: prefer_void_to_null

part of '../framework.dart';

@internal
abstract class ProviderBase<T extends Object?> extends Widget {
  /// {@template provider_base.id}
  /// It's used to identify the instance of [T] type
  /// that is provided by the provider.
  ///
  /// It allows you to have multiple instances of the same [T] type in
  /// your widget tree and differentiate between them.
  ///
  /// This can be useful when you want to provide
  /// different instances of a class to different parts of your application.
  /// {@endtemplate}
  final String? id;

  /// {@template provider_base.mode}
  /// It's used to specify the type of instance creation for the provided object.
  ///
  /// It is of mode [InstanceManageMode], which is an enum with three possible values:
  /// [InstanceManageMode.builder], [InstanceManageMode.factory] and [InstanceManageMode.singleton].
  /// {@endtemplate}
  final InstanceManageMode mode;

  /// {@template provider_base.instanceBuilder}
  /// Create a [T] instance.
  /// {@endtemplate}
  @protected
  final InstanceBuilder<T> instanceBuilder;

  /// {@template provider_base.init}
  /// Immediately create the instance defined
  /// on firts parameter([instanceBuilder]).
  /// {@endtemplate}
  @protected
  final bool init;

  /// {@template provider_base.isLazy}
  /// Lazily create the instance defined
  /// on firts parameter([instanceBuilder]).
  /// {@endtemplate}
  @protected
  final bool isLazy;

  /// {@template provider_base.builder}
  /// Method which has the render logic
  ///
  /// Exposes [BuilderContext], the instance and [child] widget as arguments.
  /// and returns a widget.
  /// {@endtemplate}
  @protected
  final InstanceChildBuilder<T>? builder;

  /// {@template provider_base.lazyBuilder}
  /// Method which has the render logic
  ///
  /// Exposes [BuilderContext] and [child] widget as arguments.
  /// and returns a widget.
  /// {@endtemplate}
  @protected
  final ChildBuilder? lazyBuilder;

  /// {@template provider_base.init}
  /// The child widget that will be wrapped by the provider.
  /// The child widget can be accessed within the `builder` method of the provider.
  /// {@endtemplate}
  final Widget? child;

  const ProviderBase(
    this.instanceBuilder, {
    Key? key,
    this.id,
    this.mode = InstanceManageMode.builder,
    this.init = false,
    this.isLazy = false,
    this.child,
    this.builder,
    this.lazyBuilder,
  }) : super(key: key);
}
