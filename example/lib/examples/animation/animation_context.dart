import 'package:example/examples/animation/use_animation.dart';
import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';

class AnimationContext extends ReactterContext {
  late final animation = UseAnimation<double>(
    AnimationOptions(
      tween: Tween(begin: 10, end: 200.0),
      duration: const Duration(milliseconds: 800),
      control: AnimationControl.mirror,
      curve: Curves.easeOut,
      fps: 12,
    ),
    this,
  );
  late final animation2 = UseAnimation<double>(
    AnimationOptions(
      tween: Tween(begin: 10, end: 100),
      delay: const Duration(seconds: 1),
      duration: const Duration(milliseconds: 600),
      control: AnimationControl.mirror,
      curve: Curves.easeOut,
    ),
    this,
  );
}
